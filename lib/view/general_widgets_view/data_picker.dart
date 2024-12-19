import 'package:flutter/material.dart';

class DatePickerFieldWidget extends StatefulWidget {
  final String label;
  final String? initialDate;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? hintText;
  final void Function(DateTime?)? onDateSelected;

  const DatePickerFieldWidget({
    super.key,
    required this.label,
    this.initialDate,
    this.onDateSelected,
    this.startDate,
    this.endDate,
    this.hintText,
  });

  @override
  State<DatePickerFieldWidget> createState() => _DatePickerFieldWidgetState();
}

class _DatePickerFieldWidgetState extends State<DatePickerFieldWidget> {
  late String _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? '';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.initialDate != null
          ? DateTime.parse(widget.initialDate!)
          : DateTime.now(),
      firstDate: widget.startDate ??
          DateTime.now().subtract(const Duration(days: 365 * 10)),
      lastDate: widget.endDate ?? DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = "${pickedDate.toLocal()}".split(' ')[0];
      });

      if (widget.onDateSelected != null) {
        widget.onDateSelected!(pickedDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  color: Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedDate.isNotEmpty
                        ? _selectedDate
                        : (widget.hintText ?? "Select a date..."),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
