
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stock_manager_app/constants/data_constants.dart';
import 'package:stock_manager_app/constants/push_notification_service.dart';
import 'package:stock_manager_app/models/settings.dart';

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

const customCircularProcessIndicator =  SizedBox( width: 25, height: 25, child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3.0,));

const stockTransactionTypeVente = "Vente";

const stockTransactionTypeAchat = "Achat";

const stockTransactionTypeTransfer = "Transfert entre stocks";

StockManagerAppSettings SETTINGSSESSION = StockManagerAppSettings();

StockManagerNotificationService stockManagerNotificationService = StockManagerNotificationService();

DataConstantsOfSession DATACONSTANTSOFSESSION = DataConstantsOfSession();