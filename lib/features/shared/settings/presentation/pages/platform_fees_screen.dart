import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlatformFeesScreen extends StatelessWidget {
  const PlatformFeesScreen({super.key});

  static const String _arabicContent =
      'رسوم المنصة: تقوم منصة بطل بتحصيل رسوم قدرها 5% من قيمة كل إعلان يتم عرضه.\n\n'
      'بيانات الحساب – منصة بطل:\n'
      '• رقم الحساب : 609000010006086201357\n'
      '• رقم الآيبان : SA3380000609608016201357\n'
      '• اسم مستخدم الراجحي : \n'
      '• رقم العضوية: \n'
      '• رقم العميل : ';

  static const String _englishContent =
      'Platform Fees: Batal Platform collects a fee of 5% from the value of each published advertisement.\n\n'
      'Account Details - Batal Platform:\n'
      '• Account Number: 609000010006086201357\n'
      '• IBAN: SA3380000609608016201357\n'
      '• Al Rajhi Username: \n'
      '• Membership Number: \n'
      '• Customer Number: ';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('رسوم المنصة / Platform Fees'),
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
