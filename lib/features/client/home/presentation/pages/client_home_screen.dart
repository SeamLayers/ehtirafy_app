import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/home_cubit.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/home_state.dart';
import '../widgets/home_stats_section.dart';
import '../widgets/home_categories_section.dart';
import '../widgets/home_featured_photographers.dart';
import '../widgets/home_sliver_header_delegate.dart';

class ClientHomeContent extends StatelessWidget {
  const ClientHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.maybeOf(context)?.padding.top ?? 0.0;

    return BlocProvider(
      create: (context) => sl<HomeCubit>()..loadHomeData(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: AppColors.backgroundLight,
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return Center(
                  child: SizedBox(
                    width: 40.w,
                    height: 40.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.gold),
                    ),
                  ),
                );
              } else if (state is HomeError) {
                return ErrorStateWidget(
                  message: state.message.tr(),
                  onRetry: () => context.read<HomeCubit>().loadHomeData(),
                  retryText: 'home_main.retry'.tr(),
                );
              } else if (state is HomeLoaded) {
                return Stack(
                  children: [
                    PositionedDirectional(
                      top: -120.h,
                      start: -40.w,
                      child: Container(
                        width: 220.w,
                        height: 220.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.gold.withValues(alpha: 0.12),
                              AppColors.gold.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    PositionedDirectional(
                      top: 260.h,
                      end: -70.w,
                      child: Container(
                        width: 200.w,
                        height: 200.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.gold.withValues(alpha: 0.08),
                              AppColors.gold.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    CustomScrollView(
                      slivers: [
                        SliverPersistentHeader(
                          delegate: HomeSliverHeaderDelegate(
                            topPadding: topPadding,
                            userName: state.userName,
                          ),
                          pinned: true,
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 24.h),
                              HomeStatsSection(statistics: state.appStatistics),
                              SizedBox(height: 24.h),
                              HomeCategoriesSection(
                                categories: state.categories,
                                locale: context.locale.languageCode,
                              ),
                              SizedBox(height: 24.h),
                              HomeFeaturedPhotographers(
                                photographers: state.featuredPhotographers,
                              ),
                              SizedBox(height: 28.h),
                            ],
                          ),
                        ),
                      ],
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
