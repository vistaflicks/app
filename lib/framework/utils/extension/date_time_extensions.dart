extension DateTimeExtensions on DateTime {
  /// Returns the date in format: YYYY-MM-DD
  String get formattedDate {
    return "${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";
  }

  /// Returns the time in format: HH:MM (24-hour)
  String get formattedTime {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  /// Returns a more readable format like: April 17, 2025
  String get readableDate {
    return "${_monthName(month)} $day, $year";
  }

  /// Returns time in 12-hour format: 03:15 PM
  String get formattedTime12Hour {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final amPm = hour >= 12 ? 'PM' : 'AM';
    return "${h.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $amPm";
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}

String getFormattedDateLabel(DateTime date) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final msgDate = DateTime(date.year, date.month, date.day);

  final difference = today.difference(msgDate).inDays;

  if (difference == 0) return 'Today';
  if (difference == 1) return 'Yesterday';

  return "${msgDate.day} ${msgDate.month.toMonthName()} ${msgDate.year}";
}

extension DateTimeStringParsing on String {
  DateTime get toDateTime => DateTime.parse(this);
}

extension MonthNameExtension on int {
  String toMonthName() {
    const months = [
      '',
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
      'Dec'
    ];
    return months[this];
  }
}

extension DateTimeHelper on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension TimeAgoExtension on DateTime {
  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24 && now.day == this.day) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }
}
