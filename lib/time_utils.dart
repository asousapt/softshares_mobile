import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<void> displayTimePicker(
  BuildContext context,
  TextEditingController controller,
  TimeOfDay initialTime,
) async {
  final TimeOfDay? time = await showTimePicker(
    context: context,
    initialTime: initialTime,
  );

  if (time != null) {
    controller.text =
        "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}

Future<void> displayDatePicker(
  BuildContext context,
  TextEditingController controller,
  DateTime initialDate,
  DateTime firstDate,
  DateTime lastDate,
) async {
  final DateTime? date = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (date != null) {
    controller.text = date.toLocal().toString().split(" ")[0];
  }
}

// Dada uma string devolve um objeto TimeOfDay
TimeOfDay parseTimeOfDay(String timeString) {
  final List<String> parts = timeString.split(':');
  final int hour = int.parse(parts[0]);
  final int minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}

String dataFormatada(String local, DateTime data) {
  String dataF = "";

  dataF =
      "${DateFormat.yMd(local).format(data)} - ${DateFormat.jm(local).format(data)}";
  return dataF;
}
