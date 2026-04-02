import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SafetyCenterScreen extends StatelessWidget {
  const SafetyCenterScreen({super.key});

  static const String _arabicContent =
      'الحماية من استغلال البشر\n'
      'نعمل في منصة بطل مع هيئة حقوق الإنسان في السعودية (https://www.hrc.gov.sa) لمكافحة الاتجار بالبشر وتعزيز بيئة رقمية آمنة للجميع.\n\n'
      'طريقة الإبلاغ عن محتوى مخالف:\n'
      '1. الإبلاغ على الإعلان المنشور من داخل صفحة الإعلان.\n'
      '2. الإبلاغ عن طريق (اتصل بنا).\n'
      '3. إبلاغ والتواصل مع هيئة حقوق الإنسان على الايميل Info@ncct.gov.sa';

  static const String _englishContent =
      'Protection Against Human Exploitation\n'
      'At Batal Platform, we work with the Human Rights Commission in Saudi Arabia (https://www.hrc.gov.sa) to combat human trafficking and maintain a safe digital environment for all users.\n\n'
      'How to report violating content:\n'
      '1. Report the published ad directly from the ad page.\n'
      '2. Report through the Contact Us section.\n'
      '3. Report and communicate with the Human Rights authority via email: Info@ncct.gov.sa';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز الأمان / Safety Center'),
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
