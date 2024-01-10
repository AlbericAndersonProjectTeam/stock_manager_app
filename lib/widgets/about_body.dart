import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/logo.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   SingleChildScrollView(
      child: Padding(padding: EdgeInsets.only(left: 20.0,top: MediaQuery.of(context).size.height*0.10),
      child:Column(
        children: [
          thicklogoStockManager,
         const SizedBox(height: 30.0,),
         const Text('Version 1.0.0'),
         const Text('Réalisé par la Team7'),
         const SizedBox(height: 50.0,),
         const Align(alignment: Alignment.topLeft,child: Text('Contactez et suivez-nous', style: TextStyle(color: primaryColor,fontSize: 20.0, fontWeight: FontWeight.w500,),),),
         const Divider(),
          ListTile(
            
            title: const Text('Contactez nous'),
            leading: const Icon(Icons.email),
            onTap:() async {
              String title = "Contact depuis Stock Manager";
              String message= "";
              final Uri params = Uri(
                scheme: 'mailto',
                path: "contact.stockmanager@gmail.com",
                query: 'subject=$title&body=$message',
              );

                try {
                   await launchUrl(params);
                } catch (e) {
                    ToastMessage(message: "Action impossible sur cet appareil.").showToast();
                }
              
            },
          ),
          const Divider(),
          ListTile(
            
            title: const Text('Appelez nous'),
            leading: const Icon(Icons.call),
            onTap: () async {
               final Uri params = Uri(
                scheme: 'tel',
                path: "+229 98 75 41 25",
              );

             if(await canLaunchUrl(params)){
                 await launchUrl(params);
             }else{
              ToastMessage(message: "Action impossible sur cet appareil.").showToast();
             }
            },
          ),
          const Divider(),
          ListTile(
            
            title: const Text('Suivez nous sur facebook'),
            leading: const Icon(Icons.facebook),
            onTap: (){
               ToastMessage(message: "Action non disponible pour le moment. Merci !").showToast();
            },
          ),
        ],
      ) ,
      ),
    );
  }
  
}