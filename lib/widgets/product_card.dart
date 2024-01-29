import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/delete_service.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/product.dart';
import 'package:stock_manager_app/screens/products/product_create_update.dart';
import 'package:stock_manager_app/screens/products/product_details.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/widgets/product_body.dart';

class ProductCard extends StatelessWidget{

  final Product product;
  final bool canDelete;
  const ProductCard({super.key,required this.product, required this.canDelete});


  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onTap: (){
          Navigator.of(context).push(
            CustomPageTransistion(page: ProductDetailScreen(product:product,canDelete: canDelete,),duration: 500).maketransition()
          ).then((value) => ProductBodyState.state.refresh());
      },
      child: Container(
      margin: const EdgeInsets.symmetric(vertical : 5.0,horizontal: 10.0),
      padding: const EdgeInsets.all(0),
        child: Card(
          elevation: 3.0,
          margin: const EdgeInsets.all(0.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4),
  ),
  clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(padding: const EdgeInsets.all(10.0),child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
       const ImageIcon(AssetImage("assets/Icones/Produit2.png"), color: primaryColor,),
             Expanded(child: 
              SizedBox(
                width: 150,
                child: 
             ListTile(
              title: Text(product.name,style: const TextStyle(fontWeight: FontWeight.w500,color: primaryColor)),
              subtitle: Text("${product.description}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: primaryColor),
              maxLines: 1,),
             ),
              )) ,
          PopupMenuButton(
            iconColor : primaryColor,
            itemBuilder: (context){
          return [
            const  PopupMenuItem<int>(
                      value: 0,
                      child: Row(children: [
                        Icon(Icons.remove_red_eye,color: primaryColor,),
                        SizedBox(width: 5.0,),
                        Text('Voir',style: TextStyle(color: primaryColor),)
                      ]),
                  ),
            const PopupMenuItem<int>(
                      value: 1,
                      child: Row(children: [
                        Icon(Icons.edit,color: primaryColor,),
                        SizedBox(width: 5.0,),
                        Text('Modifier',style: TextStyle(color: primaryColor),)
                      ]),
                  ),

            PopupMenuItem<int>(
                      value: 2,
                      enabled: canDelete,
                      child: const Row(children: [
                        Icon(Icons.delete,color: primaryColor,),
                        SizedBox(width: 5.0,),
                        Text('Supprimer',style: TextStyle(color: primaryColor),)
                      ]),
                  ),
          ];
        },
        onSelected: (value) {
          if(value == 0){
            Navigator.of(context).push(
               CustomPageTransistion(page:  ProductDetailScreen(product:product,canDelete: canDelete,),duration: 500).maketransition()
            );
          }
           if(value == 1){
             Navigator.of(context).push(
                            CustomPageTransistion(page:  ProductCreateUpdateScreen(iscreate: false,product:product),duration: 500).maketransition()
                          );
          }
           if(value == 2){
              DeleteService.showDeleteAlert(context,product);
          
          }
           
        },
        
        )
        ],
      ),),
    ),
      ),
    );
  }

}