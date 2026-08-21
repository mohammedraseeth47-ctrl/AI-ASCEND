import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage_service.dart';

/// Provider for LocalStorageService instance.
/// Overridden in main.dart once SharedPreferences initializes.
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError('localStorageServiceProvider has not been initialized');
});
