import 'package:flutter/material.dart';
import 'Widgets/HomePage.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent);

void main() {
  runApp(MaterialApp(
    home: const HomePage(),
    theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
        )),
  ));
}
