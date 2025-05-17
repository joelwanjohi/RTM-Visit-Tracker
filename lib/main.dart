import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rtm_visit_tracker/core/di/injection.dart';
import 'package:rtm_visit_tracker/core/theme/app_theme.dart';
import 'package:rtm_visit_tracker/features/activities/data/models/activity_model.dart';
import 'package:rtm_visit_tracker/features/customers/data/models/customer_model.dart';
import 'package:rtm_visit_tracker/features/statistics/presentation/screens/statistics_screen.dart';
import 'package:rtm_visit_tracker/features/visits/data/models/visit_model.dart';
import 'package:rtm_visit_tracker/features/visits/domain/entities/visit.dart';
import 'package:rtm_visit_tracker/features/visits/presentation/bloc/visit_bloc.dart';
import 'package:rtm_visit_tracker/features/customers/presentation/bloc/customer_bloc.dart';
import 'package:rtm_visit_tracker/features/activities/presentation/bloc/activity_bloc.dart';
import 'package:rtm_visit_tracker/features/statistics/presentation/bloc/statistics_bloc.dart';
import 'package:rtm_visit_tracker/features/visits/presentation/screens/visit_details_screen.dart';
import 'package:rtm_visit_tracker/features/visits/presentation/screens/visit_form_screen.dart';

import 'package:rtm_visit_tracker/features/visits/presentation/screens/visit_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  Hive.registerAdapter(VisitModelAdapter());
  Hive.registerAdapter(CustomerModelAdapter());
  Hive.registerAdapter(ActivityModelAdapter());
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const VisitListScreen(),
        ),
        GoRoute(
          path: '/visit_form',
          builder: (context, state) {
            final visit = state.extra as Visit?;
            return VisitFormScreen(visit: visit);
          },
        ),
        GoRoute(
          path: '/visit_details',
          builder: (context, state) {
            final visit = state.extra as Visit;
            return VisitDetailsScreen(visit: visit);
          },
        ),
        GoRoute(
          path: '/statistics',
          builder: (context, state) => const StatisticsScreen(),
        ),
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<VisitBloc>()),
        BlocProvider(create: (context) => sl<CustomerBloc>()),
        BlocProvider(create: (context) => sl<ActivityBloc>()),
        BlocProvider(create: (context) => sl<StatisticsBloc>()),
      ],
      child: MaterialApp.router(
        title: 'RTM Visit Tracker',
        theme: AppTheme.lightTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}