import 'package:flutter/material.dart';
import 'package:stock_manager_app/styles/colors.dart';

class DeleteService{

  static bool delete = false;
  
  static showDeleteAlert(BuildContext context, {String name= "Item name",bool fromDetailPage = false}) async{
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Suppression de $name"),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(5, 5))),
        content: Text('Confirmez-vous la suppression de $name ?'),
        actions: [
          TextButton(onPressed: (){
            delete = true;
            Navigator.of(context).pop();
            deleteItem(context);
          }, child:const Text('Oui',style: TextStyle(color: primaryColor,fontSize: 18.0),)),
          TextButton(onPressed: (){
            Navigator.of(context).pop();
            }, child:const Text('Non',style: TextStyle(color: primaryColor,fontSize: 18.0))),
        ],
      );
    });
  }

  static deleteItem(BuildContext context){

  }
}