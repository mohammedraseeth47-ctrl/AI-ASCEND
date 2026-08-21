import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackgo_driver/app/presentation/main_shell_screen.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_radius.dart';
import 'package:trackgo_driver/core/theme/app_spacing.dart';
import 'package:trackgo_driver/core/theme/app_typography.dart';
import 'package:trackgo_driver/core/widgets/trackgo_button.dart';
import 'package:trackgo_driver/core/widgets/trackgo_text_field.dart';
import 'package:trackgo_driver/features/authentication/presentation/controllers/auth_controller.dart';
import 'package:trackgo_driver/features/authentication/presentation/screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final authController = context.read<AuthController>();
    authController.clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await authController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShellScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxl,
              vertical: AppSpacing.lg,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Brand Header
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: AppRadius.roundedLg,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.directions_bus_filled_rounded,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Title & Subtitle
                  Text(
                    'TrackGo Driver',
                    textAlign: TextAlign.center,
                    style: AppTypography.displaySmall.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Tamil Nadu Public Transport System',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),

                  // Error Banner
                  if (authController.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.errorLight,
                        borderRadius: AppRadius.roundedMd,
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.error,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              authController.errorMessage!,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // Email Field
                  TrackGoTextField(
                    label: 'Driver ID or Email',
                    hintText: 'Enter your driver ID or email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.badge_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your driver email or ID';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Password Field
                  TrackGoTextField(
                    label: 'Password',
                    hintText: '••••••••',
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline_rounded,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.xs,
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: AppTypography.labelMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Sign In Button
                  TrackGoButton(
                    text: 'Sign In to Driver Portal',
                    icon: Icons.login_rounded,
                    isLoading: authController.isLoading,
                    onPressed: _handleLogin,
                  ),

                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
