import 'package:busybee/services/databse_helper.dart';
import 'package:busybee/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:busybee/pages/sign_in.dart';
import 'package:busybee/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_10y.dart' as tz;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DatabseHelper().reloadCurrentUser();
  Notifications().initialize();
  tz.initializeTimeZones();
  runApp(const MainApp(),);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
  debugShowCheckedModeBanner: false,
  themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
  theme: ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      titleLarge: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  ),
  darkTheme: ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      titleLarge: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
  ),
  home: SignIn(),
);
        },
      ),
    );
  }
}
