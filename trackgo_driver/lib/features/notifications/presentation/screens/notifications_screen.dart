import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_radius.dart';
import 'package:trackgo_driver/core/theme/app_spacing.dart';
import 'package:trackgo_driver/core/theme/app_typography.dart';
import 'package:trackgo_driver/core/widgets/empty_state_view.dart';
import 'package:trackgo_driver/core/widgets/error_state_view.dart';
import 'package:trackgo_driver/core/widgets/loading_state_view.dart';
import 'package:trackgo_driver/core/widgets/trackgo_card.dart';
import 'package:trackgo_driver/features/notifications/domain/entities/driver_notification.dart';
import 'package:trackgo_driver/features/notifications/presentation/controllers/notifications_controller.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsController>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NotificationsController>();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Driver Bulletins & Alerts'),
        actions: [
          if (controller.unreadCount > 0)
            TextButton.icon(
              onPressed: () => controller.markAllAsRead(),
              icon: const Icon(Icons.done_all_rounded, size: 18),
              label: const Text('Mark all read'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: AppTypography.labelSmall,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Row
          _buildFilterBar(controller),
          const Divider(height: 1),

          // Notification List
          Expanded(child: _buildBody(controller)),
        ],
      ),
    );
  }

  Widget _buildFilterBar(NotificationsController controller) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ChoiceChip(
              label: Text(
                'All Bulletins (${controller.notifications.length + (controller.filterUnreadOnly ? controller.unreadCount : 0)})',
              ),
              selected: !controller.filterUnreadOnly,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.backgroundLight,
              labelStyle: AppTypography.labelMedium.copyWith(
                color: !controller.filterUnreadOnly
                    ? Colors.white
                    : AppColors.textSecondaryLight,
                fontWeight: !controller.filterUnreadOnly
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.roundedPill,
              ),
              showCheckmark: false,
              onSelected: (_) => controller.toggleUnreadFilter(false),
            ),
            const SizedBox(width: AppSpacing.sm),
            ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Unread Only'),
                  if (controller.unreadCount > 0) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: controller.filterUnreadOnly
                            ? Colors.white
                            : AppColors.primary,
                        borderRadius: AppRadius.roundedPill,
                      ),
                      child: Text(
                        '${controller.unreadCount}',
                        style: AppTypography.labelSmall.copyWith(
                          color: controller.filterUnreadOnly
                              ? AppColors.primaryDark
                              : Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              selected: controller.filterUnreadOnly,
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.backgroundLight,
              labelStyle: AppTypography.labelMedium.copyWith(
                color: controller.filterUnreadOnly
                    ? Colors.white
                    : AppColors.textSecondaryLight,
                fontWeight: controller.filterUnreadOnly
                    ? FontWeight.w700
                    : FontWeight.w500,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadius.roundedPill,
              ),
              showCheckmark: false,
              onSelected: (_) => controller.toggleUnreadFilter(true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(NotificationsController controller) {
    if (controller.isLoading) {
      return const LoadingStateView(message: 'Loading notifications...');
    }

    if (controller.errorMessage != null) {
      return ErrorStateView(
        message: controller.errorMessage!,
        onRetry: () => controller.loadNotifications(),
      );
    }

    if (controller.notifications.isEmpty) {
      return EmptyStateView(
        icon: Icons.notifications_none_rounded,
        title: controller.filterUnreadOnly
            ? 'No Unread Notifications'
            : 'All Caught Up',
        message: controller.filterUnreadOnly
            ? 'You have read all received driver bulletins and assignments.'
            : 'You currently have no new notifications.',
        actionText: controller.filterUnreadOnly ? 'Show All' : null,
        onActionPressed: controller.filterUnreadOnly
            ? () => controller.toggleUnreadFilter(false)
            : null,
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.loadNotifications(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: controller.notifications.length,
        separatorBuilder: (context, index) =>
            const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          final item = controller.notifications[index];
          return _NotificationItemCard(
            notification: item,
            onTap: () => controller.markAsRead(item.id),
          );
        },
      ),
    );
  }
}

class _NotificationItemCard extends StatelessWidget {
  final DriverNotification notification;
  final VoidCallback onTap;

  const _NotificationItemCard({
    required this.notification,
    required this.onTap,
  });

  IconData _getIcon() {
    switch (notification.type) {
      case NotificationType.assignment:
        return Icons.assignment_turned_in_rounded;
      case NotificationType.routeAlert:
        return Icons.warning_amber_rounded;
      case NotificationType.maintenance:
      case NotificationType.inspection:
        return Icons.build_circle_outlined;
      case NotificationType.scheduleUpdate:
        return Icons.update_rounded;
      case NotificationType.weather:
        return Icons.wb_sunny_outlined;
      case NotificationType.shiftVerification:
        return Icons.verified_user_outlined;
      case NotificationType.general:
        return Icons.campaign_rounded;
    }
  }

  Color _getIconColor() {
    switch (notification.type) {
      case NotificationType.assignment:
        return AppColors.primary;
      case NotificationType.routeAlert:
        return AppColors.warningDark;
      case NotificationType.maintenance:
      case NotificationType.inspection:
        return AppColors.secondaryDark;
      case NotificationType.scheduleUpdate:
        return AppColors.successDark;
      case NotificationType.weather:
        return AppColors.warningDark;
      case NotificationType.shiftVerification:
        return AppColors.primaryDark;
      case NotificationType.general:
        return AppColors.primaryDark;
    }
  }

  Color _getIconBgColor() {
    switch (notification.type) {
      case NotificationType.assignment:
        return AppColors.primaryContainer;
      case NotificationType.routeAlert:
        return AppColors.warningLight;
      case NotificationType.maintenance:
      case NotificationType.inspection:
        return AppColors.secondaryContainer;
      case NotificationType.scheduleUpdate:
        return AppColors.successLight;
      case NotificationType.weather:
        return AppColors.warningLight;
      case NotificationType.shiftVerification:
        return AppColors.primaryContainer;
      case NotificationType.general:
        return AppColors.primaryContainer;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TrackGoCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      backgroundColor: notification.isRead
          ? Colors.white
          : const Color(0xFFF8FAFC),
      borderSide: BorderSide(
        color: notification.isRead
            ? AppColors.cardBorderLight
            : AppColors.primary.withValues(alpha: 0.35),
        width: notification.isRead ? 1.0 : 1.5,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type Icon Container
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: _getIconBgColor(),
              borderRadius: AppRadius.roundedMd,
            ),
            child: Icon(_getIcon(), size: 20, color: _getIconColor()),
          ),
          const SizedBox(width: AppSpacing.md),

          // Notification Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: notification.isRead
                              ? FontWeight.w600
                              : FontWeight.w800,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      notification.timeAgo,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMutedLight,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  notification.message,
                  style: AppTypography.bodySmall.copyWith(
                    color: notification.isRead
                        ? AppColors.textSecondaryLight
                        : AppColors.textPrimaryLight,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Unread Indicator Dot
          if (!notification.isRead) ...[
            const SizedBox(width: AppSpacing.xs),
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
