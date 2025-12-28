import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ehtirafy_app/firebase_options.dart';
import 'package:ehtirafy_app/core/notifications/background_handler.dart';
import 'package:ehtirafy_app/core/notifications/notification_service.dart';

/// Global variable to hold the initial route determined at startup
String _initialRoute = '/onboarding';

Future<void> main() async {
  // Preserve the native splash screen until critical init is done
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  try {
    // CRITICAL: Only essential init before splash removal
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize Localization (needed for UI)
    await EasyLocalization.ensureInitialized();

    // Quick route determination
    final prefs = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferences>(prefs);
    _initialRoute = _getInitialRoute(prefs);
  } catch (e) {
    FlutterNativeSplash.remove();
    runApp(ErrorApp(error: e.toString()));
    return;
  }

  // Remove splash BEFORE heavy DI setup
  FlutterNativeSplash.remove();

  // Continue initialization in background (non-blocking)
  _initializeServicesAsync();

  // Run the app immediately
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar', 'SA')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar', 'SA'),
      startLocale: const Locale('ar', 'SA'),
      child: const MyApp(),
    ),
  );
}

/// Non-blocking background initialization
void _initializeServicesAsync() {
  Future.microtask(() async {
    try {
      // Complete DI setup
      await setupLocator();

      // Setup notifications
      FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
      await NotificationService().initialize();
    } catch (e) {
      debugPrint('Background init error: $e');
    }
  });
}

/// Determines initial route synchronously from already-loaded prefs
String _getInitialRoute(SharedPreferences prefs) {
  final token = prefs.getString('cached_token');
  if (token != null && token.isNotEmpty) {
    final roleString = prefs.getString('user_role');
    if (roleString == 'freelancer') {
      return '/freelancer/dashboard';
    }
    return '/home';
  }
  return '/onboarding';
}

/// Getter for the initial route (used by app_router.dart)
String get initialRoute => _initialRoute;

/// Error app shown when initialization fails
class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF1C1D18),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Initialization Error:\n$error',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'app_name'.tr(),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          routerConfig: appRouter,
        );
      },
    );
  }
}
