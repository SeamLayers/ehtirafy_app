import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../manager/profile_cubit.dart';

class RoleSwitcherCard extends StatefulWidget {
  final UserRole currentRole;

  const RoleSwitcherCard({super.key, required this.currentRole});

  @override
  State<RoleSwitcherCard> createState() => _RoleSwitcherCardState();
}

class _RoleSwitcherCardState extends State<RoleSwitcherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconRotation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _iconRotation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onSwitchTap() async {
    await _animationController.forward();
    if (mounted) {
      context.read<ProfileCubit>().toggleRole();
    }
    await _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isClient = widget.currentRole == UserRole.client;

    // Build the display text based on current role
    final browsingText = isClient ? 'انت تتصفح كـ عميل' : 'انت تتصفح كـ مصور';

    final switchText = isClient
        ? 'التبديل إلى وضع المصور'
        : 'التبديل إلى وضع العميل';

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) =>
          Transform.scale(scale: _scaleAnimation.value, child: child),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-1.0, -1.0),
            end: const Alignment(1.0, 1.0),
            colors: [
              const Color(0xFFC8A44F).withOpacity(0.15),
              const Color(0xFFC8A44F).withOpacity(0.05),
              Colors.transparent,
            ],
          ),
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Color(0xFFC8A44F)),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Column(
          children: [
            // Header Row with role info
            Row(
              children: [
                // Animated Icon Container
                AnimatedBuilder(
                  animation: _iconRotation,
                  builder: (context, child) => Transform.rotate(
                    angle: _iconRotation.value * 3.14159,
                    child: child,
                  ),
                  child: Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFC8A44F).withOpacity(0.3),
                          const Color(0xFFC8A44F).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: const Color(0xFFC8A44F).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      isClient
                          ? Icons.person_outline
                          : Icons.camera_alt_outlined,
                      color: const Color(0xFFC8A44F),
                      size: 24.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // Text Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Browsing as text
                      Text(
                        browsingText,
                        style: TextStyle(
                          color: const Color(0xFF2B2B2B),
                          fontSize: 15.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      // Role badge with animated indicator
                      Row(
                        children: [
                          _buildAnimatedDot(isClient),
                          SizedBox(width: 6.w),
                          Text(
                            isClient ? 'عميل' : 'مصور',
                            style: TextStyle(
                              color: const Color(0xFF888888),
                              fontSize: 13.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Role Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: isClient
                        ? const Color(0xFF17A2B8)
                        : const Color(0xFFC8A44F),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    isClient ? 'عميل' : 'مصور',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Switch Button with animation
            GestureDetector(
              onTap: _onSwitchTap,
              child: Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [const Color(0xFFC8A44F), const Color(0xFFD4B85A)],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC8A44F).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.swap_horiz_rounded,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      switchText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedDot(bool isClient) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.2),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 8.w * value,
          height: 8.w * value,
          decoration: BoxDecoration(
            color: isClient ? const Color(0xFF17A2B8) : const Color(0xFFC8A44F),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color:
                    (isClient
                            ? const Color(0xFF17A2B8)
                            : const Color(0xFFC8A44F))
                        .withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      },
      onEnd: () {
        // Trigger rebuild to loop animation
        if (mounted) setState(() {});
      },
    );
  }
}
