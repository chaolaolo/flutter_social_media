// import 'package:flutter/material.dart';
//
// ThemeData lightMode = ThemeData(
//   colorScheme: ColorScheme.light(
//     background: Colors.grey.shade300,
//     primary: Colors.grey.shade500,
//     secondary: Colors.grey.shade200,
//     tertiary: Colors.white,
//     inversePrimary: Colors.grey.shade900,
//   ),
// );



import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    background: Colors.white, // Màu nền sáng hơn
    primary: Colors.blueGrey.shade300, // Màu chính nhẹ hơn
    secondary: Colors.blueGrey.shade100, // Màu phụ
    tertiary: Colors.grey.shade200, // Màu nhấn
    inversePrimary: Colors.black, // Màu đối lập cho chữ
  ),
);