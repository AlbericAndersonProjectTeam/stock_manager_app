import 'package:flutter/material.dart';
import 'package:stock_manager_app/styles/colors.dart';

ThemeData customThemeLight = ThemeData(
  
        //AppBar theme/style
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: primaryColor,
          titleTextStyle:  TextStyle(
          color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
          iconTheme: IconThemeData(
            size: 30.0,
            color: Colors.white
          )

        ),



        //Drawer theme/style
        drawerTheme: const DrawerThemeData(
          backgroundColor: secondaryColor,
          
        ),
        
        //Button theme/style
        buttonTheme: const ButtonThemeData(
          buttonColor: primaryColor,
          textTheme: ButtonTextTheme.normal
        ),


        //Floating action Button theme/style
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),


        //IconButton theme/style
        iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(
          foregroundColor: primaryColor,
          iconSize: 30.0
        )),

        elevatedButtonTheme:  ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
          ),
        ),


        //Card theme/style
        cardTheme: const CardTheme(
          shape: BeveledRectangleBorder(),
        ),


        //brightness 
        brightness: Brightness.light,

        useMaterial3: true,
      );


ThemeData customThemeDark = ThemeData(
  
        //AppBar theme/style
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: primaryColor,
          titleTextStyle:  TextStyle(
          color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          ),
          iconTheme: IconThemeData(
            size: 30.0,
            color: Colors.white
          )

        ),


        
        //Button theme/style
        buttonTheme: const ButtonThemeData(
          buttonColor: primaryColor,
          textTheme: ButtonTextTheme.normal
        ),


        //Floating action Button theme/style
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),


        //IconButton theme/style
        iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(
          foregroundColor: primaryColor,
          iconSize: 30.0
        )),

        elevatedButtonTheme:  ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
          ),
        ),


        //Card theme/style
        cardTheme: const CardTheme(
          shape: BeveledRectangleBorder(),
        ),


        //brightness 
        brightness: Brightness.dark,

        useMaterial3: true,
      );