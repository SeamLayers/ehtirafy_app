import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static const String _arabicContent =
      'نقدر مخاوفكم واهتمامكم بشأن خصوصية بياناتكم على شبكة الإنترنت.\n\n'
      '• التصفح: لم يتم تصميم المنصة لتجميع بياناتك الشخصية عند التصفح العادي.\n'
      '• عنوان بروتوكول الإنترنت (IP): قد يتم تسجيله لأغراض الحماية والتحسين والتحليل الفني.\n'
      '• الروابط بالمواقع الأخرى: قد تحتوي المنصة على روابط خارجية ولسنا مسؤولين عن سياسات الخصوصية في تلك المواقع.\n'
      '• إفشاء المعلومات: لا يتم الإفصاح عن بياناتك إلا وفق الأنظمة المعمول بها أو بموافقتك.\n'
      '• البيانات لتنفيذ المعاملات: قد نستخدم البيانات اللازمة لإتمام الطلبات والتواصل المرتبط بالخدمة.\n'
      '• إفشاء المعلومات لطرف ثالث: لا يتم مشاركة بياناتك مع طرف ثالث إلا عند الضرورة التشغيلية والقانونية.';

  static const String _englishContent =
      'We value your concerns regarding the privacy of your data online.\n\n'
      '• Browsing: The platform is not designed to collect your personal data during normal browsing.\n'
      '• Internet Protocol (IP): Your IP address may be logged for security, optimization, and technical analytics purposes.\n'
      '• Links to Other Websites: The platform may contain external links, and we are not responsible for their privacy policies.\n'
      '• Disclosure of Information: Your data is not disclosed except as required by applicable laws or with your consent.\n'
      '• Data for Transaction Execution: We may use required information to complete transactions and provide related service communication.\n'
      '• Third-Party Disclosure: Data is shared with third parties only when operationally or legally necessary.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الخصوصية وبيان سرية المعلومات / Privacy Policy'),
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
