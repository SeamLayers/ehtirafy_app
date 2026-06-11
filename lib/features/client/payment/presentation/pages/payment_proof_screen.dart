import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/rtl_back_button.dart';
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
    if (!mounted) return;

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: const RtlBackButton(),
        title: Text(
          'payment_proof_title'.tr(),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: BlocConsumer<PaymentProofCubit, PaymentProofState>(
        listener: (context, state) {
          if (state is PaymentProofSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is PaymentProofError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          // Show success view after payment proof submitted
          if (state is PaymentProofSubmitted) {
            return _buildSuccessView(theme);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instructions
                _buildInstructionBanner(theme),
                SizedBox(height: AppSpacing.lg),

                // Form card
                _buildFormCard(theme, state),
                SizedBox(height: AppSpacing.lg),

                // File Upload Section
                _buildUploadCard(theme, state),
                SizedBox(height: AppSpacing.xl),

                // Submit Button
                PrimaryButton(
                  text: 'submit_proof'.tr(),
                  isLoading: state is PaymentProofLoading,
                  onPressed: _submitPaymentProof,
                ),
                SizedBox(height: AppSpacing.sm),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuccessView(ThemeData theme) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: AppSpacing.xxl),
            Container(
              width: 112.w,
              height: 112.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.success.withValues(alpha: 0.10),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.25),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 64.sp,
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              'payment_proof_submitted_title'.tr(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              'payment_proof_submitted_message'.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              text: 'back_to_contract'.tr(),
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionBanner(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.30)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.info,
            size: 22.sp,
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'payment_proof_instruction'.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(ThemeData theme, PaymentProofState state) {
    final bool isLoading = state is PaymentProofLoading;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sender Name
          CustomTextField(
            controller: _senderNameController,
            label: 'sender_name'.tr(),
            hint: 'enter_sender_name'.tr(),
            prefixIcon: const Icon(Icons.person_outline_rounded),
            enabled: !isLoading,
          ),
          SizedBox(height: AppSpacing.md),

          // Transfer Date
          GestureDetector(
            onTap: isLoading ? null : _selectDate,
            child: CustomTextField(
              controller: _transferDateController,
              label: 'transfer_date'.tr(),
              hint: 'select_date'.tr(),
              prefixIcon: const Icon(Icons.calendar_today_rounded),
              enabled: false,
            ),
          ),
          SizedBox(height: AppSpacing.md),

          // Transfer Reference (Optional)
          CustomTextField(
            controller: _transferReferenceController,
            label: 'transfer_reference'.tr(),
            hint: 'optional_transfer_ref'.tr(),
            prefixIcon: const Icon(Icons.tag_rounded),
            enabled: !isLoading,
          ),
          SizedBox(height: AppSpacing.md),

          // Notes (Optional)
          CustomTextField(
            controller: _notesController,
            label: 'notes'.tr(),
            hint: 'additional_notes'.tr(),
            prefixIcon: const Icon(Icons.description_outlined),
            maxLines: 3,
            enabled: !isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard(ThemeData theme, PaymentProofState state) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: _cardDecoration(),
      child: _buildFileUploadSection(theme, state),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      border: Border.all(color: AppColors.grey200),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowLight,
          blurRadius: 16.r,
          offset: Offset(0, 6.h),
          spreadRadius: -4.r,
        ),
      ],
    );
  }

  Widget _buildFileUploadSection(ThemeData theme, PaymentProofState state) {
    final bool isLoading = state is PaymentProofLoading;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4.w,
              height: 16.h,
              margin: EdgeInsetsDirectional.only(end: 8.w),
              decoration: BoxDecoration(
                color: AppColors.gold,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            Flexible(
              child: Text(
                'proof_of_payment'.tr(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        if (_selectedFileName.isEmpty)
          GestureDetector(
            onTap: isLoading ? null : _selectFile,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.45),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(16.r),
                color: AppColors.gold.withValues(alpha: 0.05),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold.withValues(alpha: 0.12),
                    ),
                    child: Icon(
                      Icons.cloud_upload_outlined,
                      size: 32.sp,
                      color: AppColors.gold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'tap_to_upload'.tr(),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'accepted_formats'.tr(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.40),
              ),
              borderRadius: BorderRadius.circular(16.r),
              color: AppColors.success.withValues(alpha: 0.08),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.success,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'file_selected'.tr(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _selectedFileName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (!isLoading)
                  GestureDetector(
                    onTap: _clearFile,
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.error.withValues(alpha: 0.10),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColors.error,
                        size: 20.sp,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
