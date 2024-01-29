import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/notifications.dart';
import 'package:stock_manager_app/models/stock.dart';
import 'package:stock_manager_app/screens/stocks/stock_details.dart';
import 'package:stock_manager_app/styles/colors.dart';

class NotificationCard extends StatefulWidget{
  const NotificationCard({super.key, required this.notification,required this.stock});
  final StockNotification notification;
  final Stock? stock;
  
  @override
 NotificationCardState createState() => NotificationCardState(notification: notification, stock: stock);
}

class NotificationCardState extends State<NotificationCard>{
  NotificationCardState({required this.notification,required this.stock});
  final StockNotification notification;
  final Stock? stock;

  updateNotificationViewState(StockNotification notification) async {
    await stockManagerdatabase.updateNotification(notification);
  }

  @override
  Widget build(BuildContext context) {

   DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(notification.saveddate.toString());
  var inputDate = DateTime.parse(parseDate.toString());
  var saveddatedateformat = DateFormat("dd/MM/yyyy HH:mm");
  String saveddate  = saveddatedateformat.format(inputDate);

    return   GestureDetector(
      onTap: (){
        setState(() {
          notification.viewed = true;
        });
        updateNotificationViewState(notification);

          if(stock!=null){
            Navigator.of(context).push(
              CustomPageTransistion(page: StockDetailScreen(stock:stock!,canDelete: false,),duration: 500).maketransition()
            );
          }else{
            ToastMessage(message: "Le stock lié a cette notification a été supprimé.");
          }

      },
      child: Card(
      color: !notification.viewed ? secondaryColor : null,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4),
  ),
  clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.all(5.0),
      child: Padding(padding: const EdgeInsets.all(10.0),child: Column(
        children: [
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
       const Icon(Icons.notifications,size: 30.0,color: primaryColor,),
            Expanded(child: 
              SizedBox(
                width: 150,
                child: 
             ListTile(
              title: Text(notification.title,style: const TextStyle(fontWeight: FontWeight.w500,color: primaryColor)),
              subtitle: Text(notification.content,style: !notification.viewed ? TextStyle(color: Colors.white,fontWeight: FontWeight.w500) : null,),
             ),
              )) ,
          /* IconButton(onPressed: (){

          }, icon: Icon(Icons.read_more)) */
        ],
      ),
      Align(alignment: Alignment.topRight,child: Text(saveddate,style:  TextStyle(fontSize: 12.0,color: !notification.viewed ? Colors.white : null,fontWeight: !notification.viewed ? FontWeight.w500 : FontWeight.normal),),),
        ],
      ),),
    ),
    );
  }

}