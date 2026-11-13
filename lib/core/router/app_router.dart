import 'package:go_router/go_router.dart';
import 'package:riskapp/screens/detail/report_detail_screen.dart';
import 'package:riskapp/screens/reports/report_screen.dart';

import '../../screens/home/home_screen.dart';

/// Builds the app router. A new instance is created per app so that each
/// widget test starts on the Home screen.
GoRouter createAppRouter() => GoRouter(
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
    GoRoute(
      path: '/detail/:id',
      name: 'detail',
      builder: (context, state) => ReportDetailScreen(
        reportId: int.tryParse(state.pathParameters['id'] ?? '') ?? -1,
      ),
    ),
  ],
);
