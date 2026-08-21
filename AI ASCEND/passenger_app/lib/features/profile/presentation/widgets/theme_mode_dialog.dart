import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../providers/profile_provider.dart';

/// Modal dialog for choosing application theme mode.
class ThemeModeDialog extends ConsumerWidget {
  const ThemeModeDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final currentMode = profileState.themeMode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text('Select Theme', style: AppTextStyles.headlineSmall),
      contentPadding: const EdgeInsets.symmetric(vertical: 12),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _themeOption(
            context,
            ref,
            title: 'System Default',
            icon: Icons.brightness_auto_rounded,
            mode: ThemeMode.system,
            isSelected: currentMode == ThemeMode.system,
          ),
          _themeOption(
            context,
            ref,
            title: 'Light Theme',
            icon: Icons.light_mode_rounded,
            mode: ThemeMode.light,
            isSelected: currentMode == ThemeMode.light,
          ),
          _themeOption(
            context,
            ref,
            title: 'Dark Theme',
            icon: Icons.dark_mode_rounded,
            mode: ThemeMode.dark,
            isSelected: currentMode == ThemeMode.dark,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    );
  }

  Widget _themeOption(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required IconData icon,
    required ThemeMode mode,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        ref.read(profileProvider.notifier).setThemeMode(mode);
        Navigator.of(context).pop();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isSelected ? AppColors.primary : AppColors.textSecondaryLight),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : null,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
