import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/models/user.dart';
import 'package:stock_manager_app/providers/notifications.dart';
import 'package:stock_manager_app/screens/notifications.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/widgets/drawer.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/screens/login.dart';
import 'package:stock_manager_app/widgets/product_body.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
 HomeScreenState createState() => HomeScreenState();

}

class HomeScreenState extends State<HomeScreen>{

  String title = "Produits";
  Widget homeBody = const ProductBody();
  static late HomeScreenState state;
  Owner owner = Owner.simple() ;
  var connectedUSer;
  String lastMessage = "";
  bool newnotification = false;

  NewNotificationNotifier notificationNotifier = NewNotificationNotifier();

   HomeScreenState() {
   stockManagerNotificationService.messageStreamController.listen((message) {
     if(mounted){
      setState(() {
       if (message.notification != null) {
         lastMessage = 'Received a notification message:'
             '\nTitle=${message.notification?.title},'
             '\nBody=${message.notification?.body},'
             '\nData=${message.data}';
       } else {
         lastMessage = 'Received a data message: ${message.data}';
       }

       newnotification = true;
     });
     }
    ToastMessage(message: "Nouvelle notification : $lastMessage");
   });
  }

  refresh(newconnecteduser,newowner)async {
    print("refresh for drawer");
      setState(() {
        owner = newowner;
        connectedUSer = newconnecteduser;
      });
  }


 void logout(BuildContext context){
     showDialog(context: context, builder: (dialogcontext){
       return StatefulBuilder(builder: (dialogcontext,setState){
        return AlertDialog(
        title: const Text("Etes vous sûr de vouloir vous déconnecter ?",style: TextStyle(fontSize: 20.0),),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(5, 5))),
        actions: [
          TextButton(onPressed: (){
        Navigator.of(context).pushReplacement(
            CustomPageTransistion(page: const LoginScreen(),duration: 500,type: PageTransitionType.leftToRightWithFade).maketransition()
        );
          }, child:  const Text('Oui',style: TextStyle(color: primaryColor,fontSize: 18.0),)),
          TextButton(onPressed: (){
            Navigator.of(dialogcontext).pop();
            }, child:const Text('Non',style: TextStyle(color: primaryColor,fontSize: 18.0))),
        ],
      );
      });
    });
  }



  void changeBody(String newTitle,Widget newBody){
    if(mounted){
      setState(() {
      title = newTitle;
      homeBody = newBody;
    });
    }
  }

  loadData() async {
     try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ownerId =  prefs.getString('ownerId')!;
      owner =  await stockManagerdatabase.getUserWithId(ownerId,"Owner");
      String userId =  prefs.getString('loggedUserId')!;
      if(prefs.getInt('isOwner')! == 0){
        connectedUSer =  await stockManagerdatabase.getUserWithId(userId,"Employee");
      }else{
        connectedUSer = owner;
      }
     } catch (e) {
       print(e);
       ToastMessage(message: "Une erreur s'est produite.");
     }
  }

  @override
  void initState() {
    super.initState();
    state = this;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadData();
         if(mounted){
        setState(() { });    
     }   
    });
  }
  
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(title),
      actions: [
        IconButton(onPressed: (){
          Navigator.of(context).push(
                            CustomPageTransistion(page: const NotificationsScreen(),duration: 500).maketransition()
                          ).then((value){
                            setState(() {
                               newnotification = false;
                            });
                          });
        }, icon: newnotification ?  const Icon(Icons.notifications_on,color: secondaryColor,)  : const Icon(Icons.notifications) ),

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
      drawer:  CustomDrawer(connectedUser:connectedUSer,boutiquename: owner.boutique,),
      body: homeBody,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}