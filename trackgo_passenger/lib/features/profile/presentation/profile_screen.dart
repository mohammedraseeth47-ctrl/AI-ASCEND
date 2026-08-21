import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/storage_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../core/widgets/app_card.dart';
import '../providers/profile_provider.dart';
import 'widgets/settings_tile.dart';
import 'widgets/theme_mode_dialog.dart';

/// Profile and Passenger Preferences screen tailored for Tamil Nadu.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      case ThemeMode.system:
        return 'System Default';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Passenger Profile'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Passenger Profile Placeholder Card
              AppCard(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(80),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.person_rounded, color: Colors.white, size: 30),
                      ),
                    ),
                    UIHelpers.hSpace16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tamil Nadu Passenger',
                            style: AppTextStyles.headlineSmall.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          UIHelpers.vSpace4,
                          Text(
                            'passenger@trackgo.in',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          UIHelpers.vSpace4,
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(isDark ? 40 : 20),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Region: Villupuram • Cuddalore • Puducherry',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              UIHelpers.vSpace24,

              // Settings Section
              Text(
                'Settings & Preferences',
                style: AppTextStyles.labelLarge.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
              UIHelpers.vSpace8,

              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    // Theme Switcher
                    SettingsTile(
                      icon: Icons.palette_outlined,
                      title: 'Appearance',
                      subtitle: _themeModeLabel(profileState.themeMode),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => const ThemeModeDialog(),
                        );
                      },
                    ),
                    const Divider(height: 1),

                    // Notification Switch
                    SettingsTile(
                      icon: Icons.notifications_outlined,
                      title: 'Arrival Notifications',
                      subtitle: 'Alerts when bus approaches Villupuram or Cuddalore stands',
                      trailing: Switch.adaptive(
                        value: profileState.notificationsEnabled,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) {
                          ref.read(profileProvider.notifier).toggleNotifications(val);
                        },
                      ),
                    ),
                    const Divider(height: 1),

                    // Audio Alerts Switch
                    SettingsTile(
                      icon: Icons.volume_up_outlined,
                      title: 'Sound Alerts',
                      subtitle: 'Transit chime on approach countdown',
                      trailing: Switch.adaptive(
                        value: profileState.soundAlertsEnabled,
                        activeThumbColor: AppColors.primary,
                        onChanged: (val) {
                          ref.read(profileProvider.notifier).toggleSoundAlerts(val);
                        },
                      ),
                    ),
                    const Divider(height: 1),

                    // Map info
                    SettingsTile(
                      icon: Icons.map_outlined,
                      title: 'Map Provider',
                      subtitle: 'OpenStreetMap (Tamil Nadu Region)',
                      onTap: () {
                        UIHelpers.showSnackBar(
                          context,
                          message: 'TrackGo uses OpenStreetMap tiles focused on Tamil Nadu without private API keys.',
                          icon: Icons.map_rounded,
                        );
                      },
                    ),
                  ],
                ),
              ),
              UIHelpers.vSpace24,

              // About TrackGo Section
              Text(
                'About TrackGo',
                style: AppTextStyles.labelLarge.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w700,
                ),
              ),
              UIHelpers.vSpace8,

              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Icons.info_outline_rounded,
                      title: 'System Information',
                      subtitle: AppConstants.appVersion,
                      onTap: () {
                        showAboutDialog(
                          context: context,
                          applicationName: AppConstants.appName,
                          applicationVersion: AppConstants.appVersion,
                          applicationLegalese: '© 2026 TrackGo.\nReal-Time Public Transportation Tracking System for Tamil Nadu.\nOpenStreetMap Data © OpenStreetMap contributors.',
                        );
                      },
                    ),
                    const Divider(height: 1),
                    SettingsTile(
                      icon: Icons.replay_rounded,
                      title: 'Replay Onboarding Tour',
                      subtitle: 'Review the 3-step Tamil Nadu transit guide',
                      iconColor: AppColors.accentAmber,
                      onTap: () async {
                        final storage = ref.read(localStorageServiceProvider);
                        await storage.setOnboardingCompleted(false);
                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
                        }
                      },
                    ),
                  ],
                ),
              ),
              UIHelpers.vSpace32,
            ],
          ),
        ),
      ),
    );
  }
}
