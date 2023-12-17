import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stock_manager_app/screens/notifications.dart';
import 'package:stock_manager_app/widgets/drawer.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
import 'package:stock_manager_app/screens/login.dart';
import 'package:stock_manager_app/widgets/product_body.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
 HomeScreenState createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen>{

  String title = "Mes Produits";
  Widget homeBody = const ProductBody();
  static late HomeScreenState state;

  void logout(BuildContext context){

     Navigator.of(context).pushReplacement(
        CustomPageTransistion(page: const LoginScreen(),duration: 500,type: PageTransitionType.leftToRightWithFade).maketransition()
    );
  }

  void changeBody(String newTitle,Widget newBody){
    if(mounted){
      setState(() {
      title = newTitle;
      homeBody = newBody;
    });
    }
  }

  @override
  void initState() {
    super.initState();
    state = this;
  }
  
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text(title),
      actions: [
        IconButton(onPressed: (){
          Navigator.of(context).push(
                            CustomPageTransistion(page: const NotificationsScreen(),duration: 500).maketransition()
                          );
        }, icon: const Icon(Icons.notifications)),
        IconButton(onPressed: (){
          logout(context);
        }, icon: const Icon(Icons.logout)),
       /*  PopupMenuButton(itemBuilder: (context){
          return [
           const PopupMenuItem<int>(
                      value: 0,
                      child: Text("Mes Produits"),
                  ),

            const   PopupMenuItem<int>(
                      value: 1,
                      child: Text("Mes Stocks"),
                  ),

             const     PopupMenuItem<int>(
                      value: 2,
                      child: Text("Employés"),
                  ),
          ];
        }) */
      ],
      ),
      drawer: const CustomDrawer(),
      body: homeBody,
    );
  }

}