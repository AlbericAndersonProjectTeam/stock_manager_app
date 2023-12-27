import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stock_manager_app/constants/delete_service.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/product.dart';
import 'package:stock_manager_app/providers/product.dart';
import 'package:stock_manager_app/screens/products/product_create_update.dart';
import 'package:stock_manager_app/styles/colors.dart';


class ProductDetailScreen extends StatelessWidget{
  final Product product;
  final bool canDelete;
  const ProductDetailScreen({super.key, required this.product,required this.canDelete});
  
  @override
  Widget build(BuildContext context) {


  ProductUpdateNotifier productUpdateNotifier = ProductUpdateNotifier();
  productUpdateNotifier.setProduct(product);
    return ChangeNotifierProvider<ProductUpdateNotifier>(create: (context){
      return productUpdateNotifier;
    },
    child: Scaffold(
      appBar: AppBar(
        title: const Text("Détails Produit"),
        leading: const CloseButton(),
      ),
      body:  Padding(
        padding: EdgeInsets.only(left:10.0,right: 10.0,top: MediaQuery.of(context).size.height*0.10),
        child: SingleChildScrollView(child: Consumer<ProductUpdateNotifier>(
          builder: (context,model,child){
            Product productToShow = model.product;
            
            var outputDate = "Aucune";
            if(product.expireddate !=null){
              DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(productToShow.expireddate.toString());
              var inputDate = DateTime.parse(parseDate.toString());
              var outputFormat = DateFormat('dd/MM/yyyy');
              outputDate = outputFormat.format(inputDate);
            }

            print(outputDate);

            return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
               const Icon(Icons.file_open,size: 30.0,),
                Text(productToShow.name,style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 30.0),),
              ],
            ),
            const  SizedBox(height: 20.0,),
              ListTile(
              leading: const Icon(Icons.money),
              titleTextStyle: const  TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title: const Text("Prix"),
              subtitle: Text("${productToShow.price} francs CFA"),
            ) , 
             ListTile(
              leading: const Icon(Icons.remove_shopping_cart),
              titleTextStyle:   const TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title: const Text("Seuil"),
              subtitle: Text("${productToShow.seuil}"), 
            ) ,
             ListTile(
              leading: const Icon(Icons.date_range),
              titleTextStyle:   const TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title: const Text("Date de péremption"),
              subtitle: Text(outputDate), 
            ) ,
             ListTile(
              leading: const Icon(Icons.description),
              titleTextStyle: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title: const Text("Description"),
              subtitle: Text(productToShow.description),
            ) ,
             ListTile(
              leading: const Icon(Icons.person),
              titleTextStyle: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title: const Text("Enregistré par"),
              subtitle: Text(productToShow.userName),
            ) ,
           const  SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: (){

             Navigator.of(context).push(
                            CustomPageTransistion(page:  ProductCreateUpdateScreen(iscreate: false,productModel:model),duration: 500).maketransition()
                          );

                   }, child: const Text('Modifier',style: TextStyle(color: Colors.white),)),
                  const SizedBox(width: 5.0,),
                 canDelete ?  ElevatedButton(onPressed: () async {
                    Navigator.of(context).pop();
                    DeleteService.showDeleteAlert(context,productToShow);
                  }, child: const Text('Supprimer',style: TextStyle(color: Colors.white),)) : Container(),
                ],
            ),
          ],
        );
        },),
      ),),
    ),
    );
  }
 

}
