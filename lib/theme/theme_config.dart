import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constants {
  //App related strings
  static String appName = "Flutter Book App";

  //Colors for theme
  static Color lightPrimary = Color(0xfff3f4f9);
  static Color darkPrimary = Color(0xff2B2B2B);

  static Color lightAccent = Colors.purple[900]!;

  static Color darkAccent = Colors.blue[500]!;

  static Color lightBG = Color(0xfff3f4f9);
  static Color darkBG = Color(0xff2B2B2B);

  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightPrimary,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: lightAccent,
    ),
    accentColor: lightAccent,
    scaffoldBackgroundColor: lightBG,
    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 0.0,
      color: lightBG,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      textTheme: TextTheme(
        headline6: GoogleFonts.robotoSlab(
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: darkBG,
    primaryColor: darkPrimary,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: darkAccent,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      elevation: 0.0,
      color: darkBG,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0.0,
      textTheme: TextTheme(
        headline6: GoogleFonts.robotoSlab(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class ThemeNotifier extends ChangeNotifier {
  final String key = 'theme';
  SharedPreferences? _prefs;
  bool? _darkTheme;
  bool? get dark => _darkTheme;

  ThemeNotifier() {
    _darkTheme = true;
    _loadfromPrefs();
  }
  toggleTheme(){
    _darkTheme = !_darkTheme!;
    _saveToPrefs();
    notifyListeners();
  }

  
  _loadfromPrefs()async{
    _darkTheme = _prefs!.getBool(key);
    notifyListeners();
  }
  _saveToPrefs()async{
    _prefs!.setBool(key, _darkTheme!);
  }
}

