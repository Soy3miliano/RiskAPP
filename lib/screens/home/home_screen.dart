import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riskapp/models/report.dart';
import 'package:riskapp/state/reports_store.dart';
import 'package:riskapp/utils/constans/app_colors.dart';
import 'package:riskapp/widgets/report_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 0 = All, 1 = Pending, 2 = Resolved
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    // Rebuilds automatically when the shared store changes.
    final store = ReportsScope.of(context);
    final reports = store.reports;

    final visible = reports.where((r) {
      if (_filter == 1) return !r.isResolved;
      if (_filter == 2) return r.isResolved;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hi, Alex',
                style: TextStyle(color: AppColors.textMuted, fontSize: 16),
              ),
              const Text(
                'My reports',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: AppColors.fontWeightMedium,
                ),
              ),
              const SizedBox(height: 16),

              // Filtros
              Row(
                children: [
                  _filterTab('All', reports.length, 0),
                  _filterTab('Pending', store.pendingCount, 1),
                  _filterTab('Resolved', store.resolvedCount, 2),
                ],
              ),
              const SizedBox(height: 16),

              // Lista de reportes
              Expanded(
                child: ListView.separated(
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final Report report = visible[i];
                    return ReportCard(
                      report: report,
                      onTap: () => context.push('/detail/${report.id}'),
                      onToggleStatus: () => store.toggleStatus(report.id),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Botón inferior
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () => context.push('/report'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.backgroundColor,
                    side: const BorderSide(color: AppColors.backgroundColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Report an incident',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterTab(String label, int count, int index) {
    final selected = _filter == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _filter = index),
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: selected
                  ? AppColors.backgroundColor
                  : AppColors.borderColor,
            ),
          ),
          child: Text(
            '$label  $count',
            style: TextStyle(
              color: selected ? AppColors.backgroundColor : Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
