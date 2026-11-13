import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riskapp/main.dart';
import 'package:riskapp/models/report.dart';
import 'package:riskapp/state/reports_store.dart';
import 'package:riskapp/utils/date_format.dart';
import 'package:riskapp/widgets/app_back_button.dart';
import 'package:riskapp/widgets/report_card.dart';

/// Starts the real app (router + shared store) on a phone-sized screen.
Future<void> pumpApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const MyApp());
  await tester.pumpAndSettle();
}

void main() {
  // Tests must run offline: never download fonts, fall back to the default.
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('ReportsStore', () {
    test('starts with the sample data', () {
      final store = ReportsStore();
      expect(store.reports, hasLength(4));
      expect(store.pendingCount, 2);
      expect(store.resolvedCount, 2);
    });

    test('add creates a pending report with a new id at the top', () {
      final store = ReportsStore();
      final report = store.add(
        category: 'Cleaning',
        title: 'Spilled coffee',
        location: 'Cafeteria',
        description: 'Coffee on the floor near the entrance.',
        date: DateTime(2026, 11, 12),
      );
      expect(report.status, ReportStatus.pending);
      expect(report.date, 'Nov 12');
      expect(store.reports.first.id, report.id);
      expect(store.reports.where((r) => r.id == report.id), hasLength(1));
      expect(store.pendingCount, 3);
    });

    test('toggleStatus switches between pending and resolved', () {
      final store = ReportsStore();
      store.toggleStatus(1);
      expect(store.byId(1)!.status, ReportStatus.resolved);
      store.toggleStatus(1);
      expect(store.byId(1)!.status, ReportStatus.pending);
    });
  });

  testWidgets('Home shows the 4 sample reports', (tester) async {
    await pumpApp(tester);

    expect(find.text('My reports'), findsOneWidget);
    expect(find.byType(ReportCard), findsNWidgets(4));
    expect(find.text('All  4'), findsOneWidget);
    expect(find.text('Pending  2'), findsOneWidget);
    expect(find.text('Resolved  2'), findsOneWidget);
  });

  testWidgets('sending a valid form adds a Pending report to Home', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Report an incident'));
    await tester.pumpAndSettle();
    expect(find.text('New report'), findsOneWidget);

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Broken light in hallway');
    await tester.tap(find.text('Electricity'));
    await tester.enterText(fields.at(1), 'Building B, room 204');
    await tester.enterText(fields.at(2), 'The light flickers and went out.');
    await tester.pump();

    await tester.tap(find.text('Send report'));
    await tester.pumpAndSettle();

    // Back on Home with the new report at the top, as Pending.
    expect(find.text('My reports'), findsOneWidget);
    expect(find.text('All  5'), findsOneWidget);
    expect(find.text('Pending  3'), findsOneWidget);
    final newCard = find.byType(ReportCard).first;
    expect(
      find.descendant(
        of: newCard,
        matching: find.text('Broken light in hallway'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: newCard, matching: find.text('Pending')),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: newCard,
        matching: find.text(
          'Building B, room 204 · ${formatShortDate(DateTime.now())}',
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Send report stays disabled until all fields are filled', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.tap(find.text('Report an incident'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Only a title');
    await tester.pump();
    await tester.tap(find.text('Send report'));
    await tester.pumpAndSettle();

    expect(find.text('New report'), findsOneWidget);
    expect(
      find.text('1 of 4 fields completed. All fields are required.'),
      findsOneWidget,
    );
  });

  testWidgets('toggling status on Home updates the counters', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Mark resolved').first);
    await tester.pumpAndSettle();
    expect(find.text('Pending  1'), findsOneWidget);
    expect(find.text('Resolved  3'), findsOneWidget);

    await tester.tap(find.text('Reopen').first);
    await tester.pumpAndSettle();
    expect(find.text('Pending  2'), findsOneWidget);
    expect(find.text('Resolved  2'), findsOneWidget);
  });

  testWidgets('detail screen shows the description and toggles status', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Projector will not turn on'));
    await tester.pumpAndSettle();

    expect(find.text('Report details'), findsOneWidget);
    expect(find.text('ELECTRICITY'), findsOneWidget);
    expect(find.text('Building A, room 112'), findsOneWidget);
    expect(find.text('Nov 10'), findsOneWidget);
    expect(
      find.textContaining('The projector does not power on'),
      findsOneWidget,
    );
    expect(find.text('Pending'), findsOneWidget);

    await tester.tap(find.text('Mark resolved'));
    await tester.pumpAndSettle();
    expect(find.text('Resolved'), findsOneWidget);
    expect(find.text('Reopen'), findsOneWidget);

    // Home reflects the change after going back.
    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();
    expect(find.text('My reports'), findsOneWidget);
    expect(find.text('Pending  1'), findsOneWidget);
    expect(find.text('Resolved  3'), findsOneWidget);
  });
}
