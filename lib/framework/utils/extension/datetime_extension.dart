import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toStringWithCustomDate(String outputFormat) {
    return DateFormat(outputFormat).format(this);
  }

  ///Returns a Date as a String in '01/01/2000' format
  String get dateOnly {
    return '$day/$month/$year';
  }

  /// Returns a date in "01/01/2000 01:00 AM"
  String get toFormattedDateTime {
    final day = this.day.toString().padLeft(2, '0');
    final month = this.month.toString().padLeft(2, '0');
    final year = this.year.toString();
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour < 12 ? 'AM' : 'PM';

    return '$day/$month/$year $hour:$minute $period';
  }

  ///Returns Hour and Time in 12 hour format as String From DateTime Object
  ///Format: '12:12 PM'
  String get timeOnly {
    int hours = hour;
    int minutes = minute;
    String period = (hours >= 12) ? 'PM' : 'AM';

    ///Convert to 12 hour format
    if (hours > 12) {
      hours -= 12;
    } else if (hours == 0) {
      hours = 12;
    }

    String formattedTime =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')} $period';

    return formattedTime;
  }
}

extension TimeExtension on TimeOfDay {
  bool isEqual(TimeOfDay time) {
    return this == time;
  }

  bool isBefore(TimeOfDay time) {
    int startSeconds = (hour * 3600) + (minute * 60);
    int endSeconds = (time.hour * 3600) + (time.minute * 60);
    return startSeconds < endSeconds;
  }

  bool isAfter(TimeOfDay time) {
    int startSeconds = (hour * 3600) + (minute * 60);
    int endSeconds = (time.hour * 3600) + (time.minute * 60);
    return startSeconds > endSeconds;
  }
}
