import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/models/onboarding_model.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/dots_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

// Why StatefulWidget here?
// We need to track TWO things that change over time:
//   1. _currentPage — which slide we're on (0, 1, or 2)
//   2. PageController — controls the PageView programmatically (for the Next button)
// Any time something on screen changes based on user interaction → StatefulWidget

class _OnboardingScreenState extends State<OnboardingScreen> {
  // PageController: the "remote control" for PageView
  // Without it, you can only swipe — you can't jump to a page via a button
  final PageController _pageController = PageController();

  // _currentPage: tracks which slide is currently visible
  // Starts at 0 (first page), updates every time user swipes or taps Next
  int _currentPage = 0;

  // Convenience getter — is the user on the last slide right now?
  // A getter is a computed property: it recalculates every time it's accessed
  bool get _isLastPage => _currentPage == onboardingPages.length - 1;

  @override
  void dispose() {
    // PageController internally uses resources (listeners, scroll tracking)
    // Always dispose it to free those resources when screen is removed
    _pageController.dispose();
    super.dispose();
  }

  // Called when user taps "Next" button
  void _onNextTapped() {
    if (_isLastPage) {
      _completeOnboarding();
    } else {
      // animateToPage: smoothly slides to the next page
      // duration: how long the slide animation takes
      // curve: the easing of the slide motion
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  // Called when user taps "Skip" — jumps straight to login
  void _onSkipTapped() {
    _completeOnboarding();
  }

  // Marks onboarding as seen and navigates to login
  Future<void> _completeOnboarding() async {
    // Save the flag so splash screen knows not to show onboarding again
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyOnboardingSeen, true);

    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // SafeArea: adds padding to avoid notches, status bar, and home indicator
        // Always use SafeArea as the root of your Scaffold body
        child: Column(
          children: [
            // ── Skip button ───────────────────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                // Visibility: hides the Skip button on the last page
                // (replaced visually by "Get Started" button at the bottom)
                child: Visibility(
                  visible: !_isLastPage,
                  maintainSize: true,     // keep the space even when invisible
                  maintainAnimation: true, // these 3 together = invisible but still
                  maintainState: true,     // takes up the same space (no layout jump)
                  child: TextButton(
                    onPressed: _onSkipTapped,
                    child: Text(
                      'Skip',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── PageView (the swipeable slides) ───────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onboardingPages.length,

                // onPageChanged: called every time the visible page changes
                // Whether the user swipes OR we call animateToPage — this fires
                onPageChanged: (index) {
                  // setState: tells Flutter "something changed, rebuild the UI"
                  // Without this, _currentPage updates but the dots won't redraw
                  setState(() {
                    _currentPage = index;
                  });
                },

                // itemBuilder: called once per page to build that page's widget
                // index = 0, 1, 2 for each slide
                itemBuilder: (context, index) {
                  return OnboardingPage(page: onboardingPages[index]);
                },
              ),
            ),

            // ── Bottom controls (dots + button) ──────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [
                  // Dots indicator
                  DotsIndicator(
                    totalDots: onboardingPages.length,
                    currentIndex: _currentPage,
                  ),

                  const SizedBox(height: 32),

                  // Next / Get Started button
                  // AnimatedSwitcher: when child changes, animates the transition
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: ElevatedButton(
                      // key: required by AnimatedSwitcher to know WHICH child changed
                      // Without unique keys, AnimatedSwitcher can't detect the swap
                      key: ValueKey(_isLastPage),
                      onPressed: _onNextTapped,
                      child: Text(_isLastPage ? 'Get Started' : 'Next'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
