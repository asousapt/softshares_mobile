import 'package:flutter/material.dart';

class DropdownGenereica<T> extends StatelessWidget {
  // Dropdown that receives the selected value, a list of items, the onChanged function, a function that returns the text of the item, and the title
  const DropdownGenereica({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.getText,
    required this.titulo,
    this.readOnly = false,
  final List<T>? items;
  final String Function(T) getText;
  final void Function(T?)? onChanged;
  final String titulo;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items!.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(getText(item)),
        );
      }).toList(),
      onChanged: readOnly ? null : onChanged,
      decoration: InputDecoration(
        labelText: titulo,
      ),
      disabledHint: value != null ? Text(getText(value!)) : null,
    );
  }
}
