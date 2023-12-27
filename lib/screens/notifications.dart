import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/onprocess_error.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/notifications.dart';
import 'package:stock_manager_app/models/stock.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget{
  const NotificationsScreen({super.key});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();

}

class NotificationsScreenState extends State<NotificationsScreen>{

  List<Map<String,dynamic>> notificationswithstock = [];
  
  loadNotificationsWithStock() async{
    //load notifs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId =  prefs.getString('ownerId')!;
    List<StockNotification> gotnotifications = [];
    try {
     gotnotifications = await stockManagerdatabase.getAllNotifications(ownerId);
     notificationswithstock = [];
     for (var notification in gotnotifications) {
       Stock? stock = await stockManagerdatabase.getOneStock(notification.stockId);
       notificationswithstock.add({"notification": notification,"stock" : stock});
     }
    } catch (e) {
      ToastMessage(message: "Une erreur s'est produite.").showToast();
      print(e);
    }

    //saved data to session
    DATACONSTANTSOFSESSION.notificationswithstock = notificationswithstock;
    
    return notificationswithstock;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        leading: BackButton(),
      ),
      body: 
        FutureBuilder(
          future: loadNotificationsWithStock(), builder: (context,snapshot){
            return snapshot.hasData && snapshot.data != null ? NotificationList(notificationswithstock:notificationswithstock) : snapshot.connectionState == ConnectionState.waiting && snapshot.hasData==false ? 
           (DATACONSTANTSOFSESSION.notificationswithstock != null ? NotificationList(notificationswithstock:DATACONSTANTSOFSESSION.notificationswithstock!) : const OnProcess()) : snapshot.hasError ? const ErrorFetchingData() :Container() ; // Container() après
          }),
    );

  }

}


class NotificationList extends StatelessWidget{
  const NotificationList({super.key,required this.notificationswithstock});
  final List<Map<String,dynamic>> notificationswithstock ;
  @override
  Widget build(BuildContext context) {
   return notificationswithstock.isNotEmpty ?  ListView.builder(
    itemCount: notificationswithstock.length,
    itemBuilder: (context,index){
      return NotificationCard(
        notification:notificationswithstock[index]['notification'],
        stock: notificationswithstock[index]['stock'],
        );
   }) :  Container(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/Images/Bg_aucun_stock.png",width: 250.0,),
        const Text('Aucune notification',style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),)
      ],
    ),
   );
  }

}