import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDark = false;

  bool get isDark => _isDark;
  
  set isDark(bool value) {
    _isDark = value;
    notifyListeners();
  }

}