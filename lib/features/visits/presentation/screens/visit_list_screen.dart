// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:rtm_visit_tracker/features/activities/presentation/bloc/activity_bloc.dart';
// import 'package:rtm_visit_tracker/features/customers/presentation/bloc/customer_bloc.dart';
// import 'package:rtm_visit_tracker/features/visits/presentation/bloc/visit_bloc.dart';
// import 'package:rtm_visit_tracker/features/visits/presentation/widgets/visit_card.dart';

// class VisitListScreen extends StatefulWidget {
//   const VisitListScreen({super.key});

//   @override
//   VisitListScreenState createState() => VisitListScreenState();
// }

// class VisitListScreenState extends State<VisitListScreen> {
//   final RefreshController _refreshController = RefreshController(initialRefresh: false);
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
    
//     // Dispatch BLoC events on screen initialization
//     context.read<VisitBloc>().add(FetchVisits());
//     context.read<CustomerBloc>().add(FetchCustomers());
//     context.read<ActivityBloc>().add(FetchActivities());
//   }

//   @override
//   void dispose() {
//     _refreshController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _onRefresh() async {
//     context.read<VisitBloc>().add(FetchVisits());
//     context.read<CustomerBloc>().add(FetchCustomers());
//     context.read<ActivityBloc>().add(FetchActivities());
//     _refreshController.refreshCompleted();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colorScheme = theme.colorScheme;
    
//     return Scaffold(
//       backgroundColor: colorScheme.background,
//       body: NestedScrollView(
//         headerSliverBuilder: (context, innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               expandedHeight: 120.0,
//               floating: true,
//               pinned: true,
//               elevation: 0,
//               backgroundColor: colorScheme.primary,
//               foregroundColor: colorScheme.onPrimary,
//               flexibleSpace: FlexibleSpaceBar(
//                 titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
//                 title: Text(
//                   'Visits',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//                 background: Stack(
//                   children: [
//                     // Background gradient
//                     Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             colorScheme.primary,
//                             colorScheme.primary.withOpacity(0.8),
//                           ],
//                         ),
//                       ),
//                     ),
                    
//                     // Decorative circles
//                     Positioned(
//                       top: -20,
//                       right: -20,
//                       child: Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white.withOpacity(0.1),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: -40,
//                       right: 40,
//                       child: Container(
//                         width: 80,
//                         height: 80,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white.withOpacity(0.1),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
// actions: [
//   BlocBuilder<VisitBloc, VisitState>(
//     builder: (context, state) {
//       int count = 0;
//       if (state is VisitLoaded) {
//         count = state.visits.length;
//       }

//       return Stack(
//         children: [
//           IconButton(
//             icon: Icon(Icons.bar_chart),
//             tooltip: 'Statistics',
//             onPressed: () => context.push('/statistics'),
//           ),
//           if (count > 0)
//             Positioned(
//               right: 8,
//               top: 8,
//               child: Container(
//                 padding: EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   shape: BoxShape.circle,
//                 ),
//                 constraints: BoxConstraints(
//                   minWidth: 20,
//                   minHeight: 20,
//                 ),
//                 child: Text(
//                   count.toString(),
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//         ],
//       );
//     },
//   ),
// ],

//             ),
            
//             // Search box
//             SliverToBoxAdapter(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: colorScheme.primary,
//                   borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(30),
//                     bottomRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 8,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: _searchController,
//                       decoration: InputDecoration(
//                         hintText: 'Search visits...',
//                         prefixIcon: Icon(Icons.search, color: colorScheme.primary),
//                         suffixIcon: IconButton(
//                           icon: Icon(Icons.clear, color: Colors.grey),
//                           onPressed: () => _searchController.clear(),
//                         ),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.symmetric(vertical: 15),
//                       ),
//                       onChanged: (value) {
//                         // Implement search logic
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
            
//             // Label showing visits
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
//                 child: Row(
//                   children: [
//                     Text(
//                       'All Visits',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: colorScheme.onBackground,
//                       ),
//                     ),
//                     Spacer(),
//                     BlocBuilder<VisitBloc, VisitState>(
//                       builder: (context, state) {
//                         if (state is VisitLoaded) {
//                           return Text(
//                             '${state.visits.length} ${state.visits.length == 1 ? 'visit' : 'visits'}',
//                             style: TextStyle(
//                               color: colorScheme.onSurfaceVariant,
//                             ),
//                           );
//                         }
//                         return SizedBox();
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ];
//         },
//         body: SmartRefresher(
//           controller: _refreshController,
//           onRefresh: _onRefresh,
//           header: WaterDropHeader(
//             waterDropColor: colorScheme.primary,
//             complete: Icon(
//               Icons.check,
//               color: colorScheme.primary,
//             ),
//           ),
//           child: BlocBuilder<VisitBloc, VisitState>(
//             builder: (context, state) {
//               if (state is VisitLoading) {
//                 return _buildLoadingList();
//               } else if (state is VisitLoaded) {
//                 if (state.visits.isEmpty) {
//                   return _buildEmptyState();
//                 }
                
//                 return ListView.builder(
//                   padding: EdgeInsets.fromLTRB(16, 0, 16, 80),
//                   itemCount: state.visits.length,
//                   itemBuilder: (context, index) => VisitCard(visit: state.visits[index]),
//                 );
//               } else if (state is VisitError) {
//                 return _buildErrorState(state.message);
//               }
//               return _buildEmptyState();
//             },
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => context.push('/visit_form'),
//         backgroundColor: colorScheme.secondary,
//         foregroundColor: colorScheme.onSecondary,
//         elevation: 4,
//         child: Icon(Icons.add),
//       ),
//     );
//   }
  
//   Widget _buildLoadingList() {
//     return ListView.builder(
//       padding: EdgeInsets.all(16),
//       itemCount: 5,
//       itemBuilder: (context, index) => Card(
//         margin: EdgeInsets.only(bottom: 12),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//         ),
//         elevation: 2,
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   SizedBox(width: 12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: 120,
//                         height: 16,
//                         color: Colors.grey.shade300,
//                       ),
//                       SizedBox(height: 4),
//                       Container(
//                         width: 80,
//                         height: 12,
//                         color: Colors.grey.shade300,
//                       ),
//                     ],
//                   ),
//                   Spacer(),
//                   Container(
//                     width: 70,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade300,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               Container(
//                 width: double.infinity,
//                 height: 12,
//                 color: Colors.grey.shade300,
//               ),
//               SizedBox(height: 8),
//               Container(
//                 width: 200,
//                 height: 12,
//                 color: Colors.grey.shade300,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.calendar_today_outlined,
//             size: 80,
//             color: Colors.grey.shade400,
//           ),
//           SizedBox(height: 16),
//           Text(
//             'No visits found',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             'Tap the + button to create a new visit',
//             style: TextStyle(
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildErrorState(String message) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.error_outline,
//             size: 80,
//             color: Colors.red.shade300,
//           ),
//           SizedBox(height: 16),
//           Text(
//             'Oops! Something went wrong',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           SizedBox(height: 8),
//           Text(
//             message,
//             style: TextStyle(
//               color: Colors.grey.shade600,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 16),
//           ElevatedButton.icon(
//             onPressed: _onRefresh,
//             icon: Icon(Icons.refresh),
//             label: Text('Try Again'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Theme.of(context).colorScheme.primary,
//               foregroundColor: Theme.of(context).colorScheme.onPrimary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }