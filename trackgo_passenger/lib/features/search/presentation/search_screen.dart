import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_text_field.dart';
import '../providers/search_provider.dart';
import 'widgets/route_detail_sheet.dart';
import 'widgets/search_filter_chips.dart';
import 'widgets/search_result_item.dart';

/// Search & Tamil Nadu Transit Routes exploration screen.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final showRoutes = searchState.selectedCategory == SearchCategory.all ||
        searchState.selectedCategory == SearchCategory.busLines;

    final showStops = searchState.selectedCategory == SearchCategory.all ||
        searchState.selectedCategory == SearchCategory.stops;

    final hasNoResults = (showRoutes && searchState.filteredRoutes.isEmpty) &&
        (showStops && searchState.filteredStops.isEmpty);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Tamil Nadu Routes & Stops'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: AppTextField.search(
                controller: _searchController,
                hintText: 'Search Villupuram, Cuddalore, Puducherry...',
                onChanged: (val) => ref.read(searchProvider.notifier).setQuery(val),
                onClear: () {
                  _searchController.clear();
                  ref.read(searchProvider.notifier).clearQuery();
                },
              ),
            ),

            // Category Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: SearchFilterChips(
                selectedCategory: searchState.selectedCategory,
                onSelected: (cat) => ref.read(searchProvider.notifier).setCategory(cat),
              ),
            ),
            UIHelpers.vSpace8,

            // Quick suggestion tags if query is empty
            if (searchState.query.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        'Popular: ',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                        ),
                      ),
                      ...['Villupuram', 'Cuddalore', 'Puducherry', 'Panruti', 'Chidambaram', 'Neyveli']
                          .map((town) => Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: ActionChip(
                                  label: Text(town),
                                  labelStyle: AppTextStyles.labelSmall.copyWith(
                                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                    fontSize: 11,
                                  ),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () {
                                    _searchController.text = town;
                                    ref.read(searchProvider.notifier).setQuery(town);
                                  },
                                ),
                              )),
                    ],
                  ),
                ),
              ),

            // Search Results List
            Expanded(
              child: hasNoResults
                  ? AppEmptyState(
                      title: 'No Transit Matches Found',
                      message: 'Try searching for Villupuram, Cuddalore, Puducherry, Panruti, or Chidambaram.',
                      icon: Icons.search_off_rounded,
                      actionText: 'Clear Search',
                      onAction: () {
                        _searchController.clear();
                        ref.read(searchProvider.notifier).clearQuery();
                      },
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      children: [
                        // Routes Section
                        if (showRoutes && searchState.filteredRoutes.isNotEmpty) ...[
                          Text(
                            'Bus Routes (${searchState.filteredRoutes.length})',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          UIHelpers.vSpace12,
                          ...searchState.filteredRoutes.map((route) {
                            return RouteSearchResultItem(
                              route: route,
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => RouteDetailSheet(route: route),
                                );
                              },
                            );
                          }),
                          UIHelpers.vSpace16,
                        ],

                        // Stops Section
                        if (showStops && searchState.filteredStops.isNotEmpty) ...[
                          Text(
                            'Bus Stands & Stops (${searchState.filteredStops.length})',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          UIHelpers.vSpace12,
                          ...searchState.filteredStops.map((stop) {
                            return StopSearchResultItem(
                              stop: stop,
                              onTap: () {
                                UIHelpers.showSnackBar(
                                  context,
                                  message: '${stop.name} (Passing: ${stop.passingRouteNumbers.join(', ')})',
                                  icon: Icons.pin_drop_rounded,
                                );
                              },
                            );
                          }),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
