import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../providers/search_provider.dart';

class FilterCategoryItem {
  final SearchCategory category;
  final String label;
  final IconData icon;

  const FilterCategoryItem({
    required this.category,
    required this.label,
    required this.icon,
  });
}

/// Horizontal category filter chips for Search screen.
class SearchFilterChips extends StatelessWidget {
  final SearchCategory selectedCategory;
  final ValueChanged<SearchCategory> onSelected;

  const SearchFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const categories = [
      FilterCategoryItem(category: SearchCategory.all, label: 'All', icon: Icons.tune_rounded),
      FilterCategoryItem(category: SearchCategory.busLines, label: 'Bus Lines', icon: Icons.directions_bus_rounded),
      FilterCategoryItem(category: SearchCategory.stops, label: 'Stops & Stations', icon: Icons.pin_drop_rounded),
      FilterCategoryItem(category: SearchCategory.places, label: 'Destinations', icon: Icons.place_rounded),
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = categories[index];
          final isSelected = item.category == selectedCategory;

          return InkWell(
            onTap: () => onSelected(item.category),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 15,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.label,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
