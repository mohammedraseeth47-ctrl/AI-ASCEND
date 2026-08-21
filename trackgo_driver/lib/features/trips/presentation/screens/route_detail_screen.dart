import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackgo_driver/core/theme/app_colors.dart';
import 'package:trackgo_driver/core/theme/app_radius.dart';
import 'package:trackgo_driver/core/theme/app_spacing.dart';
import 'package:trackgo_driver/core/theme/app_typography.dart';
import 'package:trackgo_driver/core/widgets/error_state_view.dart';
import 'package:trackgo_driver/core/widgets/loading_state_view.dart';
import 'package:trackgo_driver/core/widgets/section_header.dart';
import 'package:trackgo_driver/core/widgets/status_badge.dart';
import 'package:trackgo_driver/core/widgets/trackgo_card.dart';
import 'package:trackgo_driver/features/trips/domain/entities/route.dart';
import 'package:trackgo_driver/features/trips/domain/entities/trip_stop.dart';
import 'package:trackgo_driver/features/trips/domain/repositories/route_repository.dart';

class RouteDetailScreen extends StatefulWidget {
  final String? routeId;

  const RouteDetailScreen({super.key, this.routeId});

  @override
  State<RouteDetailScreen> createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen> {
  TransitRoute? _route;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = context.read<RouteRepository>();
      final route = widget.routeId != null
          ? await repo.getRouteById(widget.routeId!)
          : await repo.getAssignedRoute('DRV-1024');

      setState(() {
        _route = route;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Transit Route Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingStateView(
        message: 'Loading transit route & stops...',
      );
    }

    if (_errorMessage != null || _route == null) {
      return ErrorStateView(
        message: _errorMessage ?? 'Route details could not be found.',
        onRetry: _loadRoute,
      );
    }

    final route = _route!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Route Overview Card
          _buildRouteOverviewCard(route),
          const SizedBox(height: AppSpacing.lg),

          // 2. Route Metrics Row
          _buildRouteMetrics(route),
          const SizedBox(height: AppSpacing.lg),

          // 3. Ordered Stops Itinerary Section
          SectionHeader(
            title: 'Ordered Stops Timeline (${route.stops.length})',
          ),
          _buildStopsTimeline(route.stops),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildRouteOverviewCard(TransitRoute route) {
    return TrackGoCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      backgroundColor: const Color(0xFF0F172A), // Slate Navy Header
      borderSide: BorderSide.none,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  borderRadius: AppRadius.roundedSm,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  route.routeNumber,
                  style: AppTypography.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              StatusBadge(
                label: route.status.displayName,
                type: StatusBadgeType.available,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            route.routeName,
            style: AppTypography.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Corridor: ${route.operatingRegion}',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textMutedDark,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(color: Color(0xFF334155)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(
                Icons.alt_route_rounded,
                size: 16,
                color: AppColors.primaryLight,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  'Via: ${route.viaMajorStops}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryDark,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteMetrics(TransitRoute route) {
    return Row(
      children: [
        Expanded(
          child: TrackGoCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.straighten_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 4),
                Text(
                  '${route.distanceKm} km',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  'Total Distance',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMutedLight,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: TrackGoCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.timer_outlined,
                  size: 18,
                  color: AppColors.success,
                ),
                const SizedBox(height: 4),
                Text(
                  '~${route.estimatedDurationMinutes} mins',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  'Est. Run Time',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMutedLight,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: TrackGoCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: AppColors.warning,
                ),
                const SizedBox(height: 4),
                Text(
                  '${route.totalStopsCount} Stops',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  'Planned Sequence',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMutedLight,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStopsTimeline(List<TripStop> stops) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: stops.length,
      itemBuilder: (context, index) {
        final stop = stops[index];
        final isFirst = index == 0;
        final isLast = index == stops.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Timeline Node Line
              SizedBox(
                width: 36,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isFirst
                            ? Colors.transparent
                            : AppColors.cardBorderLight,
                      ),
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: stop.isTerminal
                            ? AppColors.primary
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: stop.isTerminal
                              ? AppColors.primaryDark
                              : AppColors.cardBorderLight,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${stop.sequenceNumber}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: stop.isTerminal
                                ? Colors.white
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isLast
                            ? Colors.transparent
                            : AppColors.cardBorderLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),

              // Stop Detail Card
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.xs + 2,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.roundedMd,
                      border: Border.all(
                        color: stop.isTerminal
                            ? AppColors.primaryContainer
                            : AppColors.cardBorderLight,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      stop.stopName,
                                      style: AppTypography.titleSmall.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimaryLight,
                                      ),
                                    ),
                                  ),
                                  if (stop.isTerminal) ...[
                                    const SizedBox(width: AppSpacing.xs),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primaryContainer,
                                        borderRadius: AppRadius.roundedXs,
                                      ),
                                      child: Text(
                                        'Terminal',
                                        style: AppTypography.labelSmall
                                            .copyWith(
                                              fontSize: 9,
                                              color: AppColors.primaryDark,
                                            ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              if (stop.landmarks != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  stop.landmarks!,
                                  style: AppTypography.bodySmall.copyWith(
                                    color: AppColors.textMutedLight,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          stop.scheduledTime,
                          style: AppTypography.labelMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
