import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/delete_service.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/screens/login.dart';

class SettingsScreen extends StatefulWidget{
  const SettingsScreen({super.key});

  @override
 SettingsScreenState createState() => SettingsScreenState();

}

class SettingsScreenState extends State<SettingsScreen>{

  static SettingsScreenState? state;

  bool themeSwitch = true;
  bool mailNotifSwitch = false;
  bool notifsSwitch = true;
  bool employesNotifsSwitch = false;

   void logout(BuildContext context){

     Navigator.of(context).pushReplacement(
        CustomPageTransistion(page: const LoginScreen(),duration: 500,type: PageTransitionType.leftToRightWithFade).maketransition()
    );
  }


 updateSettings() async {
  await localstockManagerdatabase.updateSettings(SETTINGSSESSION);
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
          margin: const EdgeInsets.all(10.0),
          /* decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.all(Radius.circular(10.0))
          ), */
          height: MediaQuery.of(context).size.height*0.30,
          child: Column(
            children: [
           /*  Expanded(child: Row(
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
          ),), */
          Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            const Expanded(child: ListTile(title:  Text('Alertes par notification',style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.w500)),subtitle: Text('Recevoir les alertes par notification'),)),
             Switch(  
              
              onChanged: (value){
                setState(() {
                SETTINGSSESSION.notificationalert = value;
                });
                updateSettings();
              },  
              value: SETTINGSSESSION.notificationalert,  
              activeColor: Colors.white,  
              activeTrackColor: primaryColor,  
              inactiveThumbColor: Colors.grey,  
              inactiveTrackColor: Colors.white,  
            )

            ],
          )),
          Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            const Expanded(child: ListTile(title:  Text('Alertes par mail',style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.w500)),subtitle: Text('Recevoir les alertes par mail'),)),
             Switch(  
              
              onChanged: (value){
                setState(() {
                  mailNotifSwitch = true;
                });
                Future.delayed(const Duration(milliseconds: 500),(){

                setState(() {
                  mailNotifSwitch = false;
                });

                });
                ToastMessage(message: "Option indisponible pour le moment. Vous serez avertis dès qu'elle sera disponible.").showToast();
                updateSettings();
              },  
              value: mailNotifSwitch,  
              materialTapTargetSize: MaterialTapTargetSize.padded,
              activeColor: Colors.white,  
              activeTrackColor: primaryColor,  
              inactiveThumbColor: Colors.grey,  
              inactiveTrackColor: Colors.white,  
            )
            ],
          )),
          Expanded(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            const Expanded(child: ListTile(title:  Text('Alertes aux employés',style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.w500)),subtitle: Text('Envoyer également les alertes aux employés'),)),
             Switch(  
              onChanged: (value){
                setState(() {
                  employesNotifsSwitch = true;
                });
                Future.delayed(const Duration(milliseconds: 500),(){

                setState(() {
                  employesNotifsSwitch = false;
                });

                });
                 ToastMessage(message: "Option indisponible pour le moment. Vous serez avertis dès qu'elle sera disponible.").showToast();
                updateSettings();
              },  
              value: employesNotifsSwitch,  
              activeColor: Colors.white,  
              activeTrackColor: primaryColor,  
              inactiveThumbColor: Colors.grey,  
              inactiveTrackColor: Colors.white,  
            )

            ],
          )),
          ],),
          ),
          Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: const BorderRadius.all(Radius.circular(10.0))
          ),
          height: MediaQuery.of(context).size.height*0.50,
          child: Column(
            children: [
            const Padding(padding: EdgeInsets.only(top: 5.0,left: 40.0), 
             child: Align(
              alignment: Alignment.topLeft,
              child: Text('Options de suppression', style: TextStyle(color: Colors.red,fontSize: 18.0,fontWeight: FontWeight.w500),),
             ) ,),
             Expanded(
              child: ListTile(
                title: const Text('Supprimer tous les produits',style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.w500)),
                subtitle: const Text('Supprimer définitivement tous les produits enregistrés',),
                onTap: (){
                  DeleteService.showAllDeleteAlert(context, "Produit");
                },)),
             Expanded(
              child: ListTile(
                title: const Text('Supprimer tous les stocks',style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.w500)),
                subtitle: const Text('Supprimer définitivement tous les stocks enregistrés',),
                onTap: (){
                  DeleteService.showAllDeleteAlert(context, "Stock");
                },)),
              Expanded(
              child: ListTile(
                title:  const Text('Supprimer tous les assistants',style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.w500)),
                subtitle: const Text('Supprimer définitivement les comptes de tous mes assistants ',),
                onTap: (){
                  DeleteService.showAllDeleteAlert(context, "Assistant");
                },)),
             Expanded(
              child: ListTile(
                title: const Text('Supprimer mon compte',style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.w500)),
                subtitle: const Text('Supprimer définitivement le compte et avec toutes mes données ',),
                onTap: (){
                  
                  DeleteService.showAllDeleteAlert(context, "Votre Compte");
                
                },)),

          ],),
          ),
      ]),),
    );
  }

}