import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  static const String _arabicContent =
      'إذا كان لديك أي استفسار أو رغبتك في تقديم شكوى:\n'
      '1. الضغط على رابط "اتصل بنا".\n'
      '2. إرسال رسالة عبر البريد: photography@al-batal.com\n'
      '3. الاتصال المباشر: +966 55 123 4567\n'
      '4. متابعة حساباتنا:\n'
      '• فيسبوك facebook.com/albatal\n'
      '• تويتر @al_batal\n'
      '• إنستجرام instagram.com/albatal\n'
      '• سناب شات @albatal';

  static const String _englishContent =
      'If you have any inquiry or wish to submit a complaint:\n'
      '1. Click the "Contact Us" link.\n'
      '2. Send an email to: photography@al-batal.com\n'
      '3. Direct call: +966 55 123 4567\n'
      '4. Follow our social accounts:\n'
      '• Facebook: facebook.com/albatal\n'
      '• X (Twitter): @al_batal\n'
      '• Instagram: instagram.com/albatal\n'
      '• Snapchat: @albatal';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('اتصل بنا / Contact Us'),
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
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.8),
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
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.8),
            ),
          ],
        ),
      ),
    );
  }
}
