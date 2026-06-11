import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const String _kBankName = 'مصرف الراجحي / Al Rajhi Bank';
const String _kBankAccountNumber = '609000010006086201357';
const String _kBankIban = 'SA3380000609608016201357';

enum FinancialPledgeRole { advertiser, client }

class FinancialPledgeSection extends StatelessWidget {
  final FinancialPledgeRole role;
  final bool accepted;
  final ValueChanged<bool> onAcceptedChanged;
  final String agreementAr;
  final String agreementEn;
  final bool initiallyExpanded;

  const FinancialPledgeSection({
    super.key,
    required this.role,
    required this.accepted,
    required this.onAcceptedChanged,
    required this.agreementAr,
    required this.agreementEn,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gold.withValues(alpha: 0.10),
            AppColors.gold.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.12),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.gavel_rounded,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: AppSpacing.sm + 2.w),
              Expanded(
                child: Text(
                  _headerText(),
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: AppColors.textLight.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.18)),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                initiallyExpanded: initiallyExpanded,
                tilePadding: EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                childrenPadding: EdgeInsetsDirectional.fromSTEB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                collapsedIconColor: AppColors.primary,
                iconColor: AppColors.primary,
                leading: Icon(
                  Icons.description_outlined,
                  color: AppColors.primary,
                  size: 18.sp,
                ),
                title: Text(
                  'عرض نص التعهد الكامل / View full pledge',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                shape: const Border(),
                collapsedShape: const Border(),
                children: [
                  Text(
                    _arabicText(),
                    style: textTheme.bodySmall?.copyWith(
                      height: 1.7,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Divider(
                    color: AppColors.gold.withValues(alpha: 0.35),
                    height: 1,
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    _englishText(),
                    style: textTheme.bodySmall?.copyWith(
                      height: 1.7,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          InkWell(
            onTap: () => onAcceptedChanged(!accepted),
            borderRadius: BorderRadius.circular(12.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsetsDirectional.fromSTEB(
                AppSpacing.sm,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: accepted
                    ? AppColors.gold.withValues(alpha: 0.14)
                    : AppColors.textLight.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: accepted
                      ? AppColors.gold.withValues(alpha: 0.45)
                      : AppColors.gold.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: accepted,
                    activeColor: AppColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    onChanged: (value) => onAcceptedChanged(value ?? false),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      '$agreementAr / $agreementEn',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.5,
                        fontWeight:
                            accepted ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showBankAccountDialog(context),
              icon: Icon(
                Icons.account_balance_outlined,
                color: AppColors.primary,
                size: 18.sp,
              ),
              label: Text(
                'تفاصيل الحساب للدفع / Bank account details',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                backgroundColor: AppColors.gold.withValues(alpha: 0.10),
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 2.h,
                ),
                side: BorderSide(
                  color: AppColors.gold.withValues(alpha: 0.45),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBankAccountDialog(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.backgroundLight,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          titlePadding: EdgeInsets.all(AppSpacing.lg),
          contentPadding: EdgeInsetsDirectional.fromSTEB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          actionsPadding: EdgeInsets.all(AppSpacing.md),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.account_balance_outlined,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: AppSpacing.sm + 2.w),
              Expanded(
                child: Text(
                  'تفاصيل الحساب البنكي / Bank Account Details',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bankAccountRow(
                  context: dialogContext,
                  label: 'اسم البنك / Bank',
                  value: _kBankName,
                ),
                SizedBox(height: AppSpacing.sm),
                _bankAccountRow(
                  context: dialogContext,
                  label: 'رقم الحساب / Account Number',
                  value: _kBankAccountNumber,
                  forceLtr: true,
                ),
                SizedBox(height: AppSpacing.sm),
                _bankAccountRow(
                  context: dialogContext,
                  label: 'رقم الآيبان / IBAN',
                  value: _kBankIban,
                  forceLtr: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm + 2.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: const Text('إغلاق / Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _bankAccountRow({
    required BuildContext context,
    required String label,
    required String value,
    bool forceLtr = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.textLight.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: SelectableText(
                    value,
                    textDirection: forceLtr ? TextDirection.ltr : null,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.xs),
          IconButton(
            onPressed: () => _copyToClipboard(context, value),
            visualDensity: VisualDensity.compact,
            tooltip: 'نسخ / Copy',
            icon: Icon(
              Icons.copy_outlined,
              color: AppColors.primary,
              size: 18.sp,
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم النسخ / Copied'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _headerText() {
    switch (role) {
      case FinancialPledgeRole.advertiser:
        return 'التعهد المالي للمعلن / Advertiser Commitment';
      case FinancialPledgeRole.client:
        return 'التعهد المالي للعميل / Client Commitment';
    }
  }

  String _arabicRoleLabel() {
    switch (role) {
      case FinancialPledgeRole.advertiser:
        return 'المعلن';
      case FinancialPledgeRole.client:
        return 'العميل';
    }
  }

  String _englishText() {
    switch (role) {
      case FinancialPledgeRole.advertiser:
        return 'Advertiser Commitment\n'
            'I, the advertiser, hereby commit to:\n'
            '• Pay Events Lens platform fees (1% of the value) upon publishing the ad.\n'
            '• Settle fees within 7 days of transaction completion.\n'
            '(Included Quranic verses emphasizing honesty, trust, and fulfilling covenants).\n\n'
            'All rights reserved © Events Lens';
      case FinancialPledgeRole.client:
        return 'Client Commitment\n'
            'I, the client, hereby commit to:\n'
            '• Pay Events Lens platform fees (1% of the value) upon initiating the contract.\n'
            '• Settle fees within 7 days of transaction completion.\n'
            '(Included Quranic verses emphasizing honesty, trust, and fulfilling covenants).\n\n'
            'All rights reserved © Events Lens';
    }
  }

  String _arabicText() {
    return 'أتعهد أنا ${_arabicRoleLabel()} بما يلي:\n'
        '• دفع رسوم منصة عدسة المناسبات والتي تبلغ 1% من قيمة كل إعلان عند نشر الإعلان على المنصة.\n'
        '• دفع الرسوم خلال 7 أيام من تمام العملية أو استلام المبلغ كاملاً.\n\n'
        'الوفاء بالعهد: قال الله تعالى: "وَأَوْفُوا بِالْعَهْدِ إِنَّ الْعَهْدَ كَانَ مَسْؤُولًا" (الأنعام: 152)\n'
        'الأمانة وعدم الغش: قال الله تعالى: "إِنَّ اللَّهَ يَأْمُرُكُمْ أَنْ تُؤَدُّوا الْأَمَانَاتِ إِلَى أَهْلِهَا" (النساء: 58)\n'
        'عدم التعدي على الحقوق المالية للآخرين: قال الله تعالى: "وَلَا تَبْخَسُوا النَّاسَ أَشْيَاءَهُمْ" (المعارج: 85)\n'
        'الالتزام بالحق: قال الله تعالى: "يَا أَيُّهَا الَّذِينَ آمَنُوا كُونُوا قَوَّامِينَ بِالْقِسْطِ شُهَدَاءَ لِلَّهِ" (النساء: 135)\n\n'
        'جميع الحقوق محفوظة © عدسة المناسبات';
  }
}

Future<bool> showFinancialPledgeAgreementDialog(
  BuildContext context, {
  required FinancialPledgeRole role,
  required String agreementAr,
  required String agreementEn,
}) async {
  bool accepted = false;

  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      final isArabic =
          Localizations.localeOf(dialogContext).languageCode.toLowerCase().startsWith('ar');

      return StatefulBuilder(
        builder: (statefulContext, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.backgroundLight,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            titlePadding: EdgeInsets.all(AppSpacing.lg),
            contentPadding: EdgeInsetsDirectional.symmetric(
              horizontal: AppSpacing.lg,
            ),
            actionsPadding: EdgeInsets.all(AppSpacing.md),
            title: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.verified_user_outlined,
                    color: AppColors.primary,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: AppSpacing.sm + 2.w),
                Expanded(
                  child: Text(
                    isArabic ? 'التعهد قبل المتابعة' : 'Pledge Before Proceeding',
                    style: Theme.of(statefulContext)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                  ),
                ),
              ],
            ),
            content: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(statefulContext).size.height * 0.65,
              ),
              child: SingleChildScrollView(
                child: FinancialPledgeSection(
                  role: role,
                  accepted: accepted,
                  initiallyExpanded: true,
                  agreementAr: agreementAr,
                  agreementEn: agreementEn,
                  onAcceptedChanged: (value) {
                    setDialogState(() => accepted = value);
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm + 2.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(isArabic ? 'إلغاء' : 'Cancel'),
              ),
              ElevatedButton(
                onPressed: accepted
                    ? () => Navigator.of(dialogContext).pop(true)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textLight,
                  disabledBackgroundColor:
                      AppColors.gold.withValues(alpha: 0.30),
                  disabledForegroundColor:
                      AppColors.textLight.withValues(alpha: 0.85),
                  elevation: 0,
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm + 2.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  isArabic ? 'متابعة' : 'Continue',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
      );
    },
  );

  return result ?? false;
}
