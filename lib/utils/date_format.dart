const List<String> _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Formats a date like «Nov 12».
String formatShortDate(DateTime date) =>
    '${_months[date.month - 1]} ${date.day}';
