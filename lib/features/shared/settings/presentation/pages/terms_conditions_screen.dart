import 'package:flutter/material.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../widgets/settings_ui_components.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  static const List<String> _arabicArticles = [
    'المادة الأولى: التعريفات (المنصة، المستخدم، الناشر، العميل).',
    'المادة الثانية: طبيعة الخدمة.',
    'المادة الثالثة: التزامات المستخدم (تقديم معلومات صحيحة، عدم نشر محتوى مخالف، الالتزام بالأنظمة).',
    'المادة الرابعة: شروط الإعلانات.',
    'المادة الخامسة: العلاقة بين الأطراف (الاتفاق يتم بين العميل والناشر مباشرة، المنصة غير مسؤولة).',
    'المادة السادسة: المدفوعات (تتم خارج المنصة).',
    'المادة السابعة: المحتوى الممنوع.',
    'المادة الثامنة: الحسابات.',
    'المادة التاسعة: المسؤولية.',
    'المادة العاشرة: الإيقاف.',
    'المادة الحادية عشر: الخصوصية.',
    'المادة الثانية عشر: التعديلات.',
    'المادة الثالثة عشر: النزاعات وفق أنظمة المملكة العربية السعودية.',
  ];

  static const List<String> _englishArticles = [
    'Article 1: Definitions (Platform, User, Publisher/Advertiser, Client).',
    'Article 2: Nature of the Service.',
    'Article 3: User Obligations (providing accurate information, not publishing prohibited content, and complying with applicable regulations).',
    'Article 4: Advertisement Conditions.',
    'Article 5: Relationship Between Parties (agreements are made directly between client and publisher; the platform is not responsible for contract execution).',
    'Article 6: Payments (completed outside the platform).',
    'Article 7: Prohibited Content.',
    'Article 8: Accounts.',
    'Article 9: Liability.',
    'Article 10: Suspension.',
    'Article 11: Privacy.',
    'Article 12: Amendments.',
    'Article 13: Disputes are governed by the laws and regulations of the Kingdom of Saudi Arabia.',
  ];

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      appBarTitle: 'اتفاقية الاستخدام / Terms of Use',
      heroIcon: Icons.gavel_rounded,
      heroTitle: 'اتفاقية استخدام منصة ملم للمناسبات',
      heroSubtitle:
          'تنظم هذه الاتفاقية حقوق والتزامات جميع الأطراف لضمان تجربة واضحة وآمنة داخل المنصة.',
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: const [
            SettingsMetaChip(
              icon: Icons.menu_book_rounded,
              label: '13 مادة تنظيمية',
            ),
            SettingsMetaChip(
              icon: Icons.verified_user_outlined,
              label: 'الالتزام بالأنظمة',
            ),
            SettingsMetaChip(
              icon: Icons.public_rounded,
              label: 'نطاق قانوني سعودي',
            ),
          ],
        ),
        SizedBox(height: AppSpacing.md),
        const SettingsLocaleSection(
          localeTitle: 'العربية',
          icon: Icons.translate_rounded,
          intro:
              'تحدد هذه الاتفاقية الشروط والأحكام لاستخدام منصة ملم للمناسبات. باستخدام المنصة فإنك توافق على الالتزام بما يلي:',
          bullets: _arabicArticles,
          numbered: true,
        ),
        SizedBox(height: AppSpacing.md),
        const SettingsLocaleSection(
          localeTitle: 'English',
          icon: Icons.language_rounded,
          intro:
              'Introduction: This agreement defines the terms and conditions for using the Malam Events platform. By using the platform, you agree to the following:',
          bullets: _englishArticles,
          isEnglish: true,
          numbered: true,
        ),
      ],
    );
  }
}
