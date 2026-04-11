import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import '../widgets/settings_ui_components.dart';

class PlatformFeesScreen extends StatelessWidget {
  const PlatformFeesScreen({super.key});

  static const List<String> _arabicFeeNotes = [
    'تقوم منصة بطل بتحصيل رسوم قدرها 1% من قيمة كل إعلان يتم عرضه.',
    'يتم تطبيق الرسوم بشكل واضح وموحد على الإعلانات المنشورة.',
  ];

  static const List<String> _englishFeeNotes = [
    'Batal Platform collects a fee of 1% from the value of each published advertisement.',
    'The fee policy is applied clearly and consistently across published ads.',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SettingsPageScaffold(
      appBarTitle: 'رسوم المنصة / Platform Fees',
      heroIcon: Icons.receipt_long_outlined,
      heroTitle: 'سياسة رسوم واضحة',
      heroSubtitle:
          'نعرض تفاصيل الرسوم والبيانات المالية بوضوح كامل لضمان الشفافية بين جميع الأطراف.',
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: const [
            SettingsMetaChip(
              icon: Icons.percent_rounded,
              label: 'رسوم ثابتة 1%',
            ),
            SettingsMetaChip(
              icon: Icons.visibility_outlined,
              label: 'شفافية مالية',
            ),
            SettingsMetaChip(
              icon: Icons.approval_outlined,
              label: 'تطبيق موحد',
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gold.withValues(alpha: 0.16),
                AppColors.gold.withValues(alpha: 0.08),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
          ),
          child: Row(
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.percent_rounded,
                  color: AppColors.gold,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رسوم المنصة / Platform Fee',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.75,
                        ),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '1%',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        const SettingsLocaleSection(
          localeTitle: 'العربية',
          icon: Icons.translate_rounded,
          intro: 'رسوم المنصة:',
          bullets: _arabicFeeNotes,
        ),
        SizedBox(height: 16.h),
        const SettingsLocaleSection(
          localeTitle: 'English',
          icon: Icons.language_rounded,
          intro: 'Platform Fees:',
          bullets: _englishFeeNotes,
          isEnglish: true,
        ),
        SizedBox(height: 16.h),
        const SettingsInfoTile(
          icon: Icons.account_balance_outlined,
          title: 'رقم الحساب / Account Number',
          value: '609000010006086201357',
        ),
        SizedBox(height: 10.h),
        const SettingsInfoTile(
          icon: Icons.credit_card_outlined,
          title: 'رقم الآيبان / IBAN',
          value: 'SA3380000609608016201357',
        ),
        SizedBox(height: 10.h),
        const SettingsInfoTile(
          icon: Icons.person_outline,
          title: 'اسم مستخدم الراجحي / Al Rajhi Username',
          value: '-',
        ),
        SizedBox(height: 10.h),
        const SettingsInfoTile(
          icon: Icons.badge_outlined,
          title: 'رقم العضوية / Membership Number',
          value: '-',
        ),
        SizedBox(height: 10.h),
        const SettingsInfoTile(
          icon: Icons.confirmation_number_outlined,
          title: 'رقم العميل / Customer Number',
          value: '-',
        ),
      ],
    );
  }
}
