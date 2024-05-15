import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        color: Color.fromRGBO(37, 37, 37, 1),
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
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.lato(),
      bodyMedium: GoogleFonts.lato(),
      bodySmall: GoogleFonts.lato(),
      labelLarge: GoogleFonts.lato(),
      displayLarge: GoogleFonts.lato(),
      displaySmall: GoogleFonts.lato(),
      displayMedium: GoogleFonts.lato(),
      headlineLarge: GoogleFonts.lato(),
      headlineMedium: GoogleFonts.lato(),
      headlineSmall: GoogleFonts.lato(),
      labelMedium: GoogleFonts.lato(),
      labelSmall: GoogleFonts.lato(),
      titleLarge: GoogleFonts.lato(),
      titleMedium: GoogleFonts.lato(),
      titleSmall: GoogleFonts.lato(),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color.fromRGBO(230, 230, 230, 1),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    ),
  );
}
