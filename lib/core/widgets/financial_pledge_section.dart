import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.gavel_rounded, color: AppColors.primary, size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  _headerText(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              initiallyExpanded: initiallyExpanded,
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              collapsedIconColor: AppColors.primary,
              iconColor: AppColors.primary,
              title: Text(
                'عرض نص التعهد الكامل / View full pledge',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              shape: const Border(),
              collapsedShape: const Border(),
              children: [
                Text(
                  _arabicText(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    height: 1.6,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                Divider(color: AppColors.gold.withValues(alpha: 0.45)),
                SizedBox(height: 12.h),
                Text(
                  _englishText(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    height: 1.6,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: accepted,
                activeColor: AppColors.primary,
                onChanged: (value) => onAcceptedChanged(value ?? false),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onAcceptedChanged(!accepted),
                  child: Padding(
                    padding: EdgeInsets.only(top: 12.h),
                    child: Text(
                      '$agreementAr / $agreementEn',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
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
            '• Pay Batal Platform fees (1% of the value) upon publishing the ad.\n'
            '• Settle fees within 7 days of transaction completion.\n'
            '(Included Quranic verses emphasizing honesty, trust, and fulfilling covenants).\n\n'
            'All rights reserved © Batal Photography & Events';
      case FinancialPledgeRole.client:
        return 'Client Commitment\n'
            'I, the client, hereby commit to:\n'
            '• Pay Batal Platform fees (1% of the value) upon initiating the contract.\n'
            '• Settle fees within 7 days of transaction completion.\n'
            '(Included Quranic verses emphasizing honesty, trust, and fulfilling covenants).\n\n'
            'All rights reserved © Batal Photography & Events';
    }
  }

  String _arabicText() {
    return 'أتعهد أنا ${_arabicRoleLabel()} بما يلي:\n'
        '• دفع رسوم منصة بطل والتي تبلغ 1% من قيمة كل إعلان عند نشر الإعلان على المنصة.\n'
        '• دفع الرسوم خلال 7 أيام من تمام العملية أو استلام المبلغ كاملاً.\n\n'
        'الوفاء بالعهد: قال الله تعالى: "وَأَوْفُوا بِالْعَهْدِ إِنَّ الْعَهْدَ كَانَ مَسْؤُولًا" (الأنعام: 152)\n'
        'الأمانة وعدم الغش: قال الله تعالى: "إِنَّ اللَّهَ يَأْمُرُكُمْ أَنْ تُؤَدُّوا الْأَمَانَاتِ إِلَى أَهْلِهَا" (النساء: 58)\n'
        'عدم التعدي على الحقوق المالية للآخرين: قال الله تعالى: "وَلَا تَبْخَسُوا النَّاسَ أَشْيَاءَهُمْ" (المعارج: 85)\n'
        'الالتزام بالحق: قال الله تعالى: "يَا أَيُّهَا الَّذِينَ آمَنُوا كُونُوا قَوَّامِينَ بِالْقِسْطِ شُهَدَاءَ لِلَّهِ" (النساء: 135)\n\n'
        'جميع الحقوق محفوظة © بطل للتصوير والمناسبات';
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
            title: Text(
              isArabic ? 'التعهد قبل المتابعة' : 'Pledge Before Proceeding',
              style: Theme.of(statefulContext).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
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
                child: Text(isArabic ? 'إلغاء' : 'Cancel'),
              ),
              ElevatedButton(
                onPressed: accepted
                    ? () => Navigator.of(dialogContext).pop(true)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(isArabic ? 'متابعة' : 'Continue'),
              ),
            ],
          );
        },
      );
    },
  );

  return result ?? false;
}
