import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/storage_provider.dart';
import '../../../core/services/local_storage_service.dart';

/// State model for Onboarding flow.
class OnboardingState {
  final int currentPage;
  final bool isCompleted;

  const OnboardingState({
    required this.currentPage,
    required this.isCompleted,
  });

  OnboardingState copyWith({
    int? currentPage,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// Notifier handling onboarding page changes and persistence.
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final LocalStorageService _storageService;

  OnboardingNotifier(this._storageService)
      : super(OnboardingState(
          currentPage: 0,
          isCompleted: _storageService.isOnboardingCompleted,
        ));

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  Future<void> completeOnboarding() async {
    await _storageService.setOnboardingCompleted(true);
    state = state.copyWith(isCompleted: true);
  }
}

/// Riverpod provider for onboarding state.
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final storageService = ref.watch(localStorageServiceProvider);
  return OnboardingNotifier(storageService);
});
