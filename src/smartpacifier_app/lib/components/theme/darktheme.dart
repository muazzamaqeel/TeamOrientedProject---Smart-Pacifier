import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,

  scaffoldBackgroundColor: const Color(0xFF0E1117),

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF4DA3FF),
    secondary: Color(0xFF22C55E),
    surface: Color(0xFF161B22),
    surfaceVariant: Color(0xFF1F2630),
    outline: Color(0xFF2B3240),
  ),

  appBarTheme: const AppBarTheme(
    elevation: 0,
    centerTitle: false,
    backgroundColor: Color(0xFF161B22),
    foregroundColor: Colors.white,
  ),

  cardTheme: CardThemeData(
    elevation: 0,
    color: const Color(0xFF161B22),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Color(0xFF2B3240)),
    ),
  ),

  dividerTheme: const DividerThemeData(
    color: Color(0xFF2B3240),
    thickness: 1,
  ),

  chipTheme: ChipThemeData(
    backgroundColor: const Color(0xFF1B212B),
    selectedColor: const Color(0xFF244A7C),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    labelStyle: const TextStyle(color: Colors.white),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF161B22),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF2B3240)),
    ),
  ),
);