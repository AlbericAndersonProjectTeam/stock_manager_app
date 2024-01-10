import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/logo.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/user.dart';
import 'package:stock_manager_app/screens/employees/create_employee.dart';
import 'package:stock_manager_app/screens/employees/employees_body.dart';
import 'package:stock_manager_app/screens/home.dart';
import 'package:stock_manager_app/widgets/about_body.dart';
import 'package:stock_manager_app/widgets/help_body.dart';
import 'package:stock_manager_app/widgets/settings_body.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/widgets/product_body.dart';
import 'package:stock_manager_app/widgets/stock_body.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget{
  const CustomDrawer({super.key,required this.connectedUser,required this.boutiquename});
  final dynamic connectedUser;
  final String boutiquename;

  @override
  Widget build(BuildContext context) {
  return Drawer(
    backgroundColor: secondaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            alignment: Alignment.center,
            color: primaryColor,
            padding: const EdgeInsets.only(left : 20.0,top: 20.0),
            constraints : BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.32) ,
            child: 
         Column(
            children: [
             Row(
              children: [
                logoStockManager,
                Expanded(child: 
                 ListTile(
                title: const Text('Stock Manager',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white),),
                subtitle: Text(boutiquename,style: const TextStyle(fontSize: 15.0,color: Colors.white),),
              ),
                )
              ],
             ),
          Align(
          alignment: Alignment.centerLeft,
          child: Text(
              '${connectedUser.firstname} ${connectedUser.name}',
              style: const TextStyle(fontSize: 25.0,color: Colors.white),
            ),
          ), 
          Align(
          alignment: Alignment.centerLeft,
          child:   Text( connectedUser is Owner ?'Compte propriétaire' : (connectedUser.role=="admin" ? 'Compte assistant/administrateur': 'Compte assistant/employé'),style: const TextStyle(color: Colors.white),)
          ),
          Align(
          alignment: Alignment.centerRight,
          child:  SizedBox(
            width: 100.0,
            child: 
            TextButton(
              onPressed: () async {

                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                            CustomPageTransistion(page:  UserCreateScreen(iscreate: false,justview: true,isconnectedUser: true, user: connectedUser,),duration: 500).maketransition()
                          );
              }, child: 
           const Row(
            mainAxisAlignment: MainAxisAlignment.end,
              children: [
                 Text('Profil',style: TextStyle(color: Colors.white),),
                Icon(Icons.arrow_right,color: Colors.white,)
              ],
            )
            ),)
          ),
            ],
          )),
          ListTile(
            leading: const Icon(Icons.shopping_cart,color: primaryColor,),
            title: const Text(
              'Produits',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,),
            ),
            onTap: () {
              Navigator.of(context).pop();
              HomeScreenState.state.changeBody("Produits", const ProductBody());
            },
          ),
          ListTile(
            leading: const Icon(Icons.store,color: primaryColor,),
            title: const Text(
              'Stocks',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,),
            ),
            onTap: () {
              Navigator.of(context).pop();
              HomeScreenState.state.changeBody("Stocks", const StockBody());
            },
          ),
          ListTile(
            leading: const Icon(Icons.people,color: primaryColor,),
            title: const Text(
              'Assistants',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,),
            ),
            subtitle: const Text('Administrateurs et employés'),
            onTap: () {
              Navigator.of(context).pop();
              HomeScreenState.state.changeBody("Assistants", EmployeeHomeScreen());
            },
          ),
          const Divider(
            height: 10,
            thickness: 1,
            color: primaryColor,
          ),
          connectedUser is Owner ? ListTile(
            leading: const Icon(Icons.settings,color: primaryColor,),
            title: const Text(
              'Paramètres',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,),
            ),
            onTap: () {
              Navigator.of(context).pop();
             HomeScreenState.state.changeBody("Paramètres", SettingsScreen());
            },
          ) : Container(),
          ListTile(
            leading: const Icon(Icons.help,color: primaryColor,),
            title: const Text(
              'Aide',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,),
            ),
            onTap: () {
              Navigator.of(context).pop();
             HomeScreenState.state.changeBody("Aide", HelpScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy,color: primaryColor,),
            title: const Text(
              'Politique de confidentialité et de sécurité',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,),
            ),
            onTap: () async {
              Navigator.of(context).pop();
              final Uri url = Uri.parse('https://github.com/AlbericAndersonProjectTeam/stock_manager_app/blob/main/README.md#politique-de-confidentialit%C3%A9-et-de-s%C3%A9curit%C3%A9');

                try {
                   await launchUrl(url);
                } catch (e) {
                    ToastMessage(message: "Action impossible sur cet appareil.").showToast();
                }
              
            },
          ),
          ListTile(
            leading: const Icon(Icons.info,color: primaryColor,),
            title: const Text(
              'A propos',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,),
            ),
            onTap: () {
              Navigator.of(context).pop();
             HomeScreenState.state.changeBody("A Propos", AboutScreen());
            },
          ),
        ],
      ),
    );
  }

}