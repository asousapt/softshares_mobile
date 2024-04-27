import 'package:flutter/material.dart';

class CustomTab extends StatelessWidget {
  final IconData icon;
  final String text;

  const CustomTab({
    required this.icon,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
