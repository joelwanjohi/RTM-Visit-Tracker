import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtm_visit_tracker/features/activities/domain/entities/activity.dart';
import 'package:rtm_visit_tracker/features/activities/presentation/bloc/activity_bloc.dart';
import 'package:rtm_visit_tracker/features/customers/domain/entities/customer.dart';
import 'package:rtm_visit_tracker/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:rtm_visit_tracker/features/visits/domain/entities/visit.dart';
import 'package:rtm_visit_tracker/features/visits/presentation/bloc/visit_bloc.dart';

class VisitDetailsScreen extends StatelessWidget {
  final Visit visit;

  const VisitDetailsScreen({super.key, required this.visit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        centerTitle: true,
        title: Text(
          'Visit Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Visit',
            onPressed: () => Navigator.pushNamed(context, '/visit_form', arguments: visit),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Visit',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Delete Visit'),
                    ],
                  ),
                  content: const Text('Are you sure you want to delete this visit? This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: TextStyle(color: colorScheme.secondary)),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        context.read<VisitBloc>().add(DeleteVisitEvent(visit.id));
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, customerState) {
          final customer = customerState.customers?.firstWhere(
              (c) => c.id == visit.customerId,
              orElse: () => Customer(id: 0, name: 'Unknown', createdAt: DateTime.now()),
            );
            
          return BlocBuilder<ActivityBloc, ActivityState>(
            builder: (context, activityState) {
              final activities = activityState.activities ?? [];
              final visitDate = DateFormat.yMd().add_jm().format(visit.visitDate);
              final isRecent = DateTime.now().difference(visit.visitDate).inDays < 7;
              
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                          child: Card(
                            elevation: 8,
                            shadowColor: colorScheme.primary.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: colorScheme.primaryContainer,
                                        foregroundColor: colorScheme.onPrimaryContainer,
                                        radius: 24,
                                        child: Text(
                                          customer?.name.substring(0, 1).toUpperCase() ?? 'U',
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              customer?.name ?? 'Unknown',
                                              style: TextStyle(
                                                fontSize: 20, 
                                                fontWeight: FontWeight.bold,
                                                color: colorScheme.onSurface,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today_outlined, 
                                                  size: 14, 
                                                  color: colorScheme.primary,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  visitDate,
                                                  style: TextStyle(
                                                    color: colorScheme.onSurfaceVariant,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isRecent)
                                        Chip(
                                          label: Text('Recent'),
                                          backgroundColor: colorScheme.secondaryContainer,
                                          labelStyle: TextStyle(
                                            color: colorScheme.onSecondaryContainer,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                          padding: EdgeInsets.zero,
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle(context, 'Visit Information'),
                          SizedBox(height: 8),
                          _buildInfoCard(
                            context,
                            [
                              _buildInfoRow(context, 'Status', visit.status, Icons.flag_outlined),
                              _buildInfoRow(context, 'Location', visit.location, Icons.location_on_outlined),
                            ],
                          ),
                          
                          SizedBox(height: 24),
                          _buildSectionTitle(context, 'Notes'),
                          SizedBox(height: 8),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.description_outlined,
                                    color: colorScheme.primary,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      visit.notes.isNotEmpty ? visit.notes : 'No notes provided',
                                      style: TextStyle(
                                        color: visit.notes.isNotEmpty 
                                            ? colorScheme.onSurface 
                                            : colorScheme.onSurfaceVariant,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 24),
                          _buildSectionTitle(context, 'Activities Completed'),
                          SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (visit.activitiesDone.isEmpty) {
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No activities recorded for this visit',
                                style: TextStyle(color: colorScheme.onSurfaceVariant),
                              ),
                            ),
                          );
                        }
                        
                        if (index >= visit.activitiesDone.length) return null;
                        
                        final activityId = visit.activitiesDone[index];
                        final activity = activities.firstWhere(
                          (a) => a.id.toString() == activityId,
                          orElse: () => Activity(id: 0, description: 'Unknown', createdAt: DateTime.now()),
                        );
                        
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: colorScheme.tertiaryContainer,
                              foregroundColor: colorScheme.onTertiaryContainer,
                              child: Text('${index + 1}'),
                            ),
                            title: Text(
                              activity.description,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  SliverToBoxAdapter(
                    child: SizedBox(height: 24),
                  ),
                ],
              );
            },
          );
        },
      ),

    );
  }
  
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: colorScheme.primary,
          ),
          SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}