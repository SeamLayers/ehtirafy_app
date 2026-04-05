import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_links.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppShareBottomSheet {
  AppShareBottomSheet._();

  static Future<void> show(BuildContext context) async {
    final shareMessage = _buildShareMessage();

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _ShareSheetContent(
          appUrl: AppLinks.appShareUrl,
          onWhatsAppTap: () {
            _performAction(
              sheetContext: sheetContext,
              rootContext: context,
              action: () => _shareViaWhatsApp(context, shareMessage),
            );
          },
          onSystemShareTap: () {
            _performAction(
              sheetContext: sheetContext,
              rootContext: context,
              action: () => _shareViaSystem(context, shareMessage),
            );
          },
          onCopyLinkTap: () {
            _performAction(
              sheetContext: sheetContext,
              rootContext: context,
              action: () => _copyLink(context),
            );
          },
        );
      },
    );
  }

  static String _buildShareMessage() {
    return AppStrings.appShareMessage.tr(
      namedArgs: {'link': AppLinks.appShareUrl},
    );
  }

  static Future<void> _performAction({
    required BuildContext sheetContext,
    required BuildContext rootContext,
    required Future<void> Function() action,
  }) async {
    Navigator.of(sheetContext).pop();
    await Future<void>.delayed(const Duration(milliseconds: 120));

    if (!rootContext.mounted) return;
    await action();
  }

  static Future<void> _shareViaSystem(
    BuildContext context,
    String message,
  ) async {
    Rect? sharePositionOrigin;
    final renderObject = context.findRenderObject();
    if (renderObject is RenderBox) {
      sharePositionOrigin =
          renderObject.localToGlobal(Offset.zero) & renderObject.size;
    }

    await Share.share(
      message,
      subject: AppStrings.appShareSubject.tr(),
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  static Future<void> _shareViaWhatsApp(
    BuildContext context,
    String message,
  ) async {
    final whatsappUri = Uri.parse(
      'whatsapp://send?text=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      return;
    }

    final webUri = Uri.parse(
      'https://wa.me/?text=${Uri.encodeComponent(message)}',
    );
    final launched = await launchUrl(
      webUri,
      mode: LaunchMode.externalApplication,
    );

    if (context.mounted && !launched) {
      _showFeedback(
        context,
        AppStrings.appShareWhatsappUnavailable.tr(),
        isError: true,
      );
    }
  }

  static Future<void> _copyLink(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: AppLinks.appShareUrl));

    if (!context.mounted) return;
    _showFeedback(context, AppStrings.appShareCopied.tr());
  }

  static void _showFeedback(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
            ),
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          backgroundColor: isError ? AppColors.error : const Color(0xFF2B2B2B),
        ),
      );
  }
}

class _ShareSheetContent extends StatelessWidget {
  final String appUrl;
  final VoidCallback onWhatsAppTap;
  final VoidCallback onSystemShareTap;
  final VoidCallback onCopyLinkTap;

  const _ShareSheetContent({
    required this.appUrl,
    required this.onWhatsAppTap,
    required this.onSystemShareTap,
    required this.onCopyLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1E201C) : Colors.white;
    final cardColor = isDark
        ? const Color(0xFF282A25)
        : const Color(0xFFF9F9F9);

    return SafeArea(
      top: false,
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 150.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.gold.withValues(alpha: isDark ? 0.25 : 0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 52.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.2,
                        ),
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    AppStrings.appShareTitle.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppStrings.appShareSubtitle.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      height: 1.6,
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.72,
                      ),
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.link_rounded,
                            size: 17.sp,
                            color: AppColors.gold,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          AppStrings.appShareLinkLabel.tr(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.65,
                            ),
                            fontFamily: 'Cairo',
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            appUrl,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: _ShareActionCard(
                          label: AppStrings.appShareWhatsapp.tr(),
                          icon: Icons.chat,
                          accentColor: const Color(0xFF25D366),
                          cardColor: cardColor,
                          onTap: onWhatsAppTap,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _ShareActionCard(
                          label: AppStrings.appShareMoreOptions.tr(),
                          icon: Icons.ios_share_rounded,
                          accentColor: AppColors.gold,
                          cardColor: cardColor,
                          onTap: onSystemShareTap,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: _ShareActionCard(
                          label: AppStrings.appShareCopyLink.tr(),
                          icon: Icons.content_copy_rounded,
                          accentColor: const Color(0xFF2F6FEB),
                          cardColor: cardColor,
                          onTap: onCopyLinkTap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accentColor;
  final Color cardColor;
  final VoidCallback onTap;

  const _ShareActionCard({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.cardColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Ink(
          height: 92.h,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: accentColor.withValues(alpha: 0.35)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 19.sp, color: accentColor),
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
