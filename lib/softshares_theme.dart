import 'package:flutter/material.dart';

class SoftSharesTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromRGBO(29, 90, 161, 1),
        secondary: const Color.fromRGBO(4, 101, 217, 1),
        background: const Color.fromRGBO(29, 90, 161, 1)),
    canvasColor: const Color.fromRGBO(230, 230, 230, 1),
    cardColor: const Color.fromRGBO(230, 230, 230, 1),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(230, 230, 230, 1),
      centerTitle: true,
      actionsIconTheme: IconThemeData(
        color: Color.fromRGBO(29, 90, 161, 1),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(
            color: Color.fromRGBO(29, 90, 161, 1),
          );
        }
        return const IconThemeData(
          color: Color.fromRGBO(37, 37, 37, 1),
        );
      }),
      indicatorColor: Colors.transparent,
      backgroundColor: const Color.fromRGBO(230, 230, 230, 1),
    ),
  );
}
