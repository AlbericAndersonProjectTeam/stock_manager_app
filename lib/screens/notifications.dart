import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/onprocess_error.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget{
  const NotificationsScreen({super.key});

  @override
  NotificationsScreenState createState() => NotificationsScreenState();

}

class NotificationsScreenState extends State<NotificationsScreen>{

  List notifications = [1,2,3];
  loadNotifications() async{
    //load notifs

    notifications = [1,2,3,4];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        leading: BackButton(),
      ),
      body: 
        FutureBuilder(future: loadNotifications(), builder: (context,snapshot){
            return snapshot.hasData && snapshot.data != null ? NotificationList(notifs:notifications) : snapshot.connectionState == ConnectionState.waiting && snapshot.hasData==false ? const 
            OnProcess() : snapshot.hasError ? const ErrorFetchingData() : NotificationList(notifs:notifications) ; // Container() après
          }),
    );

  }

}


class NotificationList extends StatelessWidget{
  const NotificationList({super.key,required this.notifs});
  final List  notifs;
  @override
  Widget build(BuildContext context) {
   return notifs.isNotEmpty ?  ListView.builder(
    itemCount: notifs.length,
    itemBuilder: (context,index){
      return const NotificationCard();
   }) :  Container(
    width: MediaQuery.of(context).size.width,
    color: secondaryColor,
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