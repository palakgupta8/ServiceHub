import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// We use StatefulWidget here (not StatelessWidget) because:
// 1. We need AnimationController — it requires a TickerProvider (from State)
// 2. We need to manage animation lifecycle (init → dispose)
// Rule: use StatefulWidget when you need to manage time-based or lifecycle state
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // SingleTickerProviderStateMixin gives us "vsync" for the AnimationController
  // vsync = synchronize animation with the screen refresh rate (60fps/120fps)
  // Without vsync, animations run even when the screen isn't visible — wastes battery

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // initState runs once when this widget is first inserted into the tree
    // This is where you set up animations and trigger async operations

    _setupAnimations();
    _navigateAfterDelay();
  }

  void _setupAnimations() {
    // AnimationController: the "clock" for our animation
    // duration: how long the full animation takes
    // vsync: this (our State) provides the ticker
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Fade animation: opacity goes from 0.0 → 1.0
    // CurvedAnimation: easeOut means it starts fast, slows down at the end
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        // Interval(0.0, 0.7): this animation only runs during 0%–70% of total duration
        // So fade completes in the first 840ms (70% of 1200ms)
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    // Slide animation: widget moves from 40px below → its normal position
    // Offset is in "fractions of widget size" — Offset(0, 0.3) means 30% of height downward
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero, // Offset.zero = (0,0) = normal position
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    // Start playing the animation forward
    _controller.forward();
  }

  Future<void> _navigateAfterDelay() async {
    // Wait 2.5 seconds total — gives animation time to complete + a pause
    await Future.delayed(const Duration(milliseconds: 2500));

    // Check if the widget is still mounted before doing anything with context
    // Why? If the user closes the app during the delay, this widget gets disposed
    // Using context on a disposed widget crashes the app
    if (!mounted) return;

    // Read from SharedPreferences to decide where to navigate
    final prefs = await SharedPreferences.getInstance();
    final bool onboardingSeen =
        prefs.getBool(AppConstants.keyOnboardingSeen) ?? false;
    // ?? false means: if the value is null (key doesn't exist yet), use false
    // First-time users won't have this key → null → false → show onboarding

    if (!mounted) return; // check again after the await

    // Navigate based on onboarding status
    // context.go() replaces the current route — splash is removed from the stack
    // (you don't want the back button to return to splash)
    if (onboardingSeen) {
      context.go(AppRoutes.home);
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    // ALWAYS dispose AnimationController in dispose()
    // If you forget: memory leak — the controller keeps running in the background
    // Rule: anything you create in initState that has a .dispose() method → dispose it
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor overrides the theme's scaffold background for this screen only
      backgroundColor: AppColors.primary,
      body: Center(
        // FadeTransition: listens to _fadeAnimation and rebuilds opacity automatically
        // More efficient than AnimatedBuilder because it only repaints the opacity layer
        child: FadeTransition(
          opacity: _fadeAnimation,
          // SlideTransition: listens to _slideAnimation and rebuilds position
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisSize.min = Column only takes as much height as its children need
              // (default is MainAxisSize.max = full screen height)
              children: [
                // App Icon container
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    // Subtle shadow to lift the icon off the background
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.home_repair_service_rounded,
                    size: 52,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 24),

                // App name
                Text(
                  AppConstants.appName,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  // .copyWith() creates a new TextStyle based on the existing one
                  // but with specific properties overridden
                  // Here: keep font, size, weight from displayMedium — just change color
                ),

                const SizedBox(height: 8),

                // Tagline
                Text(
                  'Home services at your doorstep',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
