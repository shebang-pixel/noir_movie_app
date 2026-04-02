import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // store
  bool isDarkMode = false;

  // fuuction to toggle
  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Noir Movie App',
      // define themes
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      // toggle theme
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MainScreen(isDarkMode: isDarkMode, onThemeChanged: toggleTheme),
    );
  }

}
