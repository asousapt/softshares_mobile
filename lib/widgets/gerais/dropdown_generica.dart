import 'package:flutter/material.dart';

class DropdownGenereica<T> extends StatelessWidget {
  // Dropdown quw recebe o valor selecionado, uma lista de itens, a funcao onchanged, a que retorna o texto do tipo de dados e o titulo
  const DropdownGenereica({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.getText,
    required this.titulo,
    super.key,
  });

  final T? value;
  final List<T>? items;
  final String Function(T) getText;
  final void Function(T?)? onChanged;
  final String titulo;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: value,
      items: items!.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(
            getText(item),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: titulo,
      ),
    );
  }
}
