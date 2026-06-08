import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  const AppSearchBar({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey),
          SizedBox(width: 7),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(width: 7),
          GestureDetector(child: Icon(Icons.tune, color: Colors.grey)),
        ],
      ),
    );
  }
}
