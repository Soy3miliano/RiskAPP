import 'package:flutter/widgets.dart';
import 'package:riskapp/data/sample_reports.dart';
import 'package:riskapp/models/report.dart';
import 'package:riskapp/utils/date_format.dart';

/// In-memory state shared by every screen. There is no database or
/// persistent storage: the list starts with the sample data and changes are
/// lost when the app is closed.
class ReportsStore extends ChangeNotifier {
  ReportsStore({List<Report> initialReports = sampleReports})
    : _reports = List.of(initialReports),
      _nextId =
          initialReports.fold<int>(0, (max, r) => r.id > max ? r.id : max) + 1;

  final List<Report> _reports;
  int _nextId;

  /// All reports, newest first.
  List<Report> get reports => List.unmodifiable(_reports);

  int get pendingCount => _reports.where((r) => !r.isResolved).length;
  int get resolvedCount => _reports.where((r) => r.isResolved).length;

  Report? byId(int id) {
    for (final report in _reports) {
      if (report.id == id) return report;
    }
    return null;
  }

  /// Creates a new pending report dated today and puts it at the top.
  Report add({
    required String category,
    required String title,
    required String location,
    required String description,
    DateTime? date,
  }) {
    final report = Report(
      id: _nextId++,
      category: category,
      title: title,
      location: location,
      description: description,
      date: formatShortDate(date ?? DateTime.now()),
    );
    _reports.insert(0, report);
    notifyListeners();
    return report;
  }

  /// Switches a report between pending and resolved.
  void toggleStatus(int id) {
    final index = _reports.indexWhere((r) => r.id == id);
    if (index == -1) return;
    final report = _reports[index];
    _reports[index] = report.copyWith(
      status: report.isResolved ? ReportStatus.pending : ReportStatus.resolved,
    );
    notifyListeners();
  }
}

/// Makes a [ReportsStore] available to the widget tree. Widgets that call
/// [ReportsScope.of] rebuild whenever the store notifies a change.
class ReportsScope extends InheritedNotifier<ReportsStore> {
  const ReportsScope({
    super.key,
    required ReportsStore store,
    required super.child,
  }) : super(notifier: store);

  static ReportsStore of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ReportsScope>();
    assert(scope != null, 'No ReportsScope found in context');
    return scope!.notifier!;
  }

  /// Returns the store without subscribing to changes. Use it in callbacks
  /// such as button handlers.
  static ReportsStore read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<ReportsScope>();
    assert(scope != null, 'No ReportsScope found in context');
    return scope!.notifier!;
  }
}
