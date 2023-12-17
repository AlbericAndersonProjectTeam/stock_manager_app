
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class CustomPageTransistion{
  
  CustomPageTransistion({required this.page,this.duration = 600,this.type = PageTransitionType.rightToLeftWithFade});
  final Widget page;
  int duration ;
  PageTransitionType type ; 

  maketransition(){
    return PageTransition(child: page, type:type,duration: Duration(milliseconds: duration));
  }
}

class ToastMessage{
  ToastMessage({required this.message});
  String message;
  showToast(){

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}