import 'package:flutter/material.dart';
import 'package:flutter_book_app/splash.dart';
import 'package:flutter_book_app/theme/theme_config.dart';
import 'package:flutter_book_app/utils/providers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: Constants.appName,
            theme: themeData(
              notifier.dark! ? Constants.darkTheme : Constants.lightTheme,
            ),
            home: Splash(),
          );
        },
      ),
    );
  }
}


// Apply font to our app's theme
ThemeData themeData(ThemeData theme) {
  return theme.copyWith(
    textTheme: GoogleFonts.robotoMonoTextTheme(
      theme.textTheme,
    ),
  );
}
