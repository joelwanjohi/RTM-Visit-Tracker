import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rtm_visit_tracker/core/theme/app_theme.dart';
import 'package:rtm_visit_tracker/features/statistics/presentation/bloc/statistics_bloc.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    context.read<StatisticsBloc>().add(FetchStatistics());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visit Statistics'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: BlocBuilder<StatisticsBloc, StatisticsState>(
        builder: (context, state) {
          if (state is StatisticsLoading) {
            return Center(child: CircularProgressIndicator(color: colorScheme.primary));
          } else if (state is StatisticsLoaded) {
            final stats = state.statistics;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatCard(context, 'Total Visits', stats.totalVisits.toString(), colorScheme.primary),
                  const SizedBox(height: 16),
                  _buildStatCard(context, 'Completed Visits', stats.completedVisits.toString(), colorScheme.secondary),
                  const SizedBox(height: 16),
                  _buildStatCard(context, 'Pending Visits', stats.pendingVisits.toString(), Colors.amber),
                  const SizedBox(height: 16),
                  _buildStatCard(context, 'Cancelled Visits', stats.cancelledVisits.toString(), Colors.red.shade400),
                ],
              ),
            );
          } else if (state is StatisticsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<StatisticsBloc>().add(FetchStatistics()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'No statistics available',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try refreshing to load statistics',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<StatisticsBloc>().add(FetchStatistics()),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title, 
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              )
            ),
            Text(
              value, 
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.w600,
                color: color
              )
            ),
          ],
        ),
      ),
    );
  }
}