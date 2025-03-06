import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';
import 'family_screen.dart';
import 'settings_screen.dart';
import '../controllers/theme_controller.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late List<String> _weekdays;
  late List<int> _dates;
  late DateTime _currentWeekStartDate;
  late DateTime _selectedDate;
  int _selectedDay = 6; // Index of the selected day (Thu)
  String _viewMode = 'Week'; // 'Week' or 'Month'
  late String _currentMonth;

  // Map to store chores by date
  late Map<String, List<Map<String, dynamic>>> _choresByDate;

  final List<Map<String, dynamic>> _recurringChores = [
    {
      'title': 'Vacuum living room',
      'frequency': 'Weekly',
      'day': 'Tuesday',
    },
    {
      'title': 'Take out trash',
      'frequency': 'Twice a week',
      'day': 'Mon, Thu',
    },
    {
      'title': 'Clean bathroom',
      'frequency': 'Weekly',
      'day': 'Saturday',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Initialize with current week
    _initializeWeekDates();

    // Create initial chores map
    _initializeChoresMap();
  }

  void _initializeWeekDates() {
    // Get today's date
    final now = DateTime.now();

    // Find the Monday of current week
    _currentWeekStartDate = now.subtract(Duration(days: now.weekday - 1));

    // Set the selected date to the current selected day index
    _selectedDate = _currentWeekStartDate.add(Duration(days: _selectedDay));

    // Update the weekdays and dates
    _updateWeekdaysAndDates();

    // Update current month
    _updateCurrentMonth();
  }

  void _updateWeekdaysAndDates() {
    _weekdays = [];
    _dates = [];

    // Generate weekdays and dates for the week
    for (int i = 0; i < 7; i++) {
      final date = _currentWeekStartDate.add(Duration(days: i));
      _weekdays
          .add(DateFormat('E').format(date).substring(0, 3)); // Mon, Tue, etc.
      _dates.add(date.day);
    }
  }

  void _updateCurrentMonth() {
    // For 'Week' view, show month of the selected date
    // For 'Month' view, show month of the first day of the selected month
    if (_viewMode == 'Week') {
      _currentMonth = DateFormat('MMMM yyyy').format(_selectedDate);
    } else {
      // For month view, just show current month of the first day
      _currentMonth = DateFormat('MMMM yyyy')
          .format(DateTime(_selectedDate.year, _selectedDate.month, 1));
    }
  }

  void _goToPreviousWeek() {
    setState(() {
      _currentWeekStartDate =
          _currentWeekStartDate.subtract(const Duration(days: 7));
      _selectedDate = _currentWeekStartDate.add(Duration(days: _selectedDay));
      _updateWeekdaysAndDates();
      _updateCurrentMonth();
    });
  }

  void _goToNextWeek() {
    setState(() {
      _currentWeekStartDate =
          _currentWeekStartDate.add(const Duration(days: 7));
      _selectedDate = _currentWeekStartDate.add(Duration(days: _selectedDay));
      _updateWeekdaysAndDates();
      _updateCurrentMonth();
    });
  }

  void _goToPreviousMonth() {
    setState(() {
      if (_viewMode == 'Month') {
        // Move to previous month, same day
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month - 1,
          _selectedDate.day >
                  _daysInMonth(_selectedDate.year, _selectedDate.month - 1)
              ? _daysInMonth(_selectedDate.year, _selectedDate.month - 1)
              : _selectedDate.day,
        );
      } else {
        _goToPreviousWeek();
      }
      _updateCurrentMonth();
    });
  }

  void _goToNextMonth() {
    setState(() {
      if (_viewMode == 'Month') {
        // Move to next month, same day
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month + 1,
          _selectedDate.day >
                  _daysInMonth(_selectedDate.year, _selectedDate.month + 1)
              ? _daysInMonth(_selectedDate.year, _selectedDate.month + 1)
              : _selectedDate.day,
        );
      } else {
        _goToNextWeek();
      }
      _updateCurrentMonth();
    });
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  void _initializeChoresMap() {
    _choresByDate = {};

    // Add a sample chore for today
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _choresByDate[today] = [
      {
        'title': 'Mow the lawn',
        'assignee': 'Dad',
        'assigneeInitial': 'D',
        'time': '5:00 PM',
      }
    ];

    // Process recurring chores and add them to appropriate dates
    _processRecurringChores();
  }

  void _processRecurringChores() {
    final today = DateTime.now();

    // Process for the next 4 weeks
    for (int dayOffset = 0; dayOffset < 28; dayOffset++) {
      final date = today.add(Duration(days: dayOffset));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final weekday = DateFormat('EEEE').format(date); // Full weekday name

      for (final chore in _recurringChores) {
        final frequency = chore['frequency'];
        final choreDay = chore['day'];

        // Check if this chore should appear on this date
        if ((frequency == 'Daily') ||
            (frequency == 'Weekly' && choreDay == weekday) ||
            (frequency == 'Twice a week' && _isChoreDay(choreDay, weekday))) {
          // Initialize the list if it doesn't exist
          _choresByDate[dateStr] ??= [];

          // Add the chore
          _choresByDate[dateStr]!.add({
            'title': chore['title'],
            'assignee': 'Assigned', // Default assignee
            'assigneeInitial': 'A',
            'time': '12:00 PM', // Default time
            'recurring': true,
          });
        }
      }
    }
  }

  bool _isChoreDay(String choreDays, String currentDay) {
    // For "Twice a week" or multiple days format like "Mon, Thu"
    final days = choreDays.split(', ');
    for (final day in days) {
      if (day == currentDay || day == currentDay.substring(0, 3)) {
        // Handles both "Monday" and "Mon"
        return true;
      }
    }
    return false;
  }

  void _toggleViewMode(String mode) {
    if (_viewMode != mode) {
      setState(() {
        _viewMode = mode;
        _updateCurrentMonth();
      });
    }
  }

  void _selectDay(int index) {
    setState(() {
      _selectedDay = index;
      _selectedDate = _currentWeekStartDate.add(Duration(days: index));
    });
  }

  List<Map<String, dynamic>> _getChoresForSelectedDay() {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    return _choresByDate[dateStr] ?? [];
  }

  String _getSelectedDayName() {
    return DateFormat('E').format(_selectedDate);
  }

  void _showAddChoreDialog() {
    final titleController = TextEditingController();
    final assigneeController = TextEditingController();
    final timeController = TextEditingController(text: '12:00 PM');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Chore'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Chore Title',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: assigneeController,
              decoration: const InputDecoration(
                labelText: 'Assignee',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(
                labelText: 'Time (e.g. 5:00 PM)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Add the new chore
              final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
              final newChore = {
                'title': titleController.text.isNotEmpty
                    ? titleController.text
                    : 'New Chore',
                'assignee': assigneeController.text.isNotEmpty
                    ? assigneeController.text
                    : 'Unassigned',
                'assigneeInitial': assigneeController.text.isNotEmpty
                    ? assigneeController.text[0]
                    : 'U',
                'time': timeController.text.isNotEmpty
                    ? timeController.text
                    : '12:00 PM',
              };

              setState(() {
                _choresByDate[dateStr] ??= [];
                _choresByDate[dateStr]!.add(newChore);
              });

              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddRecurringChoreDialog() {
    final titleController = TextEditingController();
    String frequency = 'Weekly';
    String day = 'Monday';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Recurring Chore'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Chore Title',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: frequency,
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                ),
                items: ['Daily', 'Weekly', 'Twice a week'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setDialogState(() {
                    frequency = newValue!;
                  });
                },
              ),
              const SizedBox(height: 12),
              if (frequency != 'Daily')
                DropdownButtonFormField<String>(
                  value: day,
                  decoration: const InputDecoration(
                    labelText: 'Day',
                  ),
                  items: frequency == 'Weekly'
                      ? [
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday',
                          'Saturday',
                          'Sunday'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()
                      : ['Mon, Thu', 'Tue, Fri', 'Wed, Sat', 'Sun, Wed']
                          .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  onChanged: (newValue) {
                    setDialogState(() {
                      day = newValue!;
                    });
                  },
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newChore = {
                  'title': titleController.text.isNotEmpty
                      ? titleController.text
                      : 'New Recurring Chore',
                  'frequency': frequency,
                  'day': frequency == 'Daily' ? 'Every day' : day,
                };

                setState(() {
                  _recurringChores.add(newChore);
                  // Re-process recurring chores to update the calendar
                  _initializeChoresMap();
                });

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog() {
    bool showCompleted = true;
    bool showPending = true;
    String assigneeFilter = 'All';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Filter Chores'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: const Text('Show Completed'),
                value: showCompleted,
                onChanged: (value) {
                  setDialogState(() {
                    showCompleted = value!;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Show Pending'),
                value: showPending,
                onChanged: (value) {
                  setDialogState(() {
                    showPending = value!;
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: assigneeFilter,
                decoration: const InputDecoration(
                  labelText: 'Assignee',
                ),
                items: ['All', 'Dad', 'Mom', 'Kids'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setDialogState(() {
                    assigneeFilter = newValue!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Apply filter (placeholder for now)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filters applied')),
                );
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthCalendar() {
    // Get the first day of the month
    final firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1);

    // Get the number of days in the month
    final daysInMonth = _daysInMonth(_selectedDate.year, _selectedDate.month);

    // Get the weekday of the first day (0 = Monday, 6 = Sunday per ISO)
    final firstWeekday = firstDayOfMonth.weekday - 1; // Adjust to 0-based index

    // Calculate rows needed (we'll show 6 rows to be consistent)
    const int weeksToShow = 6;
    final theme = Theme.of(context);

    return Column(
      children: [
        // Weekday headers
        Row(
          children: List.generate(7, (index) {
            final weekdayName = DateFormat('E')
                .format(DateTime(
                    _selectedDate.year, _selectedDate.month, index + 1))
                .substring(0, 1);

            return Expanded(
              child: Container(
                height: 30,
                alignment: Alignment.center,
                child: Text(
                  weekdayName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),

        // Calendar grid
        ...List.generate(weeksToShow, (weekIndex) {
          return Row(
            children: List.generate(7, (dayIndex) {
              final day = weekIndex * 7 + dayIndex - firstWeekday + 1;
              final isCurrentMonth = day > 0 && day <= daysInMonth;

              DateTime? date;
              if (isCurrentMonth) {
                date = DateTime(_selectedDate.year, _selectedDate.month, day);
              } else if (day <= 0) {
                // Previous month
                final prevMonth = _selectedDate.month - 1;
                final prevYear = prevMonth == 0
                    ? _selectedDate.year - 1
                    : _selectedDate.year;
                final prevMonthValue = prevMonth == 0 ? 12 : prevMonth;
                final daysInPrevMonth = _daysInMonth(prevYear, prevMonthValue);
                date =
                    DateTime(prevYear, prevMonthValue, daysInPrevMonth + day);
              } else {
                // Next month
                final nextMonth = _selectedDate.month + 1;
                final nextYear = nextMonth == 13
                    ? _selectedDate.year + 1
                    : _selectedDate.year;
                final nextMonthValue = nextMonth == 13 ? 1 : nextMonth;
                date = DateTime(nextYear, nextMonthValue, day - daysInMonth);
              }

              final dateStr = DateFormat('yyyy-MM-dd').format(date);
              final hasChores = _choresByDate.containsKey(dateStr) &&
                  _choresByDate[dateStr]!.isNotEmpty;

              final isSelected = isCurrentMonth &&
                  date.year == _selectedDate.year &&
                  date.month == _selectedDate.month &&
                  date.day == _selectedDate.day;

              final isToday = date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day;

              return Expanded(
                child: GestureDetector(
                  onTap: isCurrentMonth
                      ? () {
                          setState(() {
                            _selectedDate = date!;
                            // Find the weekday index (0-6)
                            final weekday = date.weekday - 1;
                            if (_viewMode == 'Week') {
                              // Adjust the week to contain this date
                              _currentWeekStartDate =
                                  date.subtract(Duration(days: weekday));
                              _selectedDay = weekday;
                              _updateWeekdaysAndDates();
                            }
                          });
                        }
                      : null,
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : isToday
                              ? theme.colorScheme.primary.withOpacity(0.2)
                              : isCurrentMonth
                                  ? theme.cardColor
                                  : theme.dividerColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected || isToday
                          ? Border.all(
                              color: theme.colorScheme.primary,
                              width: isSelected ? 2 : 1,
                            )
                          : isCurrentMonth
                              ? Border.all(
                                  color: theme.dividerColor.withOpacity(0.5))
                              : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isCurrentMonth ? day.toString() : '',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : isCurrentMonth
                                    ? theme.textTheme.bodyLarge?.color
                                    : theme.textTheme.bodyMedium?.color
                                        ?.withOpacity(0.5),
                            fontWeight: isToday || isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        if (hasChores && isCurrentMonth)
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the theme for dark mode support
    final themeController = Provider.of<ThemeController>(context);
    final theme = Theme.of(context);

    // Get chores for the selected day
    final dailyChores = _getChoresForSelectedDay();
    final selectedDayName = _getSelectedDayName();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to home
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: const Text(
          'Schedule',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Filter button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: OutlinedButton.icon(
              onPressed: _showFilterDialog,
              icon: const Icon(Icons.filter_list, size: 18),
              label: const Text('Filter'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.textTheme.bodyLarge?.color,
                side: BorderSide(color: theme.dividerColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Add button
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: _showAddChoreDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Month navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Previous month button
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: _viewMode == 'Week'
                          ? _goToPreviousWeek
                          : _goToPreviousMonth,
                      color: theme.iconTheme.color,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),

                  // Month and year
                  Expanded(
                    child: Text(
                      _currentMonth,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Next month button
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed:
                          _viewMode == 'Week' ? _goToNextWeek : _goToNextMonth,
                      color: theme.iconTheme.color,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // View mode toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _toggleViewMode('Week'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _viewMode == 'Week'
                                ? theme.colorScheme.primary.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: _viewMode == 'Week'
                                ? Border.all(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.3))
                                : null,
                          ),
                          child: Text(
                            'Week',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: _viewMode == 'Week'
                                  ? theme.colorScheme.primary
                                  : theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _toggleViewMode('Month'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _viewMode == 'Month'
                                ? theme.colorScheme.primary.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: _viewMode == 'Month'
                                ? Border.all(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.3))
                                : null,
                          ),
                          child: Text(
                            'Month',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: _viewMode == 'Month'
                                  ? theme.colorScheme.primary
                                  : theme.textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Calendar View (Week or Month)
            if (_viewMode == 'Week')
              // Weekday selector
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    bool isSelected = index == _selectedDay;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: GestureDetector(
                        onTap: () => _selectDay(index),
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.cardColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.dividerColor,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _weekdays[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _dates[index].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: isSelected
                                      ? Colors.white
                                      : theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              // Month view
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildMonthCalendar(),
              ),

            const SizedBox(height: 20),

            // Selected Day's Chores section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${selectedDayName}\'s Chores',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${dailyChores.length} tasks',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Daily chores
            dailyChores.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 20),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 48,
                            color: theme.textTheme.bodyMedium?.color
                                ?.withOpacity(0.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No chores scheduled for this day',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: _showAddChoreDialog,
                            icon:
                                const Icon(Icons.add_circle_outline, size: 16),
                            label: const Text('Add a chore'),
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dailyChores.length,
                    itemBuilder: (context, index) {
                      final chore = dailyChores[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.dividerColor),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 4,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          title: Text(
                            chore['title'],
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: theme.brightness == Brightness.dark
                                      ? Colors.grey.shade800
                                      : Colors.grey.shade200,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    chore['assigneeInitial'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                chore['assignee'],
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          trailing: Text(
                            chore['time'],
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

            const SizedBox(height: 24),

            // AI Schedule Optimization
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark
                    ? Color(0xFF2D1A3D) // Darker purple for dark mode
                    : Color(0xFFF5F0FF), // Light purple for light mode
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'AI',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Schedule Optimization',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your family has 5 chores on Wednesday but only 1 on Tuesday. Would you like me to suggest a more balanced schedule?',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Show suggestions dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Schedule Suggestions'),
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Here are some suggestions to balance your schedule:'),
                                  SizedBox(height: 12),
                                  Text(
                                      '• Move "Vacuum living room" from Wednesday to Tuesday'),
                                  Text(
                                      '• Move "Clean bathroom" from Saturday to Tuesday'),
                                  Text(
                                      '• Split "Take out trash" between Tuesday and Thursday'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Maybe Later'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Apply suggestions (placeholder)
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Schedule optimized')),
                                    );
                                  },
                                  child: const Text('Apply Suggestions'),
                                ),
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('View Suggestions'),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: () {
                          // Dismiss suggestion
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Suggestion dismissed')),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: theme.textTheme.bodyLarge?.color,
                        ),
                        child: const Text('Dismiss'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Recurring Chores section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recurring Chores',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _showAddRecurringChoreDialog,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.textTheme.bodyLarge?.color,
                      side: BorderSide(color: theme.dividerColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Recurring chores list
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.only(bottom: 100), // Add padding for FAB
              itemCount: _recurringChores.length,
              itemBuilder: (context, index) {
                final chore = _recurringChores[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: ListTile(
                    title: Text(
                      chore['title'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${chore['frequency']} • ${chore['day']}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        // Edit recurring chore
                        final titleController =
                            TextEditingController(text: chore['title']);
                        String frequency = chore['frequency'];
                        String day = chore['day'];

                        showDialog(
                          context: context,
                          builder: (context) => StatefulBuilder(
                            builder: (context, setDialogState) => AlertDialog(
                              title: const Text('Edit Recurring Chore'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: titleController,
                                    decoration: const InputDecoration(
                                      labelText: 'Chore Title',
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  DropdownButtonFormField<String>(
                                    value: frequency,
                                    decoration: const InputDecoration(
                                      labelText: 'Frequency',
                                    ),
                                    items: ['Daily', 'Weekly', 'Twice a week']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setDialogState(() {
                                        frequency = newValue!;
                                        // Reset day if needed
                                        if (frequency == 'Daily') {
                                          day = 'Every day';
                                        } else if (frequency == 'Weekly' &&
                                            day.contains(',')) {
                                          day = 'Monday';
                                        } else if (frequency ==
                                                'Twice a week' &&
                                            !day.contains(',')) {
                                          day = 'Mon, Thu';
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  if (frequency != 'Daily')
                                    DropdownButtonFormField<String>(
                                      value: day,
                                      decoration: const InputDecoration(
                                        labelText: 'Day',
                                      ),
                                      items: frequency == 'Weekly'
                                          ? [
                                              'Monday',
                                              'Tuesday',
                                              'Wednesday',
                                              'Thursday',
                                              'Friday',
                                              'Saturday',
                                              'Sunday'
                                            ].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList()
                                          : [
                                              'Mon, Thu',
                                              'Tue, Fri',
                                              'Wed, Sat',
                                              'Sun, Wed'
                                            ].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                      onChanged: (newValue) {
                                        setDialogState(() {
                                          day = newValue!;
                                        });
                                      },
                                    ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _recurringChores[index] = {
                                        'title': titleController.text.isNotEmpty
                                            ? titleController.text
                                            : chore['title'],
                                        'frequency': frequency,
                                        'day': frequency == 'Daily'
                                            ? 'Every day'
                                            : day,
                                      };
                                      // Re-process recurring chores
                                      _initializeChoresMap();
                                    });

                                    Navigator.pop(context);
                                  },
                                  child: const Text('Save'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // Bottom Navigation & Floating Action Button
      floatingActionButton: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: _showAddChoreDialog,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Home
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                child: _buildNavBarItem(Icons.home, 'Home', false),
              ),
              // Schedule - active
              _buildNavBarItem(Icons.calendar_today, 'Schedule', true),
              const SizedBox(width: 60), // Space for FAB
              // Family
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FamilyScreen()),
                  );
                },
                child: _buildNavBarItem(Icons.people, 'Family', false),
              ),
              // Settings
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
                  );
                },
                child: _buildNavBarItem(Icons.settings, 'Settings', false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, bool isActive) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? theme.colorScheme.primary : Colors.grey,
        ),
        Text(
          label,
          style: TextStyle(
            color: isActive ? theme.colorScheme.primary : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
