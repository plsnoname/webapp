import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class ReservationDateManager {
  static Map<String, Map<DateTime, bool>> _blockedDates = {};

  // Modified method to accept unavailable dates directly
  static void setUnavailableDates(String roomType, int roomNumber, List<DateTime> unavailableDates) {
    final String roomKey = '${roomType}_${roomNumber}';
    _blockedDates[roomKey] = {};
    
    for (var date in unavailableDates) {
      _blockedDates[roomKey]![DateTime(date.year, date.month, date.day)] = true;
    }
  }

  // Original method kept for backward compatibility
  static Future<void> loadReservations(String roomType, int roomNumber) async {
    try {
      final String response =
          await rootBundle.loadString('assets/mock/reservation_details.json');
      final data = json.decode(response);
      final reservations =
          List<Map<String, dynamic>>.from(data['reservations']);

      final String roomKey = '${roomType}_${roomNumber}';
      _blockedDates[roomKey] = {};

      // Filter reservations for specific room
      final roomReservations = reservations.where((reservation) =>
          reservation['roomType'] == roomType &&
          reservation['roomIndex'] == roomNumber);

      for (var reservation in roomReservations) {
        final startDate = DateTime.parse(reservation['startDate']);
        final endDate = DateTime.parse(reservation['endDate']);

        var currentDate = startDate;
        while (currentDate.isBefore(endDate)) {
          _blockedDates[roomKey]![DateTime(
              currentDate.year, currentDate.month, currentDate.day)] = true;
          currentDate = currentDate.add(Duration(days: 1));
        }
      }
    } catch (e) {
      print('Error loading reservations: $e');
    }
  }

  static bool isDateAvailable(DateTime date, String roomType, int roomNumber) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    if (normalizedDate.isBefore(today)) {
      return false;
    }

    final String roomKey = '${roomType}_${roomNumber}';
    return !(_blockedDates[roomKey]?.containsKey(normalizedDate) ?? false);
  }
}

// Updated function to accept a list of unavailable dates
Future<DateTimeRange?> showCustomDateRangePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  required String roomType,
  required int roomNumber,
  DateTimeRange? initialDateRange,
  List<DateTime>? unavailableDates,
}) async {
  // If unavailableDates is provided, use them directly
  if (unavailableDates != null) {
    ReservationDateManager.setUnavailableDates(roomType, roomNumber, unavailableDates);
  } else {
    // Otherwise fall back to loading from JSON
    await ReservationDateManager.loadReservations(roomType, roomNumber);
  }

  DateTime? startDate = initialDateRange?.start;
  DateTime? endDate = initialDateRange?.end;

  return await showDialog<DateTimeRange>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void updateDates(Map<String, DateTime?> dates) {
            setState(() {
              startDate = dates['startDate'];
              endDate = dates['endDate'];
            });
          }

          final scrollController = ScrollController(
            initialScrollOffset:
                _calculateInitialScrollOffset(initialDate, firstDate),
          );

          return Dialog(
            backgroundColor: Colors.grey[900],
            insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Container(
              width: 400,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select Dates',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),

                  // Calendar
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _calculateMonthCount(firstDate, lastDate),
                      itemBuilder: (context, index) {
                        final month = DateTime(
                          firstDate.year,
                          firstDate.month + index,
                        );
                        return _buildMonthCalendar(
                          month,
                          startDate,
                          endDate,
                          (date) => ReservationDateManager.isDateAvailable(
                              date, roomType, roomNumber),
                          updateDates,
                        );
                      },
                    ),
                  ),

                  // Footer with selected date range info
                  if (startDate != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        endDate != null 
                            ? '${DateFormat('MMM d, yyyy').format(startDate!)} - ${DateFormat('MMM d, yyyy').format(endDate!)}'
                            : 'From ${DateFormat('MMM d, yyyy').format(startDate!)}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel',
                              style: TextStyle(color: Colors.white)),
                        ),
                        TextButton(
                          onPressed: startDate != null && endDate != null
                              ? () => Navigator.of(context).pop(DateTimeRange(
                                  start: startDate!, end: endDate!))
                              : null,
                          child: Text('Select',
                              style: TextStyle(
                                color: startDate != null && endDate != null
                                    ? Colors.blue
                                    : Colors.grey,
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// Helper function to easily show the date picker from any view
Future<DateTimeRange?> showHotelDatePicker({
  required BuildContext context,
  required String hotelId, // Can be used to fetch specific hotel availability
  List<DateTime>? unavailableDates,
  DateTimeRange? initialDateRange,
}) {
  final now = DateTime.now();
  final initialDate = initialDateRange?.start ?? now;
  final firstDate = now;
  final lastDate = DateTime(now.year + 1, now.month, now.day);
  
  return showCustomDateRangePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    roomType: hotelId, // Use hotelId as the room type
    roomNumber: 1, // Default room number
    initialDateRange: initialDateRange,
    unavailableDates: unavailableDates,
  );
}

double _calculateInitialScrollOffset(DateTime initialDate, DateTime firstDate) {
  final monthDiff = (initialDate.year - firstDate.year) * 12 +
      initialDate.month -
      firstDate.month;
  const double monthHeight = 340.0;
  return monthDiff * monthHeight;
}

int _calculateMonthCount(DateTime firstDate, DateTime lastDate) {
  return (lastDate.year - firstDate.year) * 12 +
      lastDate.month -
      firstDate.month +
      1;
}

Widget _buildMonthCalendar(
  DateTime month,
  DateTime? startDate,
  DateTime? endDate,
  bool Function(DateTime) isDateAvailable,
  Function(Map<String, DateTime?>) updateDates,
) {
  final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
  final firstDayOfMonth = DateTime(month.year, month.month, 1);

  // Get the weekday (1-7, where 1 is Monday and 7 is Sunday)
  int firstWeekday = firstDayOfMonth.weekday;
  // Adjust for Sunday as 7 instead of 0
  if (firstWeekday == 7) firstWeekday = 0;

  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          DateFormat('MMMM yyyy').format(month),
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // Changed order to start with Sunday
        children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
            .map((day) => SizedBox(
                  width: 40,
                  child: Text(
                    day,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ))
            .toList(),
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
        ),
        itemCount: 42,
        itemBuilder: (context, index) {
          // Adjust index calculation for Sunday start
          final int day = index - firstWeekday + 1;
          if (day < 1 || day > daysInMonth) return Container();

          final date = DateTime(month.year, month.month, day);
          final isAvailable = isDateAvailable(date);
          final isStart = startDate?.isAtSameMomentAs(date) ?? false;
          final isEnd = endDate?.isAtSameMomentAs(date) ?? false;

          final isInRange = startDate != null &&
              endDate != null &&
              date.isAfter(startDate) &&
              date.isBefore(endDate);

          return GestureDetector(
            onTap: isAvailable
                ? () => _handleDateTap(
                    date, startDate, endDate, isDateAvailable, updateDates)
                : null,
            child: Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isStart
                    ? Colors.blue
                    : isEnd
                        ? Colors.green
                        : isInRange
                            ? Colors.purple.withOpacity(0.3)
                            : Colors.transparent,
                border: Border.all(
                  color: isStart
                      ? Colors.blue
                      : isEnd
                          ? Colors.green
                          : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    day.toString(),
                    style: TextStyle(
                      color: isAvailable ? Colors.white : Colors.grey,
                      fontWeight: (isStart || isEnd)
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  if (!isAvailable)
                    Transform.rotate(
                      angle: 0.785398,
                      child: Container(
                        width: 24,
                        height: 2,
                        color: Colors.red.withOpacity(0.5),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
      SizedBox(height: 16),
    ],
  );
}

void _handleDateTap(
  DateTime date,
  DateTime? startDate,
  DateTime? endDate,
  bool Function(DateTime) isDateAvailable,
  Function(Map<String, DateTime?>) updateDates,
) {
  final selectedDate = DateTime(date.year, date.month, date.day);

  // Always check if the date is available
  if (!isDateAvailable(selectedDate)) return;

  // Case 1: Starting fresh (no dates selected)
  if (startDate == null) {
    updateDates({
      'startDate': selectedDate,
      'endDate': null,
    });
    return;
  }

  // Case 2: Have start date, selecting end date
  if (endDate == null) {
    // Verify all dates in between are available
    var currentDate = startDate;
    while (currentDate.isBefore(selectedDate)) {
      currentDate = currentDate.add(Duration(days: 1));
      if (!isDateAvailable(currentDate)) {
        // If any date is unavailable, start new selection
        updateDates({
          'startDate': selectedDate,
          'endDate': null,
        });
        return;
      }
    }

    if (selectedDate.isAfter(startDate)) {
      updateDates({
        'startDate': startDate,
        'endDate': selectedDate,
      });
      return;
    }
  }

  // Case 3: Always start new selection if:
  // - clicking before existing selection
  // - clicking after complete selection
  // - clicking within existing selection
  updateDates({
    'startDate': selectedDate,
    'endDate': null,
  });
}

// Updated CustomDateRangePicker to support unavailable dates
class CustomDateRangePicker extends StatefulWidget {
  final String selectedMonth;
  final Map<String, List<List<bool>>> occupancyData;
  final List<DateTime>? unavailableDates;

  const CustomDateRangePicker({
    Key? key,
    required this.selectedMonth,
    required this.occupancyData,
    this.unavailableDates,
  }) : super(key: key);

  @override
  _CustomDateRangePickerState createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  late DateTime _currentMonth;
  late List<DateTime> _displayedMonths;
  late Map<DateTime, bool> _unavailableDatesMap;

  @override
  void initState() {
    super.initState();
    // Initialize with the passed month
    _currentMonth = DateFormat('MMMM yyyy').parse(widget.selectedMonth);
    _displayedMonths = [
      _currentMonth,
      DateTime(_currentMonth.year, _currentMonth.month + 1),
      DateTime(_currentMonth.year, _currentMonth.month + 2),
      DateTime(_currentMonth.year, _currentMonth.month + 3),
      DateTime(_currentMonth.year, _currentMonth.month + 4),
      DateTime(_currentMonth.year, _currentMonth.month + 5),
      DateTime(_currentMonth.year, _currentMonth.month + 6),
      DateTime(_currentMonth.year, _currentMonth.month + 7),
      DateTime(_currentMonth.year, _currentMonth.month + 8),
      DateTime(_currentMonth.year, _currentMonth.month + 9),
      DateTime(_currentMonth.year, _currentMonth.month + 10),
      DateTime(_currentMonth.year, _currentMonth.month + 11),
    ];
    
    // Convert unavailable dates to a map for faster lookup
    _unavailableDatesMap = {};
    widget.unavailableDates?.forEach((date) {
      final normalized = DateTime(date.year, date.month, date.day);
      _unavailableDatesMap[normalized] = true;
    });
  }

  bool _isDateAvailable(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    
    if (normalized.isBefore(today)) {
      return false;
    }
    
    return !_unavailableDatesMap.containsKey(normalized);
  }

  void _onMonthChanged(bool next) {
    setState(() {
      if (next) {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      } else {
        _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      }
      _displayedMonths = [
        _currentMonth,
        DateTime(_currentMonth.year, _currentMonth.month + 1),
        DateTime(_currentMonth.year, _currentMonth.month + 2),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Column(
            children: _displayedMonths
                .map((month) => _buildMonthCalendar(
                      month,
                      null, // startDate
                      null, // endDate
                      _isDateAvailable, // Custom date availability function
                      (_) {}, // updateDates
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
