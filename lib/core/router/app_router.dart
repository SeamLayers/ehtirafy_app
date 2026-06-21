import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/main.dart' show initialRoute;
import 'package:ehtirafy_app/features/shared/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/screens/login_screen.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/screens/signup_screen.dart';
import 'package:ehtirafy_app/features/client/home/presentation/pages/haraj_home_screen.dart';
import 'package:ehtirafy_app/features/client/home/presentation/pages/client_main_layout.dart';
import 'package:ehtirafy_app/features/client/more/presentation/pages/more_screen.dart';
import 'package:ehtirafy_app/features/freelancer/domain/entities/gig_entity.dart';
import 'package:ehtirafy_app/features/client/notifications/presentation/pages/notifications_screen.dart';
import 'package:ehtirafy_app/features/client/home/presentation/pages/search_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';

import 'package:ehtirafy_app/features/shared/profile/presentation/screens/shared_profile_screen.dart';
import 'package:ehtirafy_app/features/shared/profile/presentation/screens/edit_profile_screen.dart';
import 'package:ehtirafy_app/features/shared/profile/presentation/screens/settings_screen.dart';

import 'package:ehtirafy_app/features/shared/auth/presentation/screens/otp_screen.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/pages/freelancer_profile_screen.dart';
import 'package:ehtirafy_app/features/client/booking/presentation/screens/request_booking_screen.dart';
import 'package:ehtirafy_app/features/client/booking/presentation/screens/booking_success_screen.dart';
import 'package:ehtirafy_app/features/client/requests/presentation/pages/my_requests_screen.dart';
import 'package:ehtirafy_app/features/client/booking/presentation/screens/order_details_screen.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/screens/forgot_password_screen.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/screens/reset_password_screen.dart';

// Freelancer mode imports
import 'package:ehtirafy_app/features/freelancer/presentation/pages/freelancer_main_layout.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/pages/freelancer_dashboard_screen.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/pages/my_gigs_screen.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/pages/create_gig_screen.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/pages/freelancer_orders_screen.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/cubit/freelancer_dashboard_cubit.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/cubit/freelancer_gigs_cubit.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/cubit/freelancer_orders_cubit.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/cubit/freelancer_portfolio_cubit.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/pages/portfolio_screen.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/pages/add_portfolio_item_screen.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/pages/freelancer_order_details_screen.dart';
import 'package:ehtirafy_app/features/freelancer/domain/entities/freelancer_order_entity.dart';
import 'package:ehtirafy_app/features/freelancer/domain/entities/portfolio_item_entity.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/role_cubit.dart';
import 'package:ehtirafy_app/features/shared/profile/presentation/manager/profile_cubit.dart';
import 'package:ehtirafy_app/core/notifications/token_debug_screen.dart';
import 'package:ehtirafy_app/core/router/utils/go_router_refresh_stream.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/category_advertisements_cubit.dart';
import 'package:ehtirafy_app/features/client/home/presentation/pages/category_advertisements_screen.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/all_freelancers_cubit.dart';
import 'package:ehtirafy_app/features/client/home/presentation/pages/all_freelancers_screen.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/cubits/work_details_cubit.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/pages/work_details_screen.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/cubits/advertisement_details_cubit.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/pages/advertisement_details_screen.dart';
import 'package:ehtirafy_app/features/shared/reviews/presentation/cubits/reviews_cubit.dart';
import 'package:ehtirafy_app/features/client/requests/presentation/pages/rate_service_screen.dart';
import 'package:ehtirafy_app/features/client/payment/presentation/cubit/bank_details_cubit.dart';
import 'package:ehtirafy_app/features/client/payment/presentation/cubit/payment_proof_cubit.dart';
import 'package:ehtirafy_app/features/client/payment/presentation/pages/bank_details_screen.dart';
import 'package:ehtirafy_app/features/client/payment/presentation/pages/payment_proof_screen.dart';

/// GoRouter configuration for the app
final appRouter = GoRouter(
  initialLocation: initialRoute,
  refreshListenable: GoRouterRefreshStream(sl<RoleCubit>().stream),
  // Role selection has been removed — every user is a standard user who can
  // browse and post advertisements, so there is no role-based redirection.
  routes: [
    // Onboarding screen
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    // Auth routes
    GoRoute(
      path: '/auth/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/auth/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/auth/reset-password',
      builder: (context, state) {
        final email = state.extra as String;
        return ResetPasswordScreen(email: email);
      },
    ),
    GoRoute(
      path: '/auth/otp',
      builder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        final signupData = state.extra as Map<String, dynamic>?;
        return OtpScreen(phone: phone, signupData: signupData);
      },
    ),

    // Shell Route for Client Bottom Navigation.
    // Branch order is the RTL visual order (right-to-left): the first branch
    // (Home) renders right-most, the last (More) left-most.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ClientMainLayout(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HarajHomeScreen(),
            ),
          ],
        ),
        // Tab 1: Search
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
        // Tab 2: Contracts (the user's contracts / requests list)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/contracts-chats',
              builder: (context, state) => const MyRequestsScreen(),
            ),
          ],
        ),
        // Tab 3: Profile (account)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const SharedProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => BlocProvider(
                    create: (context) => sl<ProfileCubit>(),
                    child: const SettingsScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Tab 4: More
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/more',
              builder: (context, state) => const MoreScreen(),
            ),
          ],
        ),
      ],
    ),

    // Shell Route for Freelancer Bottom Navigation
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return FreelancerMainLayout(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Dashboard
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/freelancer/dashboard',
              builder: (context, state) => BlocProvider(
                create: (_) => sl<FreelancerDashboardCubit>(),
                child: const FreelancerDashboardScreen(),
              ),
            ),
          ],
        ),
        // Tab 1: Orders
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/freelancer/orders',
              builder: (context, state) => BlocProvider(
                create: (_) => sl<FreelancerOrdersCubit>(),
                child: const FreelancerOrdersScreen(),
              ),
            ),
          ],
        ),
        // Tab 2: Profile (reuse shared profile)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/freelancer/profile',
              builder: (context, state) => const SharedProfileScreen(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => const EditProfileScreen(),
                ),
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => BlocProvider(
                    create: (context) => sl<ProfileCubit>(),
                    child: const SettingsScreen(),
                  ),
                ),

              ],
            ),
          ],
        ),
      ],
    ),

    // Freelancer standalone routes (not in shell)
    GoRoute(
      path: '/freelancer/gigs',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<FreelancerGigsCubit>(),
        child: const MyGigsScreen(),
      ),
    ),
    GoRoute(
      path: '/freelancer/gigs/create',
      builder: (context, state) {
        final gig = state.extra as GigEntity?;
        return BlocProvider(
          create: (_) => sl<FreelancerGigsCubit>(),
          child: CreateGigScreen(gig: gig),
        );
      },
    ),
    GoRoute(
      path: '/freelancer/portfolio',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<FreelancerPortfolioCubit>(),
        child: const PortfolioScreen(),
      ),
    ),
    GoRoute(
      path: '/freelancer/portfolio/add',
      builder: (context, state) {
        final item = state.extra as PortfolioItemEntity?;
        return BlocProvider(
          create: (_) => sl<FreelancerPortfolioCubit>(),
          child: AddPortfolioItemScreen(portfolioItem: item),
        );
      },
    ),
    GoRoute(
      path: '/freelancer/orders/details',
      builder: (context, state) {
        final order = state.extra as FreelancerOrderEntity;
        return BlocProvider(
          create: (_) => sl<FreelancerOrdersCubit>(),
          child: FreelancerOrderDetailsScreen(order: order),
        );
      },
    ),

    // Other routes
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    // My contracts/requests (payment lifecycle) — kept reachable as a
    // standalone route (e.g. after a booking) outside the bottom nav.
    GoRoute(
      path: '/my-requests',
      builder: (context, state) => const MyRequestsScreen(),
    ),
    // Post a new advertisement / offer (terminology: إعلان / عرض, never خدمة).
    GoRoute(
      path: '/add-advertisement',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<FreelancerGigsCubit>(),
        child: const CreateGigScreen(),
      ),
    ),
    // Manage my advertisements.
    GoRoute(
      path: '/my-ads',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<FreelancerGigsCubit>(),
        child: const MyGigsScreen(),
      ),
    ),
    // Category advertisements screen
    GoRoute(
      path: '/category/:id',
      builder: (context, state) {
        final categoryId = state.pathParameters['id']!;
        final extra = state.extra as Map<String, dynamic>?;
        final categoryName = extra?['categoryName'] ?? 'الفئة';
        return BlocProvider(
          create: (_) => sl<CategoryAdvertisementsCubit>(),
          child: CategoryAdvertisementsScreen(
            categoryId: categoryId,
            categoryName: categoryName,
          ),
        );
      },
    ),
    GoRoute(
      path: '/all-freelancers',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<AllFreelancersCubit>()..loadAllFreelancers(),
          child: const AllFreelancersScreen(),
        );
      },
    ),
    GoRoute(
      path: '/work/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BlocProvider(
          create: (_) => sl<WorkDetailsCubit>()..loadWorkDetails(id),
          child: WorkDetailsScreen(workId: id),
        );
      },
    ),
    GoRoute(
      path: '/rate-service',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return BlocProvider(
          create: (_) => sl<ReviewsCubit>(),
          child: RateServiceScreen(
            freelancerId: extra?['freelancerId'] ?? '',
            freelancerName: extra?['freelancerName'] ?? '',
            serviceName: extra?['serviceName'] ?? '',
            advertisementId: extra?['advertisementId'] ?? '',
          ),
        );
      },
    ),
    GoRoute(
      path: '/advertisement/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final extra = state.extra as Map<String, dynamic>?;
        return BlocProvider(
          create: (_) =>
              sl<AdvertisementDetailsCubit>()..loadAdvertisementDetails(id),
          child: AdvertisementDetailsScreen(
            advertisementId: id,
            freelancerId: extra?['freelancerId'],
            freelancerName: extra?['freelancerName'],
          ),
        );
      },
    ),
    GoRoute(
      path: '/freelancer/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return FreelancerProfileScreen(freelancerId: id);
      },
    ),
    GoRoute(
      path: '/booking/request',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final availableDays =
            (extra['availableDays'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [];

        return RequestBookingScreen(
          advertisementId: extra['advertisementId'],
          photographerId: extra['photographerId'],
          photographerName: extra['photographerName'],
          serviceName: extra['serviceName'],
          price: extra['price'],
          availableDays: availableDays,
        );
      },
    ),
    GoRoute(
      path: '/booking/success',
      builder: (context, state) => const BookingSuccessScreen(),
    ),
    GoRoute(
      path: '/contract/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return OrderDetailsScreen(orderId: id);
      },
    ),
    // Payment routes
    GoRoute(
      path: '/payment/bank-details/:contractId',
      builder: (context, state) {
        final contractId = state.pathParameters['contractId']!;
        final advId = state.uri.queryParameters['advId'] ?? contractId;
        return BlocProvider(
          create: (context) => sl<BankDetailsCubit>(),
          child: BankDetailsScreen(contractId: contractId, advertisementId: advId),
        );
      },
    ),
    GoRoute(
      path: '/payment/proof/:contractId',
      builder: (context, state) {
        final contractId = state.pathParameters['contractId']!;
        final advId = state.uri.queryParameters['advId'] ?? contractId;
        return BlocProvider(
          create: (context) => sl<PaymentProofCubit>(),
          child: PaymentProofScreen(contractId: contractId, advertisementId: advId),
        );
      },
    ),
    GoRoute(
      path: '/debug/token',
      builder: (context, state) => const TokenDebugScreen(),
    ),
  ],
);
