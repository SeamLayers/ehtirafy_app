import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';

/// Shows the "تواصل" (Contact) modal with two options:
///  - Contact via Mobile → opens the phone dialer (tel:)
///  - WhatsApp → opens a WhatsApp chat via a wa.me deep link
///
/// The in-app chat was removed; contacting is now phone-based only.
///
/// The phone number can be supplied two ways:
///  - [phone]: a number already on hand (e.g. from a loaded profile).
///  - [phoneResolver]: an async lookup invoked on tap when no number is known
///    up front (e.g. the ad-details screen, which must fetch it on demand).
/// When [phone] is empty/null and a [phoneResolver] is given, the resolver runs
/// behind a brief loading indicator before deciding what to do.
Future<void> showContactOptionsSheet(
  BuildContext context, {
  String? phone,
  Future<String?> Function()? phoneResolver,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) => _ContactOptionsSheet(
      phone: phone,
      phoneResolver: phoneResolver,
    ),
  );
}

class _ContactOptionsSheet extends StatelessWidget {
  final String? phone;
  final Future<String?> Function()? phoneResolver;

  const _ContactOptionsSheet({
    this.phone,
    this.phoneResolver,
  });

  /// Pops the sheet, then resolves the phone — preferring a number passed up
  /// front, otherwise looking it up on demand behind a tiny loading dialog.
  /// Returns the trimmed number, or null (after showing the "no phone"
  /// snackbar) when none is available. Shared by both Call and WhatsApp.
  Future<String?> _resolvePhone(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    navigator.pop();

    String resolved = (phone ?? '').trim();
    if (resolved.isEmpty && phoneResolver != null) {
      final overlay = navigator.overlay;
      // Capture the root navigator now so we can pop the dialog after the await
      // without touching a BuildContext across the async gap.
      final rootNavigator = overlay != null
          ? Navigator.of(overlay.context, rootNavigator: true)
          : null;
      if (overlay != null) {
        showDialog<void>(
          context: overlay.context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );
      }
      String? fetched;
      try {
        fetched = await phoneResolver!();
      } catch (_) {
        fetched = null;
      }
      // Dismiss the loading dialog.
      rootNavigator?.pop();
      resolved = (fetched ?? '').trim();
    }

    // No number on file → tell the user the advertiser hasn't added one.
    if (resolved.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(AppStrings.contactFreelancerNoPhone.tr())),
      );
      return null;
    }
    return resolved;
  }

  Future<void> _callMobile(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final resolved = await _resolvePhone(context);
    if (resolved == null) return;

    final uri = Uri(scheme: 'tel', path: resolved);
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

  Future<void> _openWhatsApp(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final resolved = await _resolvePhone(context);
    if (resolved == null) return;

    final uri = Uri.parse('https://wa.me/${_toWhatsappNumber(resolved)}');
    bool launched = false;
    try {
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      launched = false;
    }
    if (!launched) {
      messenger.showSnackBar(
        SnackBar(content: Text(AppStrings.contactWhatsappFailed.tr())),
      );
    }
  }

  /// Normalises a phone number into the wa.me international form (country code +
  /// national number, digits only). Handles a leading +, a 00 prefix, a leading
  /// 0, and an already-present 966 country code; defaults to the Saudi country
  /// code (966) when no country code is present.
  String _toWhatsappNumber(String raw) {
    var d = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (d.startsWith('00')) d = d.substring(2);
    if (d.startsWith('966')) return d;
    d = d.replaceFirst(RegExp(r'^0+'), '');
    return '966$d';
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
              icon: Icons.chat_rounded,
              title: AppStrings.contactWhatsapp.tr(),
              subtitle: AppStrings.contactWhatsappSubtitle.tr(),
              color: const Color(0xFF25D366),
              onTap: () => _openWhatsApp(context),
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
