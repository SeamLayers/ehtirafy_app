import 'package:flutter/material.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../widgets/settings_ui_components.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const List<String> _arabicPrinciples = [
    'التصفح: لم يتم تصميم المنصة لتجميع بياناتك الشخصية عند التصفح العادي.',
    'عنوان بروتوكول الإنترنت (IP): قد يتم تسجيله لأغراض الحماية والتحسين والتحليل الفني.',
    'الروابط بالمواقع الأخرى: قد تحتوي المنصة على روابط خارجية ولسنا مسؤولين عن سياسات الخصوصية في تلك المواقع.',
    'إفشاء المعلومات: لا يتم الإفصاح عن بياناتك إلا وفق الأنظمة المعمول بها أو بموافقتك.',
    'البيانات لتنفيذ المعاملات: قد نستخدم البيانات اللازمة لإتمام الطلبات والتواصل المرتبط بالخدمة.',
    'إفشاء المعلومات لطرف ثالث: لا يتم مشاركة بياناتك مع طرف ثالث إلا عند الضرورة التشغيلية والقانونية.',
  ];

  static const List<String> _englishPrinciples = [
    'Browsing: The platform is not designed to collect your personal data during normal browsing.',
    'Internet Protocol (IP): Your IP address may be logged for security, optimization, and technical analytics purposes.',
    'Links to Other Websites: The platform may contain external links, and we are not responsible for their privacy policies.',
    'Disclosure of Information: Your data is not disclosed except as required by applicable laws or with your consent.',
    'Data for Transaction Execution: We may use required information to complete transactions and provide related service communication.',
    'Third-Party Disclosure: Data is shared with third parties only when operationally or legally necessary.',
  ];

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      appBarTitle: 'الخصوصية وبيان سرية المعلومات / Privacy Policy',
      heroIcon: Icons.shield_moon_outlined,
      heroTitle: 'خصوصيتك أولوية في منصة عدسة المناسبات',
      heroSubtitle:
          'نلتزم بمعايير واضحة لحماية البيانات، مع شفافية كاملة حول كيفية استخدام المعلومات.',
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: const [
            SettingsMetaChip(
              icon: Icons.lock_outline_rounded,
              label: 'سياسات حماية واضحة',
            ),
            SettingsMetaChip(icon: Icons.policy_outlined, label: 'إفصاح منضبط'),
            SettingsMetaChip(
              icon: Icons.security_outlined,
              label: 'استخدام آمن للبيانات',
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        const SettingsLocaleSection(
          localeTitle: 'العربية',
          icon: Icons.translate_rounded,
          intro:
              'نقدر مخاوفكم واهتمامكم بشأن خصوصية بياناتكم على شبكة الإنترنت.',
          bullets: _arabicPrinciples,
        ),
        SizedBox(height: AppSpacing.md),
        const SettingsLocaleSection(
          localeTitle: 'English',
          icon: Icons.language_rounded,
          intro:
              'We value your concerns regarding the privacy of your data online.',
          bullets: _englishPrinciples,
          isEnglish: true,
        ),
      ],
    );
  }
}
