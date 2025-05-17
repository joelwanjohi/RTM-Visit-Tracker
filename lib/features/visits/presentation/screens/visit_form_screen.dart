import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rtm_visit_tracker/core/theme/app_theme.dart';
import 'package:rtm_visit_tracker/features/activities/presentation/bloc/activity_bloc.dart';
import 'package:rtm_visit_tracker/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:rtm_visit_tracker/features/visits/domain/entities/visit.dart';
import 'package:rtm_visit_tracker/features/visits/presentation/bloc/visit_bloc.dart';

class VisitFormScreen extends StatefulWidget {
  final Visit? visit;

  const VisitFormScreen({super.key, this.visit});

  @override
  State<VisitFormScreen> createState() => _VisitFormScreenState();
}

class _VisitFormScreenState extends State<VisitFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _locationController;
  late TextEditingController _notesController;
  late DateTime _visitDate;
  late String _status;
  late int _customerId;
  late List<String> _selectedActivities;
  
  // Status options with corresponding colors and icons
  final Map<String, Map<String, dynamic>> _statusOptions = {
    'Pending': {
      'color': Colors.orange,
      'icon': Icons.pending_outlined,
    },
    'Completed': {
      'color': Colors.green,
      'icon': Icons.check_circle_outline,
    },
    'Cancelled': {
      'color': Colors.red,
      'icon': Icons.cancel_outlined,
    },
  };

  @override
  void initState() {
    super.initState();
    _locationController = TextEditingController(text: widget.visit?.location ?? '');
    _notesController = TextEditingController(text: widget.visit?.notes ?? '');
    _visitDate = widget.visit?.visitDate ?? DateTime.now();
    _status = widget.visit?.status ?? 'Pending';
    _customerId = widget.visit?.customerId ?? 0;
    _selectedActivities = widget.visit?.activitiesDone ?? [];
    context.read<CustomerBloc>().add(FetchCustomers());
    context.read<ActivityBloc>().add(FetchActivities());
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final visit = Visit(
        id: widget.visit?.id ?? DateTime.now().millisecondsSinceEpoch,
        customerId: _customerId,
        visitDate: _visitDate,
        status: _status,
        location: _locationController.text,
        notes: _notesController.text,
        activitiesDone: _selectedActivities,
        createdAt: widget.visit?.createdAt ?? DateTime.now(),
      );
      if (widget.visit == null) {
        context.read<VisitBloc>().add(AddVisitEvent(visit));
      } else {
        context.read<VisitBloc>().add(UpdateVisitEvent(visit));
      }
      Navigator.pop(context);
    }
  }

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
          widget.visit == null ? 'Add Visit' : 'Edit Visit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Curved header background
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          
          // Main form content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Customer selection card
                    Card(
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
                            _buildSectionTitle(context, 'Customer Information'),
                            SizedBox(height: 16),
                            BlocBuilder<CustomerBloc, CustomerState>(
                              builder: (context, state) {
                                final customers = state.customers ?? [];
                                return DropdownButtonFormField<int>(
                                  value: _customerId == 0 ? null : _customerId,
                                  decoration: InputDecoration(
                                    labelText: 'Select Customer',
                                    prefixIcon: Icon(
                                      Icons.person_outline,
                                      color: colorScheme.primary,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: colorScheme.primary),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: colorScheme.primary, width: 2),
                                    ),
                                    filled: true,
                                    fillColor: colorScheme.surface,
                                  ),
                                  items: customers.map((customer) {
                                    return DropdownMenuItem(
                                      value: customer.id,
                                      child: Text(customer.name),
                                    );
                                  }).toList(),
                                  onChanged: (value) => setState(() => _customerId = value!),
                                  validator: (value) => value == null ? 'Please select a customer' : null,
                                  icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
                                  isExpanded: true,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Visit details card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(context, 'Visit Details'),
                            SizedBox(height: 16),
                            
                            // Location field
                            TextFormField(
                              controller: _locationController,
                              decoration: InputDecoration(
                                labelText: 'Location',
                                prefixIcon: Icon(
                                  Icons.location_on_outlined,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                                ),
                                filled: true,
                                fillColor: colorScheme.surface,
                              ),
                              validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
                            ),
                            
                            SizedBox(height: 16),
                            
                            // Notes field
                            TextFormField(
                              controller: _notesController,
                              decoration: InputDecoration(
                                labelText: 'Notes',
                                hintText: 'Add any additional details here...',
                                prefixIcon: Icon(
                                  Icons.description_outlined,
                                  color: colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                                ),
                                filled: true,
                                fillColor: colorScheme.surface,
                              ),
                              maxLines: 3,
                            ),
                            
                            SizedBox(height: 16),
                            
                            // Visit date picker
                            InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: _visitDate,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: colorScheme.primary,
                                          onPrimary: colorScheme.onPrimary,
                                          onSurface: colorScheme.onSurface,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (date != null) {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.fromDateTime(_visitDate),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: colorScheme.primary,
                                            onPrimary: colorScheme.onPrimary,
                                            onSurface: colorScheme.onSurface,
                                          ),
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (time != null) {
                                    setState(() {
                                      _visitDate = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        time.hour,
                                        time.minute,
                                      );
                                    });
                                  }
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: colorScheme.primary.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: colorScheme.surface,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: colorScheme.primary,
                                    ),
                                    SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Visit Date & Time',
                                          style: TextStyle(
                                            color: colorScheme.primary,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          DateFormat.yMd().add_jm().format(_visitDate),
                                          style: TextStyle(
                                            color: colorScheme.onSurface,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: colorScheme.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            SizedBox(height: 16),
                            
                            // Status selection
                            DropdownButtonFormField<String>(
                              value: _status,
                              decoration: InputDecoration(
                                labelText: 'Status',
                                prefixIcon: Icon(
                                  _statusOptions[_status]?['icon'] ?? Icons.help_outline,
                                  color: _statusOptions[_status]?['color'] ?? colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                                ),
                                filled: true,
                                fillColor: colorScheme.surface,
                              ),
                              items: _statusOptions.keys.map((status) {
                                return DropdownMenuItem(
                                  value: status,
                                  child: Row(
                                    children: [
                                      Icon(
                                        _statusOptions[status]!['icon'],
                                        color: _statusOptions[status]!['color'],
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(status),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) => setState(() => _status = value!),
                              icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Activities section
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(context, 'Activities'),
                            SizedBox(height: 16),
                            
                            BlocBuilder<ActivityBloc, ActivityState>(
                              builder: (context, state) {
                                final activities = state.activities ?? [];
                                if (activities.isEmpty) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.amber,
                                            size: 48,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'No activities available',
                                            style: TextStyle(
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                
                                return Column(
                                  children: [
                                    // Activities count indicator
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Selected:',
                                            style: TextStyle(
                                              color: colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: colorScheme.primaryContainer,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              '${_selectedActivities.length} / ${activities.length}',
                                              style: TextStyle(
                                                color: colorScheme.onPrimaryContainer,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                if (_selectedActivities.length == activities.length) {
                                                  _selectedActivities.clear();
                                                } else {
                                                  _selectedActivities = activities
                                                      .map((a) => a.id.toString())
                                                      .toList();
                                                }
                                              });
                                            },
                                            child: Text(
                                              _selectedActivities.length == activities.length
                                                  ? 'Clear All'
                                                  : 'Select All',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    // Divider
                                    Divider(height: 1),
                                    
                                    // Activity list
                                    ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: activities.length,
                                      separatorBuilder: (context, index) => Divider(height: 1),
                                      itemBuilder: (context, index) {
                                        final activity = activities[index];
                                        final isSelected = _selectedActivities.contains(activity.id.toString());
                                        
                                        return CheckboxListTile(
                                          title: Text(
                                            activity.description,
                                            style: TextStyle(
                                              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                                            ),
                                          ),
                                          value: isSelected,
                                          activeColor: colorScheme.primary,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                          dense: true,
                                          secondary: CircleAvatar(
                                            backgroundColor: isSelected
                                                ? colorScheme.tertiaryContainer
                                                : colorScheme.surfaceVariant,
                                            foregroundColor: isSelected
                                                ? colorScheme.onTertiaryContainer
                                                : colorScheme.onSurfaceVariant,
                                            radius: 14,
                                            child: Text('${index + 1}'),
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              if (value!) {
                                                _selectedActivities.add(activity.id.toString());
                                              } else {
                                                _selectedActivities.remove(activity.id.toString());
                                              }
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.secondary,
                          foregroundColor: colorScheme.onSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(widget.visit == null ? Icons.add : Icons.save),
                            SizedBox(width: 8),
                            Text(
                              widget.visit == null ? 'Add Visit' : 'Update Visit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
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
}