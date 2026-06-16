
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Widget startEndDatePicker(
    String title,
    Rx<DateTime> dateObs, {
      Rx<DateTime>? startDateObs,
    }) {
  return Obx(() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final now = DateTime.now();
            final startDate = startDateObs?.value ?? now;
            final pickedDate = await showDatePicker(
              context: Get.context!,
              initialDate:
              dateObs.value.isBefore(startDate) ? startDate : dateObs.value,
              firstDate: DateTime(
                startDate.year,
                startDate.month,
                startDate.day,
              ),
              lastDate: DateTime(2100),
              builder: (context, child) {
                return Theme(
                  data: redDialogTheme,
                  child: child!,
                );
              },
            );

            if (pickedDate == null) return;

            // ---------------- TIME PICKER ----------------
            TimeOfDay initialTime = TimeOfDay.fromDateTime(dateObs.value);

            // If same date as start date → restrict time
            if (startDateObs != null &&
                _isSameDate(pickedDate, startDate)) {
              initialTime = TimeOfDay(
                hour: startDate.hour,
                minute: startDate.minute,
              );
            }

            final pickedTime = await showTimePicker(
              context: Get.context!,
              initialTime: initialTime,
              builder: (context, child) {
                return Theme(
                  data: redDialogTheme,
                  child: child!,
                );
              },
            );

            if (pickedTime == null) return;

            final selectedDateTime = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            );

            if (startDateObs != null &&
                selectedDateTime.isBefore(startDate)) {
              Get.snackbar(
                "Invalid time",
                "Please select a date & time after start date",
                snackPosition: SnackPosition.BOTTOM,
              );
              return;
            }

            dateObs.value = selectedDateTime;
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              DateFormat('dd-MM-yyyy hh:mm a').format(dateObs.value.toLocal()),
            ),
          ),
        ),
      ],
    );
  });
}
bool _isSameDate(DateTime a, DateTime b) {
  return a.year == b.year &&
      a.month == b.month &&
      a.day == b.day;
}
final ThemeData redDialogTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Colors.red,          // Header, selected date
    onPrimary: Colors.white,      // Text on red
    onSurface: Colors.black,      // Body text
  ),
  dialogBackgroundColor: Colors.white,
);