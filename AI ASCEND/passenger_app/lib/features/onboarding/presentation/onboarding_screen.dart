import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../data/onboarding_data.dart';
import '../providers/onboarding_provider.dart';
import 'widgets/onboarding_indicator.dart';
import 'widgets/onboarding_page_content.dart';

/// 3-Screen Onboarding experience with persistent completion logic.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    ref.read(onboardingProvider.notifier).setPage(index);
  }

  Future<void> _completeAndNavigate() async {
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.main);
  }

  void _nextPage() {
    final state = ref.read(onboardingProvider);
    if (state.currentPage < OnboardingData.items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _completeAndNavigate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final isLastPage = state.currentPage == OnboardingData.items.length - 1;
    final currentItem = OnboardingData.items[state.currentPage];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (!isLastPage)
            TextButton(
              onPressed: _completeAndNavigate,
              child: Text(
                'Skip',
                style: AppTextStyles.labelLarge.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Onboarding PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: OnboardingData.items.length,
                itemBuilder: (context, index) {
                  return OnboardingPageContent(
                    item: OnboardingData.items[index],
                  );
                },
              ),
            ),

            // Bottom Navigation Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Indicator
                  OnboardingIndicator(
                    count: OnboardingData.items.length,
                    currentIndex: state.currentPage,
                    activeColor: currentItem.primaryColor,
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      if (state.currentPage > 0) ...[
                        IconButton.filledTonal(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(Icons.arrow_back_rounded),
                          style: IconButton.styleFrom(
                            minimumSize: const Size(52, 52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: AppButton(
                          text: isLastPage ? 'Get Started' : 'Continue',
                          suffixIcon: isLastPage
                              ? Icons.arrow_forward_rounded
                              : Icons.chevron_right_rounded,
                          onPressed: _nextPage,
                        ),
                      ),
                    ],
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
