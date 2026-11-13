import 'package:riskapp/models/report.dart';

/// Initial sample data. It lives only in memory: changes are lost when the
/// app is closed.
const List<Report> sampleReports = [
  Report(
    id: 1,
    category: 'Electricity',
    title: 'Projector will not turn on',
    location: 'Building A, room 112',
    date: 'Nov 10',
    description:
        'The projector does not power on even though the outlet works. '
        'The indicator light stays off.',
  ),
  Report(
    id: 2,
    category: 'Internet and Networks',
    title: 'Wi-Fi drops every few minutes',
    location: 'Library, 2nd floor',
    date: 'Nov 9',
    description:
        'The campus Wi-Fi disconnects every few minutes near the study '
        'tables, so online exams and video calls keep failing.',
  ),
  Report(
    id: 3,
    category: 'Maintenance',
    title: 'Leaking tap in restroom',
    location: 'Science building, ground floor',
    date: 'Nov 4',
    description:
        'The second tap in the men\'s restroom keeps dripping and leaves '
        'water on the floor.',
    status: ReportStatus.resolved,
  ),
  Report(
    id: 4,
    category: 'Furniture',
    title: 'Broken chair in lecture hall',
    location: 'Hall 3, back row',
    date: 'Oct 28',
    description:
        'One of the chairs in the back row has a broken leg and is unsafe '
        'to sit on.',
    status: ReportStatus.resolved,
  ),
];
