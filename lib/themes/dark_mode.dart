
import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900, // Màu nền
    background: Colors.grey.shade700, // Màu nền tối hơn
    primary: Colors.grey.shade800, // Màu chính
    secondary: Colors.grey.shade600, // Màu phụ
    tertiary: Colors.grey.shade700, // Màu nhấn
    inversePrimary: Colors.white, // Màu đối lập cho chữ
    // inversePrimary: Colors.blueGrey.shade50, // Màu đối lập cho chữ
  ),
  scaffoldBackgroundColor: Colors.grey.shade900, // Màu nền của Scaffold
);
