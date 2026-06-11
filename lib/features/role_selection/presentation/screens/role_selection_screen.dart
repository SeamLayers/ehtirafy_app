import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/primary_button.dart';

/// Role Selection Screen
/// Allows user to select their role: Client or Photographer
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;
  bool _isLoading = false;

  Future<void> _saveRoleAndNavigate() async {
    if (_selectedRole == null) return;

    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', _selectedRole!);

      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving role: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSpacing.xxl),

                      // Decorative gold badge
                      Container(
                        width: 64.w,
                        height: 64.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: AlignmentDirectional.topStart,
                            end: AlignmentDirectional.bottomEnd,
                            colors: [
                              AppColors.gold.withValues(alpha: 0.18),
                              AppColors.gold.withValues(alpha: 0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.30),
                            width: 1.w,
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 32.sp,
                          color: AppColors.gold,
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg),

                      // Title
                      Text(
                        'How do you want to use Ehtirafy?',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        'Choose your role to get started',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isDark
                              ? AppColors.grey400
                              : AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xl),

                      // Role Cards
                      // Client Role Card
                      _RoleCard(
                        title: 'Client',
                        description:
                            'Looking for professional photography services',
                        icon: Icons.person_search_rounded,
                        isSelected: _selectedRole == 'client',
                        onTap: () => setState(() => _selectedRole = 'client'),
                      ),
                      SizedBox(height: AppSpacing.md),

                      // Photographer Role Card
                      _RoleCard(
                        title: 'Photographer',
                        description:
                            'Offer your photography skills and services',
                        icon: Icons.camera_alt_rounded,
                        isSelected: _selectedRole == 'photographer',
                        onTap: () =>
                            setState(() => _selectedRole = 'photographer'),
                      ),
                      SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ),

              // Continue Button
              PrimaryButton(
                text: 'Continue',
                onPressed: _selectedRole != null ? _saveRoleAndNavigate : () {},
                isLoading: _isLoading,
              ),
              SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

/// Role Card Widget
class _RoleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color surface = isDark ? AppColors.grey800 : Colors.white;
    final Color borderColor = isSelected
        ? AppColors.gold
        : (isDark ? AppColors.grey700 : AppColors.grey200);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        splashColor: AppColors.gold.withValues(alpha: 0.08),
        highlightColor: AppColors.gold.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(AppSpacing.md + 4.w),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: borderColor,
              width: isSelected ? 1.8.w : 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.gold.withValues(alpha: 0.18)
                    : AppColors.shadowLight,
                blurRadius: isSelected ? 18.r : 10.r,
                offset: Offset(0, 6.h),
                spreadRadius: isSelected ? -2.r : -4.r,
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon Container
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.gold.withValues(alpha: 0.12)
                      : (isDark ? AppColors.grey700 : AppColors.grey100),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  icon,
                  size: 30.sp,
                  color: isSelected
                      ? AppColors.gold
                      : (isDark ? AppColors.grey400 : AppColors.grey600),
                ),
              ),
              SizedBox(width: AppSpacing.md),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isSelected ? AppColors.gold : null,
                      ),
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.grey400
                            : AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),

              // Selection Indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                width: 26.w,
                height: 26.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.gold : AppColors.grey400,
                    width: 2.w,
                  ),
                  color: isSelected ? AppColors.gold : Colors.transparent,
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
