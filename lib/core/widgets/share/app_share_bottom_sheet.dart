import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_links.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
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
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons.error_outline_rounded
                    : Icons.check_circle_outline_rounded,
                color: isError ? AppColors.textLight : AppColors.gold,
                size: 20.sp,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          backgroundColor: isError ? AppColors.error : AppColors.dark,
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

    final onSurface = theme.colorScheme.onSurface;

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
              blurRadius: 28,
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
                height: 160.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28.r),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.gold.withValues(alpha: isDark ? 0.22 : 0.16),
                      AppColors.gold.withValues(alpha: 0.0),
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
                      width: 48.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                        color: onSurface.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(99.r),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Center(
                    child: Container(
                      width: 64.w,
                      height: 64.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: AlignmentDirectional.topStart,
                          end: AlignmentDirectional.bottomEnd,
                          colors: [
                            AppColors.gold,
                            AppColors.gold.withValues(alpha: 0.78),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.32),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.ios_share_rounded,
                        size: 28.sp,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    AppStrings.appShareTitle.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: onSurface,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    AppStrings.appShareSubtitle.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      height: 1.6,
                      color: onSurface.withValues(alpha: 0.7),
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.28),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.link_rounded,
                            size: 18.sp,
                            color: AppColors.gold,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          AppStrings.appShareLinkLabel.tr(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: onSurface.withValues(alpha: 0.6),
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
                              fontWeight: FontWeight.w700,
                              color: onSurface,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
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
                          accentColor: AppColors.info,
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
        borderRadius: BorderRadius.circular(16.r),
        splashColor: accentColor.withValues(alpha: 0.12),
        highlightColor: accentColor.withValues(alpha: 0.06),
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Ink(
          height: 96.h,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: accentColor.withValues(alpha: 0.3)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: accentColor.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Icon(icon, size: 20.sp, color: accentColor),
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
