import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
import 'package:stock_manager_app/screens/login.dart';

class SettingsScreen extends StatefulWidget{
  const SettingsScreen({super.key});

  @override
 SettingsScreenState createState() => SettingsScreenState();

}

class SettingsScreenState extends State<SettingsScreen>{

  static late SettingsScreenState state;

  bool themeSwitch = true;
  bool mailNotifSwitch = true;
  bool notifsSwitch = true;
  bool employesNotifsSwitch = false;

   void logout(BuildContext context){

     Navigator.of(context).pushReplacement(
        CustomPageTransistion(page: const LoginScreen(),duration: 500,type: PageTransitionType.leftToRightWithFade).maketransition()
    );
  }


  void toogleMailNotificationsPermissions(BuildContext context,bool value){

  }

  void toogleNotificationsPermissions(BuildContext context,bool value){


  }
  void toogleNotificationsEmployeesPermissions(BuildContext context,bool value){

  }

  void toggleTheme(bool value){

  }

  @override
  void initState() {
    super.initState();
    state = this;
  }
  
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
          alignment: Alignment.center,
          margin:  EdgeInsets.all(10.0),
          /* decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ), */
          height: MediaQuery.of(context).size.height*0.40,
          child: Column(
            children: [
            Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Expanded(child: ListTile(title:  Text('Thème Clair',style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.w500)),subtitle: Text('Changer de couleurs'),)),
             Switch(  
              
              onChanged: (value){
                toggleTheme(value);
                setState(() {
                  themeSwitch = value;
                });
              },  
              value: themeSwitch,  
              activeColor: Colors.white,  
              activeTrackColor: primaryColor,  
              inactiveThumbColor: Colors.white,  
              inactiveTrackColor: Colors.grey,  
            )
            ],
          ),),
          Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Expanded(child: ListTile(title:  Text('Alertes par mail',style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.w500)),subtitle: Text('Recevoir les alertes par mail'),)),
             Switch(  
              
              onChanged: (value){
                toogleMailNotificationsPermissions(context,value);
                setState(() {
                  mailNotifSwitch = value;
                });
              },  
              value: mailNotifSwitch,  
              activeColor: Colors.white,  
              activeTrackColor: primaryColor,  
              inactiveThumbColor: Colors.white,  
              inactiveTrackColor: Colors.grey,  
            )
            ],
          )),
          Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Expanded(child: ListTile(title:  Text('Alertes par notification',style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.w500)),subtitle: Text('Recevoir les alertes par notification'),)),
             Switch(  
              
              onChanged: (value){
                toogleNotificationsPermissions(context,value);
                setState(() {
                  notifsSwitch = value;
                });
              },  
              value: notifsSwitch,  
              activeColor: Colors.white,  
              activeTrackColor: primaryColor,  
              inactiveThumbColor: Colors.white,  
              inactiveTrackColor: Colors.grey,  
            )

            ],
          )),
          Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Expanded(child: ListTile(title:  Text('Alertes aux employés',style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.w500)),subtitle: Text('Envoyer également les alertes aux employés'),)),
             Switch(  
              onChanged: (value){
                toogleNotificationsEmployeesPermissions(context,value);
                setState(() {
                  employesNotifsSwitch = value;
                });
              },  
              value: employesNotifsSwitch,  
              activeColor: Colors.white,  
              activeTrackColor: primaryColor,  
              inactiveThumbColor: Colors.white,  
              inactiveTrackColor: Colors.grey,  
            )

            ],
          )),
          ],),
          ),
          Container(
          alignment: Alignment.center,
          margin:  EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          height: MediaQuery.of(context).size.height*0.40,
          child: Column(
            children: [
             Padding(padding: EdgeInsets.only(top: 5.0,left: 40.0), 
             child: Align(
              alignment: Alignment.topLeft,
              child: Text('Options de suppression', style: TextStyle(color: Colors.red,fontSize: 18.0,fontWeight: FontWeight.w500),),
             ) ,),
             Expanded(
              child: ListTile(
                title:  Text('Supprimer tous les produits',style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.w500)),
                subtitle: Text('Supprimer définitivement tous les produits enregistrés',),
                onTap: (){},)),
             Expanded(
              child: ListTile(
                title:  Text('Supprimer tous les stocks',style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.w500)),
                subtitle: Text('Supprimer définitivement tous les stocks enregistrés',),
                onTap: (){},)),
             Expanded(
              child: ListTile(
                title:  Text('Supprimer mon compte',style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.w500)),
                subtitle: Text('Supprimer définitivement le compte et avec toutes mes données ',),
                onTap: (){},)),

          ],),
          ),
      ]),),
    );
  }

}