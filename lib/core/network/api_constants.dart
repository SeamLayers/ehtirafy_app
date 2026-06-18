class ApiConstants {
  static const String baseUrl = 'https://ehtraphy.site/Memory-App';
  static const String version = 'v1';

  // Auth Endpoints
  static const String register = '/api/$version/auth/register';
  static const String login = '/api/$version/auth/login';
  static const String logout = '/api/$version/auth/logout';
  static const String forgotPassword = '/api/$version/auth/forgot-password';
  static const String resetPassword = '/api/$version/auth/reset-password';
  static const String sendOtp = '/api/$version/auth/send-otp';
  static const String verifyOtp = '/api/$version/auth/verify-otp';
  static String deleteAccount(String id) => '/api/$version/auth/delete-account/$id';

  // Notifications Endpoint
  // Collection exposes `notifications-firebase` for the list; mark-as-read
  // stays at notifications/{id}/read.
  static const String notifications = '/api/$version/notifications-firebase';
  static String readNotification(String id) =>
      '/api/$version/notifications/$id/read';

  // Freelancer Profile Endpoint
  static String freelancerProfile(String id) =>
      '$baseUrl/api/$version/get-freelancer-profile/$id';

  // Advertisements by Category
  static String advertisementsByCategory(String categoryId) =>
      '$baseUrl/api/$version/advertisements/category/$categoryId';

  // Freelancer Endpoints
  // Advertisements endpoint - requires user_type query param:
  // - user_type=freelancer → Freelancer (photographer) sees their own gigs
  // - user_type=customer → Customer (client) sees all available ads
  static const String advertisements =
      '$baseUrl/api/$version/front/advertisements';
  static const String freelancerPortfolio =
      '$baseUrl/api/$version/front/our-works';

  // Profile Endpoints
  static const String profileData = '/api/$version/front/profile-data';
  static const String updateProfile = '/api/$version/front/update-data';

  // Settings Endpoints
  static const String privacyPolicy = '/api/$version/privacy-policy';
  static const String termsConditions = '/api/$version/terms-conditions';
  static const String contactUs = '/api/$version/contact-us';

  // Categories Endpoint
  static const String categories = '$baseUrl/api/$version/categories';

  // Contract Endpoints
  static const String initialContract =
      '$baseUrl/api/$version/front/initial-contract';
  static const String contractsRelative =
      '$baseUrl/api/$version/front/contracts-relative';
  static String updateContract(String id) =>
      '$baseUrl/api/$version/front/contract/$id/update';
  static String contractDetail(String id) =>
      '$baseUrl/api/$version/contract-detail/$id';

  // Dashboard & Search & Home
  static String freelancerStatistics(String id) =>
      '$baseUrl/api/$version/freelancer/$id/statistics';
  static String freelancerLastContracts(String id) =>
      '$baseUrl/api/$version/freelancer/$id/last-contracts';
  static const String search = '$baseUrl/api/$version/search';
  static const String bestFreelancers =
      '$baseUrl/api/$version/best-freelancers';

  /// All freelancers (full directory) — used by the home freelancers rail and
  /// the "All Freelancers" screen. Distinct from [bestFreelancers].
  static const String allFreelancersData =
      '$baseUrl/api/$version/all-freelancers-data';

  // App-wide settings / metadata
  static const String appStatistics = '/api/$version/app/statistics';
  static const String globalConstants = '/api/$version/global-constants';

  // Reviews / ratings
  static const String addRate = '$baseUrl/api/$version/front/add-rate';

  // Detail Endpoints
  /// Get advertisement/service details by ID
  static String advertisementDetails(String id) =>
      '$baseUrl/api/$version/front/advertisements/$id';

  /// Get portfolio work details by ID
  static String portfolioItemDetails(String id) =>
      '$baseUrl/api/$version/front/our-works/$id';

  /// Get user ratings by user/freelancer ID
  static String userRates(String userId) =>
      '/api/$version/front/user-rates/$userId';

  // Payment Endpoints
  static const String submitPaymentProof =
      '$baseUrl/api/$version/front/create-transaction';
}
