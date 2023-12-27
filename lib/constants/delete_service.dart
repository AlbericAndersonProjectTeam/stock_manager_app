import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/constants/data_constants.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/product.dart';
import 'package:stock_manager_app/models/stock.dart';
import 'package:stock_manager_app/models/user.dart';
import 'package:stock_manager_app/screens/employees/employees_body.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/widgets/product_body.dart';
import 'package:stock_manager_app/widgets/settings_body.dart';
import 'package:stock_manager_app/widgets/stock_body.dart';

class DeleteService{

  
  static showDeleteAlert(BuildContext context, dynamic item , {bool fromDetailPage = false}) async{
    showDialog(context: context, builder: (dialogcontext){
      bool deletestarted = false;
      return StatefulBuilder(builder: (dialogcontext,setState){
        return AlertDialog(
        title: Text("Suppression de ${item.name}"),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(5, 5))),
        content: Text('Confirmez-vous la suppression de ${item.name} ?'),
        actions: [
          TextButton(onPressed: (){
            if(!deletestarted){
              setState(() {
              deletestarted = true;
            },);
            deleteItem(dialogcontext,item);
            }
          }, child:deletestarted ? const SizedBox( width: 25, height: 25, child: CircularProgressIndicator(color: primaryColor, strokeWidth: 3.0,))  : const Text('Confirmer',style: TextStyle(color: primaryColor,fontSize: 18.0),)),
          TextButton(onPressed: (){
            Navigator.of(dialogcontext).pop();
            }, child:const Text('Annuler',style: TextStyle(color: primaryColor,fontSize: 18.0))),
        ],
      );
      });
    });
  }

  static deleteItem(BuildContext dialogcontext,dynamic item) async {
        var result;
        String message="";
      try {
        if(item is Product){
         result =  await stockManagerdatabase.deleteOneProduct(item.id);

         if(DATACONSTANTSOFSESSION.products!=null){
          DATACONSTANTSOFSESSION.products!.removeWhere((element) => element.id==item.id);
         }

         message = "Produit supprimé avec succès.";
         ProductBodyState.state.refresh();
        }else if(item is Stock){
         result =  await stockManagerdatabase.deleteOneStock(item.id);


         if(DATACONSTANTSOFSESSION.stocks!=null){
          DATACONSTANTSOFSESSION.stocks!.removeWhere((element) => element.id==item.id);
         }


         message = "Stock supprimé avec succès.";
         StockBodyState.state.refresh();
        }else if(item is Employee){
          print('--employee----');

           result =  await stockManagerdatabase.deleteOneEmployee(item.id);

         if(DATACONSTANTSOFSESSION.employees!=null){
          DATACONSTANTSOFSESSION.employees!.removeWhere((element) => element.id==item.id);
         }

          SharedPreferences prefs = await SharedPreferences.getInstance();
          String ownerId =  prefs.getString('ownerId')!;

          var employees =  await stockManagerdatabase.getEmployee(ownerId);
          List<Employee> newadmins = [];
          List<Employee> newsimpleemployees = [];
          for (var employee in employees) {
              if(employee.role=="admin"){
                newadmins.add(employee);
              }else{
                newsimpleemployees.add(employee);
              }
          }
          EmployeeHomeScreenState.state!.refresh(newadmins, newsimpleemployees);
          message = "Assistant supprimé avec succès.";
        }
        ToastMessage(message: message).showToast();
        Navigator.of(dialogcontext).pop();
      } catch (e) {
        print(e);
        ToastMessage(message: "Une erreur est survenue. Veuillez réssayer.").showToast();

      }

      if(result==0){

      }
  }


  
  static showAllDeleteAlert(BuildContext context, String itemtype ) async{
    showDialog(context: context, builder: (dialogcontext){
      bool deletestarted = false;
      String appelation = itemtype != "Votre Compte" ? "tous les <<$itemtype>>" : "votre compte";
      return StatefulBuilder(builder: (dialogcontext,setState){
        return AlertDialog(
        title: const Text("Suppression massive de données"),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(5, 5))),
        content: Text('Attention : Cette action est irréversible.\n\nConfirmez-vous la suppression de $appelation ?'),
        actions: [
          TextButton(onPressed: (){
            if(!deletestarted){
              setState(() {
              deletestarted = true;
            },);
            deleteAllItem(context,dialogcontext,itemtype);
            }
          }, child:deletestarted ? const SizedBox( width: 25, height: 25, child: CircularProgressIndicator(color: primaryColor, strokeWidth: 3.0,))  : const Text('Confirmer',style: TextStyle(color: primaryColor,fontSize: 18.0),)),
          TextButton(onPressed: (){
            Navigator.of(dialogcontext).pop();
            }, child:const Text('Annuler',style: TextStyle(color: primaryColor,fontSize: 18.0))),
        ],
      );
      });
    });
  }

  static deleteAllItem(BuildContext context,BuildContext dialogcontext,String itemtype) async {
        var result;
        String message="";
      try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ownerId = prefs.getString('ownerId')!;
          if(itemtype!="Votre Compte"){
            if(itemtype == "Produit"){
          result =  await stockManagerdatabase.deleteAllProduct(ownerId);

          DATACONSTANTSOFSESSION.products = [];

          message = "Tous vos produits ont été supprimés avec succès.";
          }else if(itemtype == "Stock"){

          result =  await stockManagerdatabase.deleteAllStock(ownerId);

          DATACONSTANTSOFSESSION.stocks = [];

          message = "Tous vos stocks ont été supprimés avec succès.";
          }else if(itemtype == "Assistant"){
            print('--employee----');

            result =  await stockManagerdatabase.deleteAllEmployee(ownerId);

            DATACONSTANTSOFSESSION.employees = [];

            EmployeeHomeScreenState.state!.refresh([], []);
            message = "Tous les comptes de vos assistants ont été supprimés avec succès.";
          }
          ToastMessage(message: message).showToast();
          Navigator.of(dialogcontext).pop();
        }else{

            String userId = prefs.getString('loggedUserId')!;

            result =  await stockManagerdatabase.deleteOwnerAccount(userId);

            DATACONSTANTSOFSESSION = DataConstantsOfSession();

            if(true){
              SettingsScreenState.state!.logout(context);
            }
        }
      } catch (e) {
        print(e);
        ToastMessage(message: "Une erreur est survenue. Veuillez réssayer.").showToast();

      }

      if(result==0){

      }
  }
}