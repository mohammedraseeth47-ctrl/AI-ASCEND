import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_radius.dart';
import 'package:trackgo_driver/core/theme/app_spacing.dart';
import 'package:trackgo_driver/core/theme/app_typography.dart';
import 'package:trackgo_driver/core/widgets/trackgo_button.dart';
import 'package:trackgo_driver/core/widgets/trackgo_text_field.dart';
import 'package:trackgo_driver/features/authentication/presentation/controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    setState(() {
      _errorMessage = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authController = context.read<AuthController>();
    final success = await authController.resetPassword(
      _emailController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (success) {
        _isSuccess = true;
      } else {
        _errorMessage =
            authController.errorMessage ??
            'Failed to send password reset request.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: _isSuccess ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_reset_rounded,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Forgot Password?',
            style: AppTypography.headlineLarge.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Enter your registered driver email and we will send password reset instructions to your depot administrator.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),

          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              margin: const EdgeInsets.only(bottom: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: AppRadius.roundedMd,
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                _errorMessage!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.errorDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],

          TrackGoTextField(
            controller: _emailController,
            label: 'Driver Email Address',
            hintText: 'e.g. driver@trackgo.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email address';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.xxl),

          TrackGoButton(
            text: 'Send Reset Link',
            icon: Icons.send_rounded,
            isLoading: _isLoading,
            onPressed: _handleReset,
          ),
          const SizedBox(height: AppSpacing.lg),

          TrackGoButton(
            text: 'Back to Login',
            variant: TrackGoButtonVariant.text,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: const BoxDecoration(
            color: AppColors.successLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            size: 56,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Reset Request Sent',
          style: AppTypography.headlineLarge.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimaryLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'A password reset confirmation has been dispatched for ${_emailController.text.trim()}. Please verify your inbox or contact your depot dispatch supervisor.',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxxl),
        TrackGoButton(
          text: 'Return to Login',
          icon: Icons.arrow_back_rounded,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
