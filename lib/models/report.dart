/// Status of an incident report.
enum ReportStatus {
  pending('Pending'),
  resolved('Resolved');

  const ReportStatus(this.label);

  /// Text shown to the user.
  final String label;
}

/// An incident reported by a user.
class Report {
  const Report({
    required this.id,
    required this.category,
    required this.title,
    required this.location,
    required this.date,
    required this.description,
    this.status = ReportStatus.pending,
  });

  final int id;
  final String category;
  final String title;
  final String location;
  final String date;
  final String description;
  final ReportStatus status;

  bool get isResolved => status == ReportStatus.resolved;

  Report copyWith({ReportStatus? status}) {
    return Report(
      id: id,
      category: category,
      title: title,
      location: location,
      date: date,
      description: description,
      status: status ?? this.status,
    );
  }
}
