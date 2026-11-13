import 'package:go_router/go_router.dart';
import 'package:riskapp/screens/reports/report_screen.dart';

import '../../screens/home/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/report',
      name: 'report',
      builder: (context, state) => const ReportScreen(),
    ),
  ],
);
