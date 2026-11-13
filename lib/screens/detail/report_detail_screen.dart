import 'package:flutter/material.dart';
import 'package:riskapp/models/report.dart';
import 'package:riskapp/state/reports_store.dart';
import 'package:riskapp/utils/constans/app_colors.dart';
import 'package:riskapp/utils/constans/app_fonts.dart';
import 'package:riskapp/widgets/app_back_button.dart';
import 'package:riskapp/widgets/status_chip.dart';

/// Shows every field of a single report and lets the user change its status.
class ReportDetailScreen extends StatelessWidget {
  const ReportDetailScreen({super.key, required this.reportId});

  final int reportId;

  @override
  Widget build(BuildContext context) {
    // Reads from the shared store, so a status change is visible here and on
    // the Home screen at the same time.
    final store = ReportsScope.of(context);
    final report = store.byId(reportId);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const AppBackButton(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Report details',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppFonts.primary(
                        fontSize: 26,
                        fontWeight: AppColors.fontWeightMedium,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (report == null)
                Expanded(
                  child: Center(
                    child: Text(
                      'Report not found',
                      style: AppFonts.primary(
                        fontSize: 17,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                )
              else ...[
                Expanded(child: SingleChildScrollView(child: _body(report))),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => store.toggleStatus(report.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.backgroundColor,
                      side: const BorderSide(color: AppColors.backgroundColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      report.isResolved ? 'Reopen' : 'Mark resolved',
                      style: AppFonts.primary(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(Report report) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                report.category.toUpperCase(),
                style: AppFonts.label(
                  fontSize: 12,
                  color: AppColors.backgroundColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            StatusChip(status: report.status),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          report.title,
          style: AppFonts.primary(
            fontSize: 24,
            fontWeight: AppColors.fontWeightMedium,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        _infoRow(Icons.place_outlined, 'Location', report.location),
        const SizedBox(height: 12),
        _infoRow(Icons.calendar_today_outlined, 'Date', report.date),
        const SizedBox(height: 24),
        _label('Description'),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Text(
            report.description,
            style: AppFonts.primary(fontSize: 17, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.backgroundColor, size: 22),
          const SizedBox(width: 12),
          Text(
            label,
            style: AppFonts.primary(fontSize: 15, color: AppColors.textMuted),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppFonts.primary(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: AppFonts.primary(fontSize: 15, color: AppColors.textMuted),
      ),
    );
  }
}
