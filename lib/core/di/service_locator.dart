import 'package:ehtirafy_app/features/freelancer/data/repositories/freelancer_dashboard_repository_impl.dart';
import 'package:ehtirafy_app/features/freelancer/data/datasources/freelancer_dashboard_remote_data_source.dart';
import 'package:ehtirafy_app/features/freelancer/domain/repositories/freelancer_orders_repository.dart';
import 'package:ehtirafy_app/features/freelancer/domain/usecases/get_freelancer_statistics_usecase.dart';
import 'package:ehtirafy_app/features/freelancer/domain/usecases/get_freelancer_last_contracts_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ehtirafy_app/features/shared/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ehtirafy_app/features/shared/auth/data/datasources/user_local_data_source.dart';
import 'package:ehtirafy_app/features/shared/auth/data/repositories/auth_repository_impl.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/repositories/auth_repository.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/usecases/login_usecase.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/usecases/logout_usecase.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/usecases/reset_password_usecase.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/usecases/send_otp_usecase.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/usecases/signup_usecase.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/login_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/signup_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/forgot_password_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/reset_password_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/otp_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/repositories/role_repository.dart';
import 'package:ehtirafy_app/features/shared/auth/data/repositories/role_repository_impl.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/usecases/role_usecases.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/role_cubit.dart';
import 'package:ehtirafy_app/features/client/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:ehtirafy_app/features/client/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:ehtirafy_app/features/client/notifications/domain/repositories/notifications_repository.dart';
import 'package:ehtirafy_app/features/client/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:ehtirafy_app/features/client/notifications/domain/usecases/mark_notification_read_usecase.dart';
import 'package:ehtirafy_app/features/client/notifications/presentation/cubits/notifications_cubit.dart';
import 'package:ehtirafy_app/features/client/search/data/datasources/search_remote_data_source.dart';
import 'package:ehtirafy_app/features/client/search/data/datasources/search_local_data_source.dart';
import 'package:ehtirafy_app/features/client/search/data/repositories/search_repository_impl.dart';
import 'package:ehtirafy_app/features/client/search/domain/repositories/search_repository.dart';
import 'package:ehtirafy_app/features/client/search/domain/usecases/search_usecase.dart';
import 'package:ehtirafy_app/features/client/search/presentation/cubits/search_cubit.dart';
import 'package:ehtirafy_app/features/client/home/data/datasources/home_remote_data_source.dart';
import 'package:ehtirafy_app/features/client/home/data/repositories/home_repository_impl.dart';
import 'package:ehtirafy_app/features/client/home/domain/repositories/home_repository.dart';
import 'package:ehtirafy_app/features/client/home/domain/usecases/get_featured_photographers_usecase.dart';
import 'package:ehtirafy_app/features/client/home/domain/usecases/get_app_statistics_usecase.dart';
import 'package:ehtirafy_app/features/client/home/domain/usecases/get_categories_usecase.dart';
import 'package:ehtirafy_app/features/client/home/domain/usecases/get_advertisements_by_category_usecase.dart';
import 'package:ehtirafy_app/features/client/home/domain/usecases/get_all_freelancers_usecase.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/home_cubit.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/category_advertisements_cubit.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/all_freelancers_cubit.dart';
import 'package:ehtirafy_app/features/client/freelancer/data/datasources/freelancer_remote_data_source.dart';
import 'package:ehtirafy_app/features/client/freelancer/data/repositories/freelancer_repository_impl.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/repositories/freelancer_repository.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/usecases/get_freelancer_profile_usecase.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/usecases/get_work_details_usecase.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/usecases/get_advertisement_details_usecase.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/cubits/freelancer_cubit.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/cubits/work_details_cubit.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/cubits/advertisement_details_cubit.dart';
import 'package:ehtirafy_app/features/client/booking/data/repositories/booking_repository_impl.dart';
import 'package:ehtirafy_app/features/client/booking/domain/repositories/booking_repository.dart';
import 'package:ehtirafy_app/features/client/booking/domain/usecases/submit_booking_request_usecase.dart';
import 'package:ehtirafy_app/features/client/booking/presentation/cubit/booking_cubit.dart';
import 'package:ehtirafy_app/features/client/contract/data/repositories/contract_repository_impl.dart';
import 'package:ehtirafy_app/features/client/contract/data/datasources/contract_remote_data_source.dart';
import 'package:ehtirafy_app/features/client/contract/domain/repositories/contract_repository.dart';
import 'package:ehtirafy_app/features/client/contract/domain/usecases/get_contract_details_usecase.dart';
import 'package:ehtirafy_app/features/client/contract/domain/usecases/update_contract_status_usecase.dart';
import 'package:ehtirafy_app/features/client/contract/domain/usecases/confirm_payment_usecase.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/manager/contract_details_cubit.dart';
import 'package:ehtirafy_app/features/shared/chat/data/datasources/chat_remote_data_source.dart';
import 'package:ehtirafy_app/features/shared/chat/data/repositories/chat_repository_impl.dart';
import 'package:ehtirafy_app/features/shared/chat/domain/repositories/chat_repository.dart';
import 'package:ehtirafy_app/features/shared/chat/domain/usecases/get_conversations_usecase.dart';
import 'package:ehtirafy_app/features/shared/chat/domain/usecases/get_messages_usecase.dart';
import 'package:ehtirafy_app/features/shared/chat/domain/usecases/send_message_usecase.dart';

import 'package:ehtirafy_app/features/shared/chat/presentation/cubit/chat_cubit.dart';
import 'package:ehtirafy_app/features/shared/profile/data/datasources/profile_remote_datasource.dart';
import 'package:ehtirafy_app/features/shared/profile/data/repositories/profile_repository_impl.dart';
import 'package:ehtirafy_app/features/shared/profile/domain/repositories/profile_repository.dart';
import 'package:ehtirafy_app/features/shared/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:ehtirafy_app/features/shared/profile/domain/usecases/switch_user_role_usecase.dart';
import 'package:ehtirafy_app/features/shared/profile/domain/usecases/update_profile_usecase.dart';
import 'package:ehtirafy_app/features/shared/profile/presentation/manager/profile_cubit.dart';
import 'package:ehtirafy_app/features/freelancer/data/datasources/freelancer_gigs_remote_data_source.dart';
import 'package:ehtirafy_app/features/freelancer/data/repositories/freelancer_gigs_repository_impl.dart';
import 'package:ehtirafy_app/features/freelancer/domain/repositories/freelancer_dashboard_repository.dart';
import 'package:ehtirafy_app/features/freelancer/domain/repositories/freelancer_gigs_repository.dart';
import 'package:ehtirafy_app/features/freelancer/domain/repositories/freelancer_portfolio_repository.dart';
import 'package:ehtirafy_app/features/freelancer/data/repositories/freelancer_orders_repository_impl.dart';
import 'package:ehtirafy_app/features/freelancer/data/repositories/freelancer_portfolio_repository_impl.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/cubit/freelancer_dashboard_cubit.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/cubit/freelancer_gigs_cubit.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/cubit/freelancer_orders_cubit.dart';
import 'package:ehtirafy_app/features/freelancer/data/datasources/freelancer_portfolio_remote_data_source.dart';
import 'package:ehtirafy_app/features/freelancer/presentation/cubit/freelancer_portfolio_cubit.dart';
import 'package:ehtirafy_app/features/shared/splash/presentation/cubits/splash_cubit.dart';
import 'package:ehtirafy_app/features/shared/settings/data/datasources/settings_remote_datasource.dart';
import 'package:ehtirafy_app/features/shared/settings/data/repositories/settings_repository_impl.dart';
import 'package:ehtirafy_app/features/shared/settings/domain/repositories/settings_repository.dart';
import 'package:ehtirafy_app/features/shared/settings/domain/usecases/get_contact_us_usecase.dart';
import 'package:ehtirafy_app/features/shared/settings/domain/usecases/get_privacy_policy_usecase.dart';
import 'package:ehtirafy_app/features/shared/settings/domain/usecases/get_terms_conditions_usecase.dart';
import 'package:ehtirafy_app/features/shared/settings/presentation/cubit/settings_cubit.dart';
import 'package:ehtirafy_app/features/shared/reviews/data/datasources/reviews_remote_data_source.dart';
import 'package:ehtirafy_app/features/shared/reviews/data/repositories/reviews_repository_impl.dart';
import 'package:ehtirafy_app/features/shared/reviews/domain/repositories/reviews_repository.dart';
import 'package:ehtirafy_app/features/shared/reviews/domain/usecases/add_rate_usecase.dart';
import 'package:ehtirafy_app/features/shared/reviews/domain/usecases/get_user_rates_usecase.dart';
import 'package:ehtirafy_app/features/shared/reviews/presentation/cubits/reviews_cubit.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  // External dependencies - only register if not already registered (main.dart may have pre-registered)
  if (!sl.isRegistered<SharedPreferences>()) {
    final sharedPreferences = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferences>(sharedPreferences);
  }

  // Data layer
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<RoleRepository>(() => RoleRepositoryImpl());

  // Network
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Domain layer
  sl.registerFactory<LoginUseCase>(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton<SignupUseCase>(
    () => SignupUseCase(sl<AuthRepository>()),
  );
  sl.registerFactory<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerFactory<SendOtpUseCase>(
    () => SendOtpUseCase(sl<AuthRepository>()),
  );
  sl.registerFactory<GetRoleUseCase>(() => GetRoleUseCase(sl()));
  sl.registerFactory<SetRoleUseCase>(() => SetRoleUseCase(sl()));

  // Presentation layer
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl<LoginUseCase>()));
  sl.registerFactory<SignupCubit>(
    () => SignupCubit(sl<SignupUseCase>(), sl<SendOtpUseCase>()),
  );
  sl.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(sl<ForgotPasswordUseCase>()),
  );
  sl.registerFactory<OtpCubit>(() => OtpCubit());
  sl.registerLazySingleton<RoleCubit>(
    () => RoleCubit(sl<GetRoleUseCase>(), sl<SetRoleUseCase>()),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Splash
  sl.registerFactory<SplashCubit>(
    () => SplashCubit(
      userLocalDataSource: sl<UserLocalDataSource>(),
      getRoleUseCase: sl<GetRoleUseCase>(),
    ),
  );

  // Features - Notifications
  sl.registerFactory(
    () => NotificationsCubit(
      getNotificationsUseCase: sl(),
      markNotificationReadUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationReadUseCase(sl()));
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSourceImpl(dioClient: sl()),
  );
  // Features - Search
  sl.registerFactory(() => SearchCubit(searchUseCase: sl()));
  sl.registerLazySingleton(() => SearchUseCase(sl()));
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<SearchLocalDataSource>(
    () => SearchLocalDataSourceImpl(sharedPreferences: sl()),
  );
  // Features - Home
  sl.registerFactory(
    () => HomeCubit(
      getFeaturedPhotographersUseCase: sl(),
      getCategoriesUseCase: sl(),
      getAppStatisticsUseCase: sl(),
      userLocalDataSource: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetFeaturedPhotographersUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetAppStatisticsUseCase(sl()));
  sl.registerLazySingleton(() => GetAdvertisementsByCategoryUseCase(sl()));
  sl.registerLazySingleton(() => GetAllFreelancersUseCase(sl()));
  sl.registerFactory(() => AllFreelancersCubit(getAllFreelancersUseCase: sl()));
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(dioClient: sl()),
  );
  // Features - Category Advertisements
  sl.registerFactory(
    () => CategoryAdvertisementsCubit(getAdvertisementsByCategoryUseCase: sl()),
  );
  // Features - Freelancer
  sl.registerFactory(
    () => FreelancerCubit(
      getFreelancerProfileUseCase: sl(),
      getUserRatesUseCase: sl<GetUserRatesUseCase>(),
    ),
  );
  sl.registerLazySingleton(() => GetFreelancerProfileUseCase(sl()));
  sl.registerLazySingleton<FreelancerRepository>(
    () => FreelancerRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<FreelancerRemoteDataSource>(
    () => FreelancerRemoteDataSourceImpl(dioClient: sl()),
  );

  // Features - Work Details
  sl.registerFactory(() => WorkDetailsCubit(getWorkDetailsUseCase: sl()));
  sl.registerLazySingleton(() => GetWorkDetailsUseCase(sl()));

  // Features - Advertisement Details
  sl.registerFactory(
    () => AdvertisementDetailsCubit(getAdvertisementDetailsUseCase: sl()),
  );
  sl.registerLazySingleton(() => GetAdvertisementDetailsUseCase(sl()));
  // Features - Booking
  // Booking Feature
  sl.registerFactory(() => ResetPasswordCubit(sl()));
  sl.registerFactory(() => BookingCubit(sl()));
  sl.registerLazySingleton(() => SubmitBookingRequestUseCase(sl()));
  sl.registerLazySingleton<BookingRepository>(
    () =>
        BookingRepositoryImpl(remoteDataSource: sl(), sharedPreferences: sl()),
  );
  // Features - Contract
  sl.registerFactory(
    () => ContractDetailsCubit(
      getContractDetailsUseCase: sl(),
      updateContractStatusUseCase: sl(),
      confirmPaymentUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetContractDetailsUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmPaymentUseCase(sl()));
  sl.registerLazySingleton(() => UpdateContractStatusUseCase(sl()));
  sl.registerLazySingleton<ContractRepository>(
    () => ContractRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ContractRemoteDataSource>(
    () => ContractRemoteDataSourceImpl(sl()),
  );

  // Features - Chat
  sl.registerFactory(
    () => ChatCubit(
      getConversationsUseCase: sl(),
      getMessagesUseCase: sl(),
      sendMessageUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetConversationsUseCase(sl()));
  sl.registerLazySingleton(() => GetMessagesUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(sl()));
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(dioClient: sl()),
  );

  // Features - Profile
  sl.registerFactory(
    () => ProfileCubit(
      getUserProfileUseCase: sl(),
      switchUserRoleUseCase: sl(),
      updateProfileUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetUserProfileUseCase(sl()));
  sl.registerLazySingleton(() => SwitchUserRoleUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sharedPreferences: sl(), dioClient: sl()),
  );

  // Features - Freelancer Dashboard
  sl.registerFactory(
    () => FreelancerDashboardCubit(
      repository: sl(),
      getFreelancerStatisticsUseCase: sl(),
      getFreelancerLastContractsUseCase: sl(),
    ),
  );
  sl.registerLazySingleton<FreelancerDashboardRepository>(
    () => FreelancerDashboardRepositoryImpl(
      userLocalDataSource: sl(),
      gigsRemoteDataSource: sl(),
      portfolioRemoteDataSource: sl(),
      dashboardRemoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<FreelancerDashboardRemoteDataSource>(
    () => FreelancerDashboardRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton(() => GetFreelancerStatisticsUseCase(sl()));
  sl.registerLazySingleton(() => GetFreelancerLastContractsUseCase(sl()));

  // Features - Freelancer Gigs
  sl.registerFactory(() => FreelancerGigsCubit(repository: sl()));
  sl.registerLazySingleton<FreelancerGigsRemoteDataSource>(
    () => FreelancerGigsRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<FreelancerGigsRepository>(
    () => FreelancerGigsRepositoryImpl(remoteDataSource: sl()),
  );

  // Features - Freelancer Orders
  sl.registerFactory(() => FreelancerOrdersCubit(repository: sl()));
  sl.registerLazySingleton<FreelancerOrdersRepository>(
    () => FreelancerOrdersRepositoryImpl(
      remoteDataSource: sl(),
      sharedPreferences: sl(),
    ),
  );

  // Features - Freelancer Portfolio
  sl.registerFactory(() => FreelancerPortfolioCubit(repository: sl()));
  // Portfolio
  sl.registerLazySingleton<FreelancerPortfolioRemoteDataSource>(
    () => FreelancerPortfolioRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<FreelancerPortfolioRepository>(
    () => FreelancerPortfolioRepositoryImpl(remoteDataSource: sl()),
  );

  // Features - Settings
  sl.registerFactory(
    () => SettingsCubit(
      getPrivacyPolicyUseCase: sl(),
      getTermsConditionsUseCase: sl(),
      getContactUsUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetPrivacyPolicyUseCase(sl()));
  sl.registerLazySingleton(() => GetTermsConditionsUseCase(sl()));
  sl.registerLazySingleton(() => GetContactUsUseCase(sl()));
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SettingsRemoteDataSource>(
    () => SettingsRemoteDataSourceImpl(dioClient: sl()),
  );

  // Features - Reviews
  sl.registerFactory(
    () => ReviewsCubit(addRateUseCase: sl(), getUserRatesUseCase: sl()),
  );
  sl.registerLazySingleton(() => AddRateUseCase(sl()));
  sl.registerLazySingleton(() => GetUserRatesUseCase(sl()));
  sl.registerLazySingleton<ReviewsRepository>(
    () => ReviewsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ReviewsRemoteDataSource>(
    () => ReviewsRemoteDataSourceImpl(dioClient: sl()),
  );
}
