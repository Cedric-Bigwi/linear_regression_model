import 'package:flutter/material.dart';

// ivory paper, forest green, antique gold, burgundy for errors
const ivory = Color(0xFFF6F1E7);
const paper = Color(0xFFFFFCF5);
const forest = Color(0xFF1F3B2D);
const gold = Color(0xFFB08D57);
const ink = Color(0xFF22302A);
const muted = Color(0xFF7A7667);
const burgundy = Color(0xFF6E1F2B);
const roseTint = Color(0xFFF6E7E7);
const goldLine = Color(0x66B08D57);

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: forest,
    onPrimary: ivory,
    secondary: gold,
    surface: paper,
    onSurface: ink,
    error: burgundy,
  ),
  scaffoldBackgroundColor: ivory,
  fontFamily: 'Georgia',
  fontFamilyFallback: const ['serif'],
);

InputDecoration fieldDecoration(String label, String hint) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(color: muted),
    floatingLabelStyle: const TextStyle(color: forest),
    hintStyle: const TextStyle(color: Color(0xFFB9B4A5)),
    filled: true,
    fillColor: ivory,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: goldLine),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: forest, width: 1.6),
    ),
  );
}

BoxDecoration cardBox(Color color, [Color border = goldLine]) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: border),
  );
}
