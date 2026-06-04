import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // GlobalKey<FormState>: a unique handle to our Form widget
  // Lets us call _formKey.currentState!.validate() from the button
  // "global" = works across the widget tree, not just in build()
  final _formKey = GlobalKey<FormState>();

  // TextEditingController: reads what the user typed in a field
  // One controller per field
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // _isLoading: shows a spinner on the button while "signing in"
  // In Phase 1 (mock data), we simulate a 1.5s network call
  bool _isLoading = false;

  @override
  void dispose() {
    // Controllers allocate memory — always dispose them
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    // validate() runs every field's validator function
    // Returns true only if ALL validators return null
    // Also shows error messages under each invalid field
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate network call (mock — replace with real API later)
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;
    setState(() => _isLoading = false);

    // Navigate to home, replacing the entire stack
    // go() = replace current route  |  push() = add on top (back button returns here)
    // We use go() so user can't press back to return to Login
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // SingleChildScrollView: makes the screen scrollable when keyboard appears
      // Without this, fields behind the keyboard are inaccessible
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),

              // ── App icon + branding ───────────────────────────────────
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.home_repair_service_rounded,
                    size: 38,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ── Page heading ──────────────────────────────────────────
              Text('Welcome Back!', style: AppTextStyles.displayMedium),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 40),

              // ── Form ──────────────────────────────────────────────────
              // Form groups all TextFormFields inside it
              // When _formKey.currentState!.validate() is called,
              // it triggers every child TextFormField's validator
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      label: 'Email Address',
                      hint: 'Enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        // Basic email check — contains @ and a dot after it
                        if (!RegExp(r'^[\w.-]+@[\w.-]+\.\w+$')
                            .hasMatch(value.trim())) {
                          return 'Please enter a valid email';
                        }
                        return null; // null = valid
                      },
                    ),

                    const SizedBox(height: 20),

                    AppTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: _passwordController,
                      isPassword: true,
                      prefixIcon: Icons.lock_outline,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: _onLoginPressed,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 12),

                    // Forgot password — right aligned
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: navigate to forgot password screen
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 36),
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ── Login button ──────────────────────────────────────────
              ElevatedButton(
                onPressed: _isLoading ? null : _onLoginPressed,
                // disabled when loading — prevents double-tap
                child: _isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Login'),
              ),

              const SizedBox(height: 24),

              // ── Register link ─────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.register),
                    // push() = adds Register on top of Login stack
                    // User can press back to return to Login
                    child: Text(
                      'Register',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
