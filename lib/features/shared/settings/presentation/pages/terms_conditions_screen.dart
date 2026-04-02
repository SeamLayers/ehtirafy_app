import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  static const String _arabicContent =
      'تحدد هذه الاتفاقية الشروط والأحكام لاستخدام منصة بطل للتصوير والمناسبات. باستخدام المنصة فإنك توافق على الالتزام بما يلي:\n\n'
      '• المادة الأولى: التعريفات (المنصة، المستخدم، الناشر، العميل).\n'
      '• المادة الثانية: طبيعة الخدمة.\n'
      '• المادة الثالثة: التزامات المستخدم (تقديم معلومات صحيحة، عدم نشر محتوى مخالف، الالتزام بالأنظمة).\n'
      '• المادة الرابعة: شروط الإعلانات.\n'
      '• المادة الخامسة: العلاقة بين الأطراف (الاتفاق يتم بين العميل والناشر مباشرة، المنصة غير مسؤولة).\n'
      '• المادة السادسة: المدفوعات (تتم خارج المنصة).\n'
      '• المادة السابعة: المحتوى الممنوع.\n'
      '• المادة الثامنة: الحسابات.\n'
      '• المادة التاسعة: المسؤولية.\n'
      '• المادة العاشرة: الإيقاف.\n'
      '• المادة الحادية عشر: الخصوصية.\n'
      '• المادة الثانية عشر: التعديلات.\n'
      '• المادة الثالثة عشر: النزاعات وفق أنظمة المملكة العربية السعودية.';

  static const String _englishContent =
      'Introduction: This agreement defines the terms and conditions for using the Batal Photography & Events Platform. By using the platform, you agree to the following:\n\n'
      '• Article 1: Definitions (Platform, User, Publisher/Advertiser, Client).\n'
      '• Article 2: Nature of the Service.\n'
      '• Article 3: User Obligations (providing accurate information, not publishing prohibited content, and complying with applicable regulations).\n'
      '• Article 4: Advertisement Conditions.\n'
      '• Article 5: Relationship Between Parties (agreements are made directly between client and publisher; the platform is not responsible for contract execution).\n'
      '• Article 6: Payments (completed outside the platform).\n'
      '• Article 7: Prohibited Content.\n'
      '• Article 8: Accounts.\n'
      '• Article 9: Liability.\n'
      '• Article 10: Suspension.\n'
      '• Article 11: Privacy.\n'
      '• Article 12: Amendments.\n'
      '• Article 13: Disputes are governed by the laws and regulations of the Kingdom of Saudi Arabia.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('اتفاقية الاستخدام / Terms of Use'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'العربية',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _arabicContent,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.7),
            ),
            SizedBox(height: 24.h),
            Text(
              'English',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _englishContent,
              textDirection: TextDirection.ltr,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}
