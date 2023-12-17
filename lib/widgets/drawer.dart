import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/logo.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
import 'package:stock_manager_app/screens/employees/create_employee.dart';
import 'package:stock_manager_app/screens/employees/employees_body.dart';
import 'package:stock_manager_app/screens/home.dart';
import 'package:stock_manager_app/widgets/settings_body.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/widgets/product_body.dart';
import 'package:stock_manager_app/widgets/stock_body.dart';

class CustomDrawer extends StatelessWidget{
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
  return Drawer(
    backgroundColor: secondaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.32,
            child: DrawerHeader(
          decoration: const BoxDecoration(color: primaryColor),
          child:
         Column(
            children: [
            const Row(
              children: [
                logoStockManager,
                Expanded(child: 
                 ListTile(
                title: Text('Stock Manager',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white),),
                subtitle: Text('Boutique des Jouets',style: TextStyle(fontSize: 15.0,color: Colors.white),),
              ),
                )
              ],
             ),
         const Align(
          alignment: Alignment.centerLeft,
          child: Text(
              'Jane Doe',
              style: TextStyle(fontSize: 30.0,color: Colors.white),
            ),
          ), 
        const  Align(
          alignment: Alignment.centerLeft,
          child:   Text('Compte propriétaire',style: TextStyle(color: Colors.white),)
          ),
          Align(
          alignment: Alignment.centerRight,
          child:  SizedBox(
            width: 100.0,
            child: 
            TextButton(
              onPressed: (){
                  Navigator.of(context).push(
                            CustomPageTransistion(page:  UserCreateScreen(iscreate: false,justview: true,),duration: 500).maketransition()
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
          )
          )),
          ListTile(
            leading: const Icon(Icons.shopping_cart,color: primaryColor,),
            title: const Text(
              'Mes produits',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,),
            ),
            onTap: () {
              Navigator.of(context).pop();
              HomeScreenState.state.changeBody("Mes Produits", const ProductBody());
            },
          ),
          ListTile(
            leading: const Icon(Icons.store,color: primaryColor,),
            title: const Text(
              'Mes stocks',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,),
            ),
            onTap: () {
              Navigator.of(context).pop();
              HomeScreenState.state.changeBody("Mes Stocks", const StockBody());
            },
          ),
          ListTile(
            leading: const Icon(Icons.people,color: primaryColor,),
            title: const Text(
              'Mes employés',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,),
            ),
            onTap: () {
              Navigator.of(context).pop();
              HomeScreenState.state.changeBody("Utilisateurs", EmployeeHomeScreen());
            },
          ),
          const Divider(
            height: 10,
            thickness: 1,
            color: primaryColor,
          ),
          ListTile(
            leading: const Icon(Icons.settings,color: primaryColor,),
            title: const Text(
              'Paramètres',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,),
            ),
            onTap: () {
              Navigator.of(context).pop();
             HomeScreenState.state.changeBody("Paramètres", SettingsScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.help,color: primaryColor,),
            title: const Text(
              'Aide',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,),
            ),
            onTap: () {
            },
          ),
          ListTile(
            leading: const Icon(Icons.policy,color: primaryColor,),
            title: const Text(
              'Politique de confidentialité et de sécurité',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,),
            ),
            onTap: () {
            },
          ),
          ListTile(
            leading: const Icon(Icons.info,color: primaryColor,),
            title: const Text(
              'A propos',
              style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500,),
            ),
            onTap: () {
            },
          ),
        ],
      ),
    );
  }

}