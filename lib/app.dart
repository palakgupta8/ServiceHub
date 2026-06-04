import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';

class ServiceHubApp extends ConsumerWidget {
  const ServiceHubApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // MaterialApp.router: tells Flutter to use go_router for all navigation
    // instead of the built-in Navigator
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // routerConfig: hands control of all navigation to our appRouter
      // From this point, every screen change goes through app_router.dart
      routerConfig: appRouter,
    );
  }
}
