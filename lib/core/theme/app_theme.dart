//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: Color(0xFFF5F5F5),
    primaryColor: Color(0xFF6C3CE1),
    colorScheme: ColorScheme.light(
      // ← ADD THIS
      primary: Color(0xFF6C3CE1),
    ),

    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyMedium: GoogleFonts.poppins(color: Colors.black87),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blueGrey,
      centerTitle: true,
      elevation: 2,
      titleTextStyle: GoogleFonts.lato(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 56, 52, 35),
        foregroundColor: Colors.black,
      ),
    ),
  );
}
