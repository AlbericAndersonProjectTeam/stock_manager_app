import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:stock_manager_app/screens/splash.dart';
import 'package:stock_manager_app/styles/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Manager',
      theme: customTheme,
      home: const SplashScreen(),
       localizationsDelegates: const [ //Month Year picker cause
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}