import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/manager/contract_details_cubit.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/manager/contract_details_state.dart';
import 'package:ehtirafy_app/features/shared/payment/presentation/pages/payment_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MockPaymentFormScreen extends StatefulWidget {
  final String contractId;
  final double amount;

  const MockPaymentFormScreen({
    super.key,
    required this.contractId,
    required this.amount,
  });

  @override
  State<MockPaymentFormScreen> createState() => _MockPaymentFormScreenState();
}

class _MockPaymentFormScreenState extends State<MockPaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContractDetailsCubit, ContractDetailsState>(
      listener: (context, state) {
        if (state is ContractDetailsError) {
          setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ContractDetailsSuccess) {
           // Navigate to success screen
           Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (context) => const PaymentSuccessScreen()),
           );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الدفع"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "تفاصيل البطاقة (محاكاة)",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),
                _buildTextField("رقم البطاقة", "4242 4242 4242 4242", Icons.credit_card),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(child: _buildTextField("تاريخ الانتهاء", "MM/YY", Icons.calendar_today)),
                    SizedBox(width: 16.w),
                    Expanded(child: _buildTextField("CVV", "123", Icons.lock)),
                  ],
                ),
                SizedBox(height: 16.h),
                _buildTextField("اسم حامل البطاقة", "الاسم الكامل", Icons.person),
                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: _isProcessing
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isProcessing = true);
                              // Trigger the existing payment logic
                              context.read<ContractDetailsCubit>().payContract(
                                    widget.contractId,
                                    widget.amount,
                                  );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isProcessing
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "دفع ${widget.amount} ر.س",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
        SizedBox(height: 8.h),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          ),
          validator: (val) => val == null || val.isEmpty ? "مطلوب" : null,
        ),
      ],
    );
  }
}
