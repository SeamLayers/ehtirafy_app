import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/rtl_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsPageScaffold extends StatelessWidget {
  final String appBarTitle;
  final IconData heroIcon;
  final String heroTitle;
  final String heroSubtitle;
  final List<Widget> children;

  const SettingsPageScaffold({
    super.key,
    required this.appBarTitle,
    required this.heroIcon,
    required this.heroTitle,
    required this.heroSubtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surfaceColor = isDark ? const Color(0xFF1F211D) : Colors.white;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: const RtlBackButton(),
        title: Text(
          appBarTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            height: 1.h,
            color: theme.colorScheme.onSurface.withValues(
              alpha: isDark ? 0.12 : 0.06,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.gold.withValues(alpha: isDark ? 0.24 : 0.16),
                    surfaceColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(
                      alpha: isDark ? 0.22 : 0.14,
                    ),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.55),
                        width: 1.4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.20),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      heroIcon,
                      color: AppColors.primary,
                      size: 26.sp,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text(
                    heroTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs + 2.h),
                  Text(
                    heroSubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.72,
                      ),
                      height: 1.65,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.lg),
            ...children,
          ],
        ),
      ),
    );
  }
}

class SettingsMetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const SettingsMetaChip({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF242622)
            : AppColors.gold.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: isDark ? 0.30 : 0.24),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15.sp, color: AppColors.primary),
          SizedBox(width: AppSpacing.xs + 2.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsLocaleSection extends StatelessWidget {
  final String localeTitle;
  final IconData icon;
  final String intro;
  final List<String> bullets;
  final bool isEnglish;
  final bool numbered;

  const SettingsLocaleSection({
    super.key,
    required this.localeTitle,
    required this.icon,
    required this.intro,
    required this.bullets,
    this.isEnglish = false,
    this.numbered = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textDirection = isEnglish ? TextDirection.ltr : TextDirection.rtl;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242622) : Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? theme.colorScheme.onSurface.withValues(alpha: 0.18)
              : AppColors.grey200,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.shadowLight.withValues(alpha: 0.5),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.gold.withValues(alpha: 0.22),
                      AppColors.gold.withValues(alpha: 0.10),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 18.sp, color: AppColors.primary),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  localeTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm + 2.h),
          Text(
            intro,
            textDirection: textDirection,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
              height: 1.7,
            ),
          ),
          if (bullets.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm + 2.h),
            ...List.generate(
              bullets.length,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.sm + 2.h),
                child: _BulletLine(
                  text: bullets[index],
                  marker: numbered ? '${index + 1}' : '•',
                  isEnglish: isEnglish,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  final String text;
  final String marker;
  final bool isEnglish;

  const _BulletLine({
    required this.text,
    required this.marker,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isNumbered = marker != '•';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2.h),
          width: 22.w,
          height: 22.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: isNumbered ? 0.14 : 0.0),
            shape: BoxShape.circle,
          ),
          child: Text(
            marker,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            textDirection: isEnglish ? TextDirection.ltr : TextDirection.rtl,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.7,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }
}

class SettingsInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isEnglish;
  final bool copyable;

  const SettingsInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.isEnglish = false,
    this.copyable = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: AppSpacing.sm + 2.h),
      padding: EdgeInsets.all(AppSpacing.md - 2.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F211D) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? theme.colorScheme.onSurface.withValues(alpha: 0.18)
              : AppColors.grey200,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.shadowLight.withValues(alpha: 0.45),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.gold.withValues(alpha: 0.20),
                  AppColors.gold.withValues(alpha: 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 19.sp),
          ),
          SizedBox(width: AppSpacing.sm + 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  textDirection: isEnglish
                      ? TextDirection.ltr
                      : TextDirection.rtl,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          if (copyable)
            IconButton(
              icon: Icon(
                Icons.copy_rounded,
                color: AppColors.primary,
                size: 18.sp,
              ),
              tooltip: 'نسخ / Copy',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم النسخ / Copied')),
                );
              },
            ),
        ],
      ),
    );
  }
}
