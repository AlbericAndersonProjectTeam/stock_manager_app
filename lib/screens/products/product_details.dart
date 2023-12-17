
import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/delete_service.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
import 'package:stock_manager_app/screens/products/product_create_update.dart';
import 'package:stock_manager_app/styles/colors.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});
  
  @override
  Widget build(BuildContext context) {

    /* final format = DateFormat("yyyy-mm-dd"); */
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails Produit"),
        leading: const CloseButton(),
      ),
      body:  Padding(
        padding: EdgeInsets.only(left:10.0,right: 10.0,top: MediaQuery.of(context).size.height*0.10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           const Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.file_open,size: 30.0,),
                Text("Spaghettis",style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 30.0),),
              ],
            ),
             SizedBox(height: 20.0,),
              ListTile(
              leading: Icon(Icons.money),
              titleTextStyle:  TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title:  Text("Prix"),
              subtitle: Text("1000 FCFA"),
            ) , 
             ListTile(
              leading: Icon(Icons.date_range),
              titleTextStyle:  TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title: Text("Date de péremption"),
              subtitle: Text("20/10/2027"),
            ) ,
             ListTile(
              leading: Icon(Icons.description),
              titleTextStyle:  TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title: Text("Description"),
              subtitle: Text("In this tutorial, we will learn how to create beautiful and customizable card UI in Flutter."),
            ) ,
             SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: (){

             Navigator.of(context).push(
                            CustomPageTransistion(page: const  ProductCreateUpdateScreen(iscreate: false,),duration: 500).maketransition()
                          );

                   }, child: const Text('Modifier',style: TextStyle(color: Colors.white),)),
                  const SizedBox(width: 5.0,),
                 ElevatedButton(onPressed: () async {
                    Navigator.of(context).pop();
                    DeleteService.showDeleteAlert(context,name: "Spaghettis");
                  }, child: const Text('Supprimer',style: TextStyle(color: Colors.white),)),
                ],
            ),
          ],
        ),
      ),
    );
  }

}
