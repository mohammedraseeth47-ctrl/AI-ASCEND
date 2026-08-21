import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';

class QuickActionItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const QuickActionItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

/// Responsive 2x2 Quick actions grid designed for all screen widths without overflow.
class QuickActionsGrid extends StatelessWidget {
  final List<QuickActionItem> actions;

  const QuickActionsGrid({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 500 ? 4 : 2;
        final childAspectRatio = constraints.maxWidth > 500 ? 2.2 : 2.4;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (context, index) {
            final action = actions[index];
            return AppCard(
              onTap: action.onTap,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: action.color.withAlpha(isDark ? 40 : 25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      action.icon,
                      color: action.color,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      action.title,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
