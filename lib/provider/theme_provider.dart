import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Default to light theme
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    print("Dark Mode Toggled: $_isDarkMode");  
    notifyListeners(); // Notify listeners (UI) to rebuild
  }
}
