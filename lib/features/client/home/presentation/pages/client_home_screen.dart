import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/home_cubit.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/home_state.dart';
import '../widgets/home_stats_section.dart';
import '../widgets/home_categories_section.dart';
import '../widgets/home_special_offer_banner.dart';
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
          backgroundColor: const Color(0xFFF9F9F9),
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeError) {
                return Center(child: Text(state.message.tr()));
              } else if (state is HomeLoaded) {
                return CustomScrollView(
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
                          const HomeSpecialOfferBanner(),
                          SizedBox(height: 24.h),
                          HomeFeaturedPhotographers(
                            photographers: state.featuredPhotographers,
                          ),
                          SizedBox(height: 24.h),
                        ],
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
