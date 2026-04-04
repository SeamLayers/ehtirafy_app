import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/settings_ui_components.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  static const List<String> _arabicSupportSteps = [
    'الضغط على رابط "اتصل بنا" داخل التطبيق.',
    'إرسال رسالة عبر البريد: photography@al-batal.com',
    'الاتصال المباشر على الرقم: +966 55 123 4567',
  ];

  static const List<String> _englishSupportSteps = [
    'Click the "Contact Us" link inside the app.',
    'Send an email to: photography@al-batal.com',
    'Call us directly at: +966 55 123 4567',
  ];

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      appBarTitle: 'اتصل بنا / Contact Us',
      heroIcon: Icons.support_agent_outlined,
      heroTitle: 'فريق دعم جاهز لمساعدتك',
      heroSubtitle:
          'لاستفساراتك أو الشكاوى، اختر القناة الأنسب وسنحرص على متابعة طلبك باهتمام ووضوح.',
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: const [
            SettingsMetaChip(icon: Icons.mail_outline, label: 'دعم عبر البريد'),
            SettingsMetaChip(icon: Icons.phone_outlined, label: 'تواصل مباشر'),
            SettingsMetaChip(
              icon: Icons.groups_2_outlined,
              label: 'قنوات اجتماعية',
            ),
          ],
        ),
        SizedBox(height: 16.h),
        const SettingsLocaleSection(
          localeTitle: 'العربية',
          icon: Icons.translate_rounded,
          intro:
              'إذا كان لديك أي استفسار أو رغبتك في تقديم شكوى، يمكنك التواصل معنا عبر الخطوات التالية:',
          bullets: _arabicSupportSteps,
          numbered: true,
        ),
        SizedBox(height: 16.h),
        const SettingsLocaleSection(
          localeTitle: 'English',
          icon: Icons.language_rounded,
          intro:
              'If you have any inquiry or wish to submit a complaint, you can contact us through the following steps:',
          bullets: _englishSupportSteps,
          isEnglish: true,
          numbered: true,
        ),
        SizedBox(height: 16.h),
        const SettingsInfoTile(
          icon: Icons.email_outlined,
          title: 'البريد الإلكتروني / Email',
          value: 'photography@al-batal.com',
        ),
        SizedBox(height: 10.h),
        const SettingsInfoTile(
          icon: Icons.call_outlined,
          title: 'الهاتف المباشر / Direct Call',
          value: '+966 55 123 4567',
        ),
        SizedBox(height: 10.h),
        const SettingsInfoTile(
          icon: Icons.facebook_outlined,
          title: 'Facebook',
          value: 'facebook.com/albatal',
        ),
        SizedBox(height: 10.h),
        const SettingsInfoTile(
          icon: Icons.alternate_email,
          title: 'X (Twitter)',
          value: '@al_batal',
        ),
        SizedBox(height: 10.h),
        const SettingsInfoTile(
          icon: Icons.camera_alt_outlined,
          title: 'Instagram',
          value: 'instagram.com/albatal',
        ),
        SizedBox(height: 10.h),
        const SettingsInfoTile(
          icon: Icons.chat_bubble_outline,
          title: 'Snapchat',
          value: '@albatal',
        ),
      ],
    );
  }
}
