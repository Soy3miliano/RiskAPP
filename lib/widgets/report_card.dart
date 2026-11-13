import 'package:flutter/material.dart';
import 'package:riskapp/models/report.dart';
import 'package:riskapp/utils/constans/app_colors.dart';
import 'package:riskapp/widgets/status_chip.dart';

/// Card shown in the Home list for a single report.
class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    required this.report,
    required this.onTap,
    required this.onToggleStatus,
  });

  final Report report;
  final VoidCallback onTap;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      report.category.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.backgroundColor,
                        fontSize: 12,
                        letterSpacing: 1.2,
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
                    onPressed: onToggleStatus,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.backgroundColor,
                    ),
                    child: Text(
                      report.isResolved ? 'Reopen' : 'Mark resolved',
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
        ),
      ),
    );
  }
}
