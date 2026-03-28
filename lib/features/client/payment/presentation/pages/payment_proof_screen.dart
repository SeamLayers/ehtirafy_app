import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../cubit/payment_proof_cubit.dart';
import '../cubit/payment_proof_state.dart';

class PaymentProofScreen extends StatefulWidget {
  final String contractId;
  final String advertisementId;

  const PaymentProofScreen({
    super.key,
    required this.contractId,
    required this.advertisementId,
  });

  @override
  State<PaymentProofScreen> createState() => _PaymentProofScreenState();
}

class _PaymentProofScreenState extends State<PaymentProofScreen> {
  late final TextEditingController _senderNameController;
  late final TextEditingController _transferDateController;
  late final TextEditingController _transferReferenceController;
  late final TextEditingController _notesController;

  String _selectedFilePath = '';
  String _selectedFileName = '';

  @override
  void initState() {
    super.initState();
    _senderNameController = TextEditingController();
    _transferDateController = TextEditingController();
    _transferReferenceController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _senderNameController.dispose();
    _transferDateController.dispose();
    _transferReferenceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      _transferDateController.text =
          DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _selectFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedFilePath = pickedFile.path;
        _selectedFileName = pickedFile.name;
      });
      context.read<PaymentProofCubit>().onFileSelected(
            _selectedFileName,
            _selectedFilePath,
          );
    }
  }

  void _clearFile() {
    setState(() {
      _selectedFilePath = '';
      _selectedFileName = '';
    });
    context.read<PaymentProofCubit>().onFileClear();
  }

  void _submitPaymentProof() {
    // Validation
    if (_senderNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال اسم المُرسل')),
      );
      return;
    }

    if (_transferDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تحديد تاريخ التحويل')),
      );
      return;
    }

    if (_selectedFilePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء تحميل إثبات الدفع')),
      );
      return;
    }

    final transferDate = DateFormat('yyyy-MM-dd').parse(_transferDateController.text);

    context.read<PaymentProofCubit>().submitPaymentProof(
          contractId: widget.advertisementId,
          senderName: _senderNameController.text.trim(),
          transferDate: transferDate,
          proofFilePath: _selectedFilePath,
          transferReference: _transferReferenceController.text.trim(),
          notes: _notesController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('payment_proof_title'.tr()),
        centerTitle: true,
      ),
      body: BlocConsumer<PaymentProofCubit, PaymentProofState>(
        listener: (context, state) {
          if (state is PaymentProofSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is PaymentProofError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          // Show success view after payment proof submitted
          if (state is PaymentProofSubmitted) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(32.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 60.h),
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.shade50,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 64.sp,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'payment_proof_submitted_title'.tr(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2B2B2B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'payment_proof_submitted_message'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        onPressed: () => context.pop(),
                        child: Text(
                          'back_to_contract'.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instructions
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Text(
                    'payment_proof_instruction'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.blue.shade900,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),

                // Sender Name
                CustomTextField(
                  controller: _senderNameController,
                  label: 'sender_name'.tr(),
                  hint: 'enter_sender_name'.tr(),
                  prefixIcon: const Icon(Icons.person),
                  enabled: state is! PaymentProofLoading,
                ),
                SizedBox(height: 16.h),

                // Transfer Date
                GestureDetector(
                  onTap: state is PaymentProofLoading ? null : _selectDate,
                  child: CustomTextField(
                    controller: _transferDateController,
                    label: 'transfer_date'.tr(),
                    hint: 'select_date'.tr(),
                    prefixIcon: const Icon(Icons.calendar_today),
                    enabled: false,
                  ),
                ),
                SizedBox(height: 16.h),

                // Transfer Reference (Optional)
                CustomTextField(
                  controller: _transferReferenceController,
                  label: 'transfer_reference'.tr(),
                  hint: 'optional_transfer_ref'.tr(),
                  prefixIcon: const Icon(Icons.note),
                  enabled: state is! PaymentProofLoading,
                ),
                SizedBox(height: 16.h),

                // Notes (Optional)
                CustomTextField(
                  controller: _notesController,
                  label: 'notes'.tr(),
                  hint: 'additional_notes'.tr(),
                  prefixIcon: const Icon(Icons.description),
                  maxLines: 3,
                  enabled: state is! PaymentProofLoading,
                ),
                SizedBox(height: 24.h),

                // File Upload Section
                _buildFileUploadSection(state),
                SizedBox(height: 32.h),

                // Submit Button
                SizedBox(
                  height: 56.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    onPressed: state is PaymentProofLoading ? null : _submitPaymentProof,
                    child: state is PaymentProofLoading
                        ? SizedBox(
                            height: 24.h,
                            width: 24.w,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : Text(
                            'submit_proof'.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFileUploadSection(PaymentProofState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'proof_of_payment'.tr(),
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        if (_selectedFileName.isEmpty)
          GestureDetector(
            onTap: state is PaymentProofLoading ? null : _selectFile,
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(10.r),
                color: Colors.grey.shade50,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'tap_to_upload'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'accepted_formats'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.green.shade50,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'file_selected'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        _selectedFileName,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (state is! PaymentProofLoading)
                  GestureDetector(
                    onTap: _clearFile,
                    child: Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 24.sp,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
