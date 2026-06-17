import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';

/// Shows the "تواصل" (Contact) modal with two options:
///  - Contact via Mobile → opens the phone dialer (tel:)
///  - Chat → invokes [onChat] (typically opens the in-app chat room)
Future<void> showContactOptionsSheet(
  BuildContext context, {
  required String phone,
  required VoidCallback onChat,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) =>
        _ContactOptionsSheet(phone: phone, onChat: onChat),
  );
}

class _ContactOptionsSheet extends StatelessWidget {
  final String phone;
  final VoidCallback onChat;

  const _ContactOptionsSheet({required this.phone, required this.onChat});

  Future<void> _callMobile(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    final trimmed = phone.trim();
    // No number on file → tell the user it's unavailable.
    if (trimmed.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(AppStrings.contactNoPhone.tr())),
      );
      return;
    }
    // A number exists but the dialer couldn't be opened → distinct message.
    final uri = Uri(scheme: 'tel', path: trimmed);
    bool launched = false;
    try {
      launched = await launchUrl(uri);
    } catch (_) {
      launched = false;
    }
    if (!launched) {
      messenger.showSnackBar(
        SnackBar(content: Text(AppStrings.contactCallFailed.tr())),
      );
    }
  }

  void _openChat(BuildContext context) {
    Navigator.of(context).pop();
    onChat();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(999.r),
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              AppStrings.contactTitle.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              AppStrings.contactSubtitle.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13.sp,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 20.h),
            _ContactOption(
              icon: Icons.phone_in_talk_rounded,
              title: AppStrings.contactMobile.tr(),
              subtitle: AppStrings.contactMobileSubtitle.tr(),
              color: AppColors.success,
              onTap: () => _callMobile(context),
            ),
            SizedBox(height: 12.h),
            _ContactOption(
              icon: Icons.chat_bubble_rounded,
              title: AppStrings.contactChat.tr(),
              subtitle: AppStrings.contactChatSubtitle.tr(),
              color: AppColors.gold,
              onTap: () => _openChat(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ContactOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14.r),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.sp,
              color: color.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
