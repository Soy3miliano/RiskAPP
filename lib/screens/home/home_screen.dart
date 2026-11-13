import 'package:flutter/material.dart';
import 'package:riskapp/utils/constans/app_colors.dart';

class Report {
  Report({
    required this.category,
    required this.title,
    required this.location,
    required this.date,
    this.resolved = false,
  });

  final String category;
  final String title;
  final String location;
  final String date;
  bool resolved;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 0 = All, 1 = Pending, 2 = Resolved
  int _filter = 0;

  // Datos de prueba
  final List<Report> _reports = [
    Report(
      category: 'ELECTRICITY',
      title: 'Projector will not turn on',
      location: 'Building A, room 112',
      date: 'Nov 10',
    ),
    Report(
      category: 'INTERNET AND NETWORKS',
      title: 'Wi-Fi drops every few minutes',
      location: 'Library, 2nd floor',
      date: 'Nov 9',
    ),
    Report(
      category: 'MAINTENANCE',
      title: 'Leaking tap in restroom',
      location: 'Science building, ground floor',
      date: 'Nov 4',
      resolved: true,
    ),
    Report(
      category: 'FURNITURE',
      title: 'Broken chair in lecture hall',
      location: 'Hall 3, back row',
      date: 'Oct 28',
      resolved: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pending = _reports.where((r) => !r.resolved).length;
    final resolved = _reports.where((r) => r.resolved).length;

    final visible = _reports.where((r) {
      if (_filter == 1) return !r.resolved;
      if (_filter == 2) return r.resolved;
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
                  _filterTab('All', _reports.length, 0),
                  _filterTab('Pending', pending, 1),
                  _filterTab('Resolved', resolved, 2),
                ],
              ),
              const SizedBox(height: 16),

              // Lista de reportes
              Expanded(
                child: ListView.separated(
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _reportCard(visible[i]),
                ),
              ),
              const SizedBox(height: 16),

              // Botón inferior
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {},
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

  Widget _reportCard(Report report) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                report.category,
                style: const TextStyle(
                  color: AppColors.backgroundColor,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              _statusChip(report.resolved),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            report.title,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${report.location} · ${report.date}',
                  style: const TextStyle(color: AppColors.textMuted),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () =>
                    setState(() => report.resolved = !report.resolved),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.backgroundColor,
                ),
                child: Text(
                  report.resolved ? 'Reopen' : 'Mark resolved',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: AppColors.fontWeightMedium,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(bool resolved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: resolved ? AppColors.borderColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: resolved ? AppColors.borderColor : AppColors.backgroundColor,
        ),
      ),
      child: Text(
        resolved ? 'Resolved' : 'Pending',
        style: TextStyle(
          color: resolved ? Colors.white : AppColors.backgroundColor,
          fontSize: 13,
        ),
      ),
    );
  }
}
