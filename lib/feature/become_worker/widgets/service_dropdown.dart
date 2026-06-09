import 'package:flutter/material.dart';

class ServiceDropdown extends StatelessWidget {
  final String hint;
  final IconData icon;
  final List<String> items;
  final String? value;
  final Function(String?) onChanged;

  const ServiceDropdown({
    super.key,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              underline: SizedBox(),
              hint: Text(
                hint,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
