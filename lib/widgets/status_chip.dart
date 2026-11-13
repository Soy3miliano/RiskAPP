import 'package:flutter/material.dart';
import 'package:riskapp/models/report.dart';
import 'package:riskapp/utils/constans/app_colors.dart';

/// Small rounded label showing whether a report is pending or resolved.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final ReportStatus status;

  @override
  Widget build(BuildContext context) {
    final resolved = status == ReportStatus.resolved;
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
        status.label,
        style: TextStyle(
          color: resolved ? Colors.white : AppColors.backgroundColor,
          fontSize: 13,
        ),
      ),
    );
  }
}
