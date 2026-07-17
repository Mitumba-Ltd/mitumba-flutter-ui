import 'package:flutter/material.dart';
import '../../tokens/colors.dart';
import '../../tokens/radius.dart';
import '../../tokens/shadows.dart';
import '../foundation/mitumba_text_field.dart';

/// Premium custom DatePicker widget with a custom calendar popup.
class MitumbaDatePicker extends StatefulWidget {
  const MitumbaDatePicker({
    super.key,
    this.value,
    required this.onChange,
    this.label,
    this.hint = 'Select date',
    this.disabled = false,
  });

  /// Currently selected Date.
  final DateTime? value;

  /// Triggered when a new date is selected in the picker.
  final ValueChanged<DateTime> onChange;

  /// Optional label text shown above input.
  final String? label;

  /// Hint text shown inside input.
  final String hint;

  /// Disables user interaction.
  final bool disabled;

  @override
  State<MitumbaDatePicker> createState() => _MitumbaDatePickerState();
}

class _MitumbaDatePickerState extends State<MitumbaDatePicker> {
  void _showCalendar(BuildContext context) {
    if (widget.disabled) return;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: MitumbaColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MitumbaRadius.md),
          ),
          child: SizedBox(
            width: 320,
            child: _CalendarDialogContent(
              initialDate: widget.value ?? DateTime.now(),
              selectedDate: widget.value,
              onSelect: (date) {
                widget.onChange(date);
                Navigator.of(dialogContext).pop();
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedValue = widget.value != null
        ? '${widget.value!.day.toString().padLeft(2, '0')}/${widget.value!.month.toString().padLeft(2, '0')}/${widget.value!.year}'
        : '';

    return GestureDetector(
      onTap: () => _showCalendar(context),
      child: AbsorbPointer(
        absorbing: true, // Let taps pass through GestureDetector
        child: MitumbaTextField(
          label: widget.label,
          hint: widget.hint,
          value: formattedValue,
          onChange: (_) {},
          disabled: widget.disabled,
          suffix: MouseRegion(
            cursor: widget.disabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
            child: const Icon(
              Icons.calendar_today,
              size: 20,
              color: MitumbaColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarDialogContent extends StatefulWidget {
  const _CalendarDialogContent({
    required this.initialDate,
    required this.selectedDate,
    required this.onSelect,
  });

  final DateTime initialDate;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onSelect;

  @override
  State<_CalendarDialogContent> createState() => _CalendarDialogContentState();
}

class _CalendarDialogContentState extends State<_CalendarDialogContent> {
  late DateTime _currentMonth;

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.initialDate.year, widget.initialDate.month, 1);
  }

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  int _daysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  int _firstDayOffset(DateTime date) {
    // DateTime.weekday returns 1 for Monday to 7 for Sunday.
    // Offset represents empty cells before Monday (MON = index 0, SUN = index 6).
    final weekday = DateTime(date.year, date.month, 1).weekday;
    return weekday - 1; // MON=0, TUE=1, ..., SUN=6
  }

  bool _isToday(int day) {
    final today = DateTime.now();
    return day == today.day &&
        _currentMonth.month == today.month &&
        _currentMonth.year == today.year;
  }

  bool _isSelected(int day) {
    return widget.selectedDate != null &&
        day == widget.selectedDate!.day &&
        _currentMonth.month == widget.selectedDate!.month &&
        _currentMonth.year == widget.selectedDate!.year;
  }

  @override
  Widget build(BuildContext context) {
    final int daysCount = _daysInMonth(_currentMonth);
    final int offset = _firstDayOffset(_currentMonth);
    final int totalCells = daysCount + offset;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Month/Year Header controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _prevMonth,
              ),
              Text(
                '${_months[_currentMonth.month - 1]} ${_currentMonth.year}',
                style: const TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: MitumbaColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Days Header (MON - SUN)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _WeekdayLabel('MON'),
              _WeekdayLabel('TUE'),
              _WeekdayLabel('WED'),
              _WeekdayLabel('THU'),
              _WeekdayLabel('FRI'),
              _WeekdayLabel('SAT'),
              _WeekdayLabel('SUN'),
            ],
          ),
          const SizedBox(height: 8),

          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              if (index < offset) {
                return const SizedBox.shrink();
              }

              final int day = index - offset + 1;
              final isTodayCell = _isToday(day);
              final isSelectedCell = _isSelected(day);

              return _CalendarDayCell(
                day: day,
                isToday: isTodayCell,
                isSelected: isSelectedCell,
                onTap: () {
                  final selectedDate = DateTime(_currentMonth.year, _currentMonth.month, day);
                  widget.onSelect(selectedDate);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: MitumbaColors.textDisabled,
        ),
      ),
    );
  }
}

class _CalendarDayCell extends StatefulWidget {
  const _CalendarDayCell({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });

  final int day;
  final bool isToday;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_CalendarDayCell> createState() => _CalendarDayCellState();
}

class _CalendarDayCellState extends State<_CalendarDayCell> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color textColor = MitumbaColors.textPrimary;
    Color bgColor = Colors.transparent;

    if (widget.isSelected) {
      textColor = MitumbaColors.white;
      bgColor = MitumbaColors.green;
    } else if (widget.isToday) {
      textColor = MitumbaColors.green;
      bgColor = MitumbaColors.green.withValues(alpha: 0.1);
    } else if (_isHovered) {
      bgColor = MitumbaColors.background;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            boxShadow: widget.isSelected ? MitumbaShadows.card : null,
          ),
          transform: Matrix4.identity()
            ..scale(_isHovered ? 1.1 : 1.0),
          transformAlignment: Alignment.center,
          child: Text(
            '${widget.day}',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              fontWeight: widget.isToday || widget.isSelected ? FontWeight.w800 : FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
