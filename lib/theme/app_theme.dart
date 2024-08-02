import 'package:blackhole/Helpers/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

// ignore: avoid_classes_with_only_static_members
class AppTheme {
  static MyTheme get currentTheme => GetIt.I<MyTheme>();
  static ThemeMode get themeMode => GetIt.I<MyTheme>().currentTheme();

  /// Used for app light theme
  static ThemeData lightTheme({
    required BuildContext context,
  }) {
    return ThemeData(
      fontFamily: 'SharpSans',
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: currentTheme.currentColor(),
        cursorColor: currentTheme.currentColor(),
        selectionColor: currentTheme.currentColor(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: currentTheme.currentColor()),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        backgroundColor: currentTheme.currentColor(),
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
      ),
      cardTheme: CardTheme(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      disabledColor: Colors.grey[600],
      brightness: Brightness.light,
      indicatorColor: currentTheme.currentColor(),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData().copyWith(color: currentTheme.currentColor()),
      iconTheme: IconThemeData(
        color: Colors.grey[800],
        opacity: 1.0,
        size: 24.0,
      ),
      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Colors.grey[800],
            brightness: Brightness.light,
            secondary: currentTheme.currentColor(),
          ),
      useMaterial3: false,
    );
  }

  /// used for app dark theme
  static ThemeData darkTheme({
    required BuildContext context,
  }) {
    return ThemeData(
      fontFamily: 'SharpSans',
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor:
            Colors.white.withOpacity(0.2), //currentTheme.currentColor(),
        cursorColor: const Color(0xFFFFFFFF), //currentTheme.currentColor(),
        selectionColor: Colors.white.withOpacity(0.2), // currentTheme.currentColor(),
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: currentTheme.currentColor()),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        color: currentTheme.getCanvasColor(),
        foregroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
      ),
      canvasColor: currentTheme.getCanvasColor(),
      cardColor: currentTheme.getCardColor(),
      cardTheme: CardTheme(
        clipBehavior: Clip.antiAlias,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      dialogBackgroundColor: Color(0xFF414042), //currentTheme.getCardColor(),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData().copyWith(color: Color(0xFFFFFFFF)),
      iconTheme: const IconThemeData(
        color: Colors.white,
        opacity: 1.0,
        size: 24.0,
      ),
      indicatorColor: Color(0xFFFFFFFF),

      colorScheme: Theme.of(context).colorScheme.copyWith(
            primary: Colors.white,
            secondary: Color(0xFFFFFFFF),
            brightness: Brightness.dark,
          ),
      useMaterial3: false,
    );
  }
}
