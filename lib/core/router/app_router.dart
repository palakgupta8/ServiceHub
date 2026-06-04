import 'package:go_router/go_router.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/service_detail/service_detail_screen.dart';
import '../../features/booking/booking_screen.dart';
import '../../features/booking/booking_success_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash          = '/';
  static const String onboarding      = '/onboarding';
  static const String login           = '/login';
  static const String register        = '/register';
  static const String home            = '/home';
  static const String serviceDetail   = '/service/:id';
  static const String booking         = '/booking';
  static const String bookingSuccess  = '/booking/success';
  static const String profile         = '/profile';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: SplashScreen()),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: OnboardingScreen()),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: LoginScreen()),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: HomeScreen()),
    ),
    GoRoute(
      path: AppRoutes.serviceDetail,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ServiceDetailScreen(serviceId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.booking,
      builder: (context, state) {
        // extra: carries the serviceId passed from the detail screen
        // cast to String with fallback to empty string for safety
        final serviceId = (state.extra as String?) ?? '';
        return BookingScreen(serviceId: serviceId);
      },
    ),
    GoRoute(
      path: AppRoutes.bookingSuccess,
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: BookingSuccessScreen()),
    ),
  ],
);
