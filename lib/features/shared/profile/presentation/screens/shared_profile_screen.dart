import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/service_locator.dart';
import '../manager/profile_cubit.dart';
import '../manager/profile_state.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu.dart';
import '../widgets/role_switcher_card.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/role_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/entities/user_role.dart'
    as auth_role;

class SharedProfileScreen extends StatefulWidget {
  const SharedProfileScreen({super.key});

  @override
  State<SharedProfileScreen> createState() => _SharedProfileScreenState();
}

class _SharedProfileScreenState extends State<SharedProfileScreen> {
  UserRole? _previousRole;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..loadUserProfile(),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoggedOut) {
            context.go('/auth/login');
          } else if (state is ProfileLoaded) {
            final newRole = state.userProfile.currentRole;

            // Sync RoleCubit with the new role from profile
            final authRole = newRole == UserRole.freelancer
                ? auth_role.UserRole.freelancer
                : auth_role.UserRole.client;

            sl<RoleCubit>().select(authRole);

            // Navigate if role changed (not first load)
            if (_previousRole != null && _previousRole != newRole) {
              if (newRole == UserRole.freelancer) {
                context.go('/freelancer/dashboard');
              } else {
                context.go('/home');
              }
            }

            _previousRole = newRole;
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF9F9F9),
          appBar: AppBar(
            backgroundColor: const Color(0xFF2B2B2B),
            elevation: 0,
            title: Text(
              'profile.title'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w400,
              ),
            ),
            centerTitle: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
          ),
          body: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileError) {
                return Center(child: Text(state.message));
              } else if (state is ProfileLoaded ||
                  state is ProfileRoleSwitching) {
                final user = (state is ProfileLoaded)
                    ? state.userProfile
                    : (state as ProfileRoleSwitching).userProfile;

                return Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 24.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RoleSwitcherCard(currentRole: user.currentRole),
                          SizedBox(height: 24.h),
                          ProfileHeader(user: user),
                          SizedBox(height: 24.h),
                          ProfileMenu(currentRole: user.currentRole),
                        ],
                      ),
                    ),
                    if (state is ProfileRoleSwitching)
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFC8A44F),
                          ),
                        ),
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
