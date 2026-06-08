import 'package:flutter/material.dart';

class FilterChipsRow extends StatefulWidget {
  final Function(String) onFilterSelected;
  const FilterChipsRow({super.key, required this.onFilterSelected});

  @override
  State<FilterChipsRow> createState() => _FilterChipsRowState();
}

class _FilterChipsRowState extends State<FilterChipsRow> {
  final List<String> _filters = [
    'All',
    'Nearby',
    'Top Rated',
    'Low to High',
    'High to Low',
  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,

        child: Row(
          children: [
            ..._filters.asMap().entries.map((entry) {
              int index = entry.key;
              String filter = entry.value;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onFilterSelected(filter);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 8), // ← gap between chips
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                  decoration: BoxDecoration(
                    color: _selectedIndex == index
                        ? Color(0xFF6C3CE1) // ← active purple
                        : Colors.white, // ← inactive white
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedIndex == index
                          ? Color(0xFF6C3CE1)
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: _selectedIndex == index
                          ? Colors.white
                          : Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
