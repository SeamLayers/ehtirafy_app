import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/settings_ui_components.dart';

class SafetyCenterScreen extends StatelessWidget {
  const SafetyCenterScreen({super.key});

  static const List<String> _arabicReportingSteps = [
    'الإبلاغ على الإعلان المنشور من داخل صفحة الإعلان.',
    'الإبلاغ عن طريق (اتصل بنا).',
    'إبلاغ والتواصل مع هيئة حقوق الإنسان على الايميل: Info@ncct.gov.sa',
  ];

  static const List<String> _englishReportingSteps = [
    'Report the published ad directly from the ad page.',
    'Report through the Contact Us section.',
    'Report and communicate with the Human Rights authority via email: Info@ncct.gov.sa',
  ];

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      appBarTitle: 'مركز الأمان / Safety Center',
      heroIcon: Icons.health_and_safety_outlined,
      heroTitle: 'بيئة رقمية آمنة ومسؤولة',
      heroSubtitle:
          'تعمل منصة بطل بالشراكة مع الجهات المختصة لتعزيز الحماية ومنع أي محتوى أو نشاط مخالف.',
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: const [
            SettingsMetaChip(
              icon: Icons.gpp_good_outlined,
              label: 'مكافحة الاستغلال',
            ),
            SettingsMetaChip(
              icon: Icons.verified_outlined,
              label: 'شراكة رسمية',
            ),
            SettingsMetaChip(
              icon: Icons.report_gmailerrorred_outlined,
              label: 'قنوات بلاغ متعددة',
            ),
          ],
        ),
        SizedBox(height: 16.h),
        const SettingsLocaleSection(
          localeTitle: 'العربية',
          icon: Icons.translate_rounded,
          intro:
              'الحماية من استغلال البشر\nنعمل في منصة بطل مع هيئة حقوق الإنسان في السعودية (https://www.hrc.gov.sa) لمكافحة الاتجار بالبشر وتعزيز بيئة رقمية آمنة للجميع.\n\nطريقة الإبلاغ عن محتوى مخالف:',
          bullets: _arabicReportingSteps,
          numbered: true,
        ),
        SizedBox(height: 16.h),
        const SettingsLocaleSection(
          localeTitle: 'English',
          icon: Icons.language_rounded,
          intro:
              'Protection Against Human Exploitation\nAt Batal Platform, we work with the Human Rights Commission in Saudi Arabia (https://www.hrc.gov.sa) to combat human trafficking and maintain a safe digital environment for all users.\n\nHow to report violating content:',
          bullets: _englishReportingSteps,
          isEnglish: true,
          numbered: true,
        ),
      ],
    );
  }
}
