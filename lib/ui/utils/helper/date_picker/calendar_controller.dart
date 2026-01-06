import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../framework/provider/network/network.dart';

final calendarController =
    ChangeNotifierProvider((ref) => CalendarController());

class CalendarController extends ChangeNotifier {
  ///Override of notify Listener
  @override
  void notifyListeners() {
    super.notifyListeners();
  }

  ///[AnimationController] to create slide effect
  AnimationController? animationController;
  Animation<Offset>? slideAnimation;

  ///Initialise [AnimationController
  initAnimationController(customDatePickerState) {
    animationController = AnimationController(
        vsync: customDatePickerState,
        duration: const Duration(milliseconds: 150));
    if (animationController != null) {
      ///Slide right to left
      slideAnimation = Tween<Offset>(
        begin: const Offset(0.1, 0),
        end: Offset.zero,
      ).animate(animationController!);
      animationController?.forward();
    }
  }

  ///Initially Selected [DateTime]
  DateTime selectedDate = DateTime.now();
  DateTime displayDate = DateTime.now();
  DateTime firstDate = DateTime(1900);
  DateTime lastDate = DateTime(DateTime.now().year + 50);
  List<YearModel> numOfYears = [];
  YearModel? selectedYear;
  MonthModel? selectedMonth;

  ///[Dispose] controller to reset values
  disposeController(BuildContext context, customDatePickerState,
      {DateTime? initialDate,
      required DateTime firstDate,
      required DateTime lastDate}) {
    widgetDisplayed = WidgetDisplayed.day;
    if (firstDate != DateTime(1900) &&
        lastDate != DateTime(DateTime.now().year + 50)) {
      if (lastDate.difference(firstDate).isNegative) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select proper dates')));
        Navigator.pop(context);
        return;
      }
      if (!(((firstDate.difference(initialDate ?? DateTime.now()))
              .isNegative) &&
          ((lastDate.difference(initialDate ?? DateTime.now())).isNegative))) {
        selectedDate = initialDate ?? DateTime.now();
        displayDate = initialDate ?? DateTime.now();
      } else {
        if (((lastDate.difference(initialDate ?? DateTime.now())).isNegative)) {
          selectedDate = lastDate;
          displayDate = lastDate;
        } else {
          selectedDate = firstDate;
          displayDate = firstDate;
        }
      }
    }
    this.firstDate = firstDate;
    this.lastDate = lastDate;
    selectedDate = initialDate ?? DateTime.now();

    ///If First date is defined
    if (firstDate != DateTime(1900) &&
        lastDate == DateTime(DateTime.now().year + 50)) {
      if (!((firstDate.difference(initialDate ?? DateTime.now())).isNegative)) {
        selectedDate = firstDate;
        displayDate = firstDate;
      } else {
        selectedDate = initialDate ?? DateTime.now();
        displayDate = initialDate ?? DateTime.now();
      }
    }

    ///If Last Date is defined
    if (lastDate != DateTime(DateTime.now().year + 50) &&
        firstDate == DateTime(1900)) {
      if (((lastDate.difference(initialDate ?? DateTime.now())).isNegative)) {
        selectedDate = lastDate;
        displayDate = lastDate;
      } else {
        selectedDate = initialDate ?? DateTime.now();
        selectedDate = initialDate ?? DateTime.now();
      }
    }

    ///If no First and Last date are defined
    if (firstDate == DateTime(1900) &&
        lastDate == DateTime(DateTime.now().year + 50)) {
      selectedDate = initialDate ?? DateTime.now();
      displayDate = initialDate ?? DateTime.now();
    }
    numOfYears = [];
    for (int year = firstDate.year; year <= (lastDate.year); year++) {
      numOfYears.add(YearModel(year: year));
    }
    selectedYear =
        numOfYears.where((element) => element.year == selectedDate.year).first;
    selectedMonth =
        month.where((element) => element.month == selectedDate.month).first;
    updateDayList();
    initAnimationController(customDatePickerState);
    notifyListeners();
  }

  ///Update [SelectedDate] on click on [Date]
  updateSelectedDate({required DateTime selectedDate}) {
    if (isDateAvailable(selectedDate)) {
      this.selectedDate = selectedDate;
      selectedYear = numOfYears
          .where((element) => element.year == selectedDate.year)
          .first;
      selectedMonth =
          month.where((element) => element.month == selectedDate.month).first;
    }
    notifyListeners();
  }

  ///Update [SelectedDate] on click on [Date]
  updateDisplayDate({required DateTime displayDate}) {
    this.displayDate = displayDate;
    notifyListeners();
    updateDayList();
  }

  ///Go to previous month
  goToPreviousMonth() {
    if ((animationController?.isCompleted ?? false) &&
        isPreviousButtonVisible()) {
      ///Slide left to right
      slideAnimation =
          Tween<Offset>(begin: const Offset(-0.1, 0), end: Offset.zero)
              .animate(animationController!);
      animationController?.reset();
      if (displayDate.month == 1) {
        displayDate = DateTime((displayDate.year - 1), 12);
      } else {
        displayDate = DateTime(displayDate.year, (displayDate.month - 1));
      }
      animationController?.forward();
      updateDayList(month: displayDate.month, year: displayDate.year);
    }
  }

  ///Go to next month
  goToNextMonth() {
    if ((animationController?.isCompleted ?? false) &&
        isForwardButtonVisible()) {
      ///Slide right to left
      slideAnimation =
          Tween<Offset>(begin: const Offset(0.1, 0), end: Offset.zero)
              .animate(animationController!);
      animationController?.reset();
      if (displayDate.month == 12) {
        displayDate = DateTime((displayDate.year + 1), 1);
      } else {
        displayDate = DateTime(displayDate.year, (displayDate.month + 1));
      }
      animationController?.forward();
      updateDayList(month: displayDate.month, year: displayDate.year);
    }
  }

  ///Show Left Chevron
  isPreviousButtonVisible() {
    if (firstDate != DateTime(1900)) {
      return !((displayDate.month - firstDate.month) == 0 &&
          (displayDate.year - firstDate.year) == 0);
    }
    return true;
  }

  ///Show Right Chevron
  isForwardButtonVisible() {
    if (lastDate != DateTime(DateTime.now().year + 50)) {
      return !((displayDate.month - lastDate.month) == 0 &&
          (displayDate.year - lastDate.year) == 0);
    }
    return true;
  }

  ///Make Particular Date Enable
  isDateAvailable(DateTime? dateTime) {
    if (firstDate == DateTime(1900) &&
        lastDate == DateTime(DateTime.now().year + 50)) {
      return true;
    } else if (firstDate != DateTime(1900) &&
        lastDate == DateTime(DateTime.now().year + 50)) {
      return ((dateTime?.year == firstDate.year &&
              dateTime?.month == firstDate.month)
          ? ((dateTime?.day ?? DateTime.now().day) >= firstDate.day)
          : true);
    } else if (firstDate == DateTime(1900) &&
        lastDate != DateTime(DateTime.now().year + 50)) {
      return ((dateTime?.year == lastDate.year &&
              dateTime?.month == lastDate.month)
          ? ((dateTime?.day ?? DateTime.now().day) <= lastDate.day)
          : true);
    } else if (firstDate != DateTime(1900) &&
        lastDate != DateTime(DateTime.now().year + 50)) {
      return ((dateTime?.year == firstDate.year &&
                  dateTime?.month == firstDate.month)
              ? ((dateTime?.day ?? DateTime.now().day) >= firstDate.day)
              : true) &&
          ((dateTime?.year == lastDate.year &&
                  dateTime?.month == lastDate.month)
              ? ((dateTime?.day ?? DateTime.now().day) <= lastDate.day)
              : true);
    }
    return true;
  }

  ///Make Particular Month Enable
  isMonthAvailable(index) {
    DateTime? dateTime = DateTime(displayDate.year, month[index].month);

    if (firstDate == DateTime(1900) &&
        lastDate == DateTime(DateTime.now().year + 50)) {
      return true;
    } else if (firstDate != DateTime(1900) &&
        lastDate == DateTime(DateTime.now().year + 50)) {
      return (dateTime.year == firstDate.year &&
          dateTime.month >= firstDate.month);
    } else if (firstDate == DateTime(1900) &&
        lastDate != DateTime(DateTime.now().year + 50)) {
      return (dateTime.year == lastDate.year &&
          dateTime.month <= lastDate.month);
    } else if (firstDate != DateTime(1900) &&
        lastDate != DateTime(DateTime.now().year + 50)) {
      return ((dateTime.year == firstDate.year &&
              dateTime.month >= firstDate.month) &&
          (dateTime.year == lastDate.year && dateTime.month <= lastDate.month));
    }
    return true;
  }

  ///[List<DateTime>] to get day in month.
  List<DateTime> dayList = [];

  ///[List<List<DateTime>>] to get days with week day.
  List<List<DateTime?>> dayWiseMonthlyList = [];

  ///Update list of total days in month
  updateDayList({int? month, int? year}) {
    dayList =
        daysList(month ?? displayDate.month, year ?? displayDate.year) ?? [];
    updateDayWiseMonthList(dayList);
    notifyListeners();
  }

  ///Sort days in month day of week wise
  updateDayWiseMonthList(List<DateTime> dayList) {
    dayWiseMonthlyList = getDayWiseMonthlyList(dayList) ?? [];
    notifyListeners();
  }

  ///Default Animation
  Animation<Offset> get defaultAnimation =>
      Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
          .animate(animationController!);

  ///[List] of Day of Week
  List<WeekModel> day = <WeekModel>[
    WeekModel(weekDay: 1, weekDayName: 'Monday'),
    WeekModel(weekDay: 2, weekDayName: 'Tuesday'),
    WeekModel(weekDay: 3, weekDayName: 'Wednesday'),
    WeekModel(weekDay: 4, weekDayName: 'Thursday'),
    WeekModel(weekDay: 5, weekDayName: 'Friday'),
    WeekModel(weekDay: 6, weekDayName: 'Saturday'),
    WeekModel(weekDay: 7, weekDayName: 'Sunday'),
  ];

  ///[List] of Months
  final month = <MonthModel>[
    MonthModel(month: 1, monthName: 'January'),
    MonthModel(month: 2, monthName: 'February'),
    MonthModel(month: 3, monthName: 'March'),
    MonthModel(month: 4, monthName: 'April'),
    MonthModel(month: 5, monthName: 'May'),
    MonthModel(month: 6, monthName: 'Jun'),
    MonthModel(month: 7, monthName: 'July'),
    MonthModel(month: 8, monthName: 'August'),
    MonthModel(month: 9, monthName: 'September'),
    MonthModel(month: 10, monthName: 'October'),
    MonthModel(month: 11, monthName: 'November'),
    MonthModel(month: 12, monthName: 'December'),
  ];

  ///Get [List] of Days in current month
  List<DateTime>? daysList(final int monthNum, final int year) {
    int? numOfDays = daysInMonth(monthNum, year);
    if (numOfDays == null) {
      return null;
    }
    List<DateTime> dayList = [];
    for (int day = 0; day < numOfDays; day++) {
      dayList.add(DateTime(year, monthNum, (day + 1)));
    }
    return dayList;
  }

  ///Get [List] of Days in current month week dat wise
  List<List<DateTime?>>? getDayWiseMonthlyList(List<DateTime> dayList) {
    List<List<DateTime?>> dayWiseMonthlyList = [[], [], [], [], [], [], []];
    for (var dateElement in dayList) {
      dayWiseMonthlyList[dateElement.weekday - 1].add(dateElement);
    }
    int maxLength = 0;
    int dayIndex = 0;
    List<int> indexWhereAddAtLast = [];
    bool addAtLast = false;
    for (dayIndex = 0; dayIndex < dayWiseMonthlyList.length; dayIndex++) {
      List<DateTime?> element = dayWiseMonthlyList[dayIndex];
      if (maxLength < element.length) {
        if (maxLength != 0) {
          addAtLast = true;
        }
        maxLength = element.length;
      }
      if (addAtLast) {
        indexWhereAddAtLast.add(dayIndex);
      }
    }
    for (dayIndex = 0; dayIndex < dayWiseMonthlyList.length; dayIndex++) {
      List<DateTime?> element = dayWiseMonthlyList[dayIndex];
      Duration? diff = dayWiseMonthlyList[dayIndex]
          .first
          ?.difference(dayWiseMonthlyList.last.first ?? DateTime.now());
      if (diff != null && !(diff.isNegative) && diff != Duration.zero) {
        element.insert(0, null);
      }
    }
    return dayWiseMonthlyList;
  }

  ///Get day name
  String? getDay(int dayNum) {
    return day.where((element) => element.weekDay == dayNum).first.weekDayName;
  }

  ///Get month name
  String getMonth(final int monthNum) {
    return month.where((element) => element.month == monthNum).first.monthName;
  }

  ///Get number of days in month
  int? daysInMonth(final int monthNum, final int year) {
    if (monthNum > 12) {
      return null;
    }
    List<int> monthLength = List.filled(12, 0);
    monthLength[0] = 31;
    monthLength[2] = 31;
    monthLength[4] = 31;
    monthLength[6] = 31;
    monthLength[7] = 31;
    monthLength[9] = 31;
    monthLength[11] = 31;
    monthLength[3] = 30;
    monthLength[8] = 30;
    monthLength[5] = 30;
    monthLength[10] = 30;

    if (isLeapYear(year) == true) {
      monthLength[1] = 29;
    } else {
      monthLength[1] = 28;
    }

    return monthLength[monthNum - 1];
  }

  ///Get if the current year is leap year
  bool isLeapYear(int year) =>
      (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

  ///Widget displayed
  WidgetDisplayed widgetDisplayed = WidgetDisplayed.day;

  updateWidgetDisplayed({WidgetDisplayed? widgetDisplayed}) {
    if (widgetDisplayed != null) {
      this.widgetDisplayed = widgetDisplayed;
    } else {
      if (this.widgetDisplayed == WidgetDisplayed.day) {
        this.widgetDisplayed = WidgetDisplayed.month;
      } else if (this.widgetDisplayed == WidgetDisplayed.month) {
        this.widgetDisplayed = WidgetDisplayed.year;
      } else {
        this.widgetDisplayed = WidgetDisplayed.day;
      }
    }
    notifyListeners();
  }

  ///Year Widget constraints
  BoxConstraints? yearConstraints;

  updateYearConstraints(BoxConstraints yearConstraints) {
    this.yearConstraints = yearConstraints;
    notifyListeners();
  }
}

enum WidgetDisplayed { year, month, day }

class YearModel {
  int year;

  YearModel({required this.year});
}

class MonthModel {
  int month;
  String monthName;

  MonthModel({required this.month, required this.monthName});
}

class WeekModel {
  int weekDay;
  String weekDayName;

  WeekModel({required this.weekDay, required this.weekDayName});
}
