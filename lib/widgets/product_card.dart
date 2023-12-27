import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/delete_service.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/product.dart';
import 'package:stock_manager_app/screens/products/product_create_update.dart';
import 'package:stock_manager_app/screens/products/product_details.dart';
import 'package:stock_manager_app/widgets/product_body.dart';

class ProductCard extends StatelessWidget{

  final Product product;
  final bool canDelete;
  const ProductCard({super.key,required this.product, required this.canDelete});


  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onDoubleTap: (){
          Navigator.of(context).push(
            CustomPageTransistion(page: ProductDetailScreen(product:product,canDelete: canDelete,),duration: 500).maketransition()
          ).then((value) => ProductBodyState.state.refresh());
      },
      child: Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4),
  ),
  clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.symmetric(vertical : 5.0,horizontal: 10.0),
      child: Padding(padding: const EdgeInsets.all(10.0),child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
       const Icon(Icons.file_open,size: 30.0,),
             Expanded(child: 
              SizedBox(
                width: 150,
                child: 
             ListTile(
              title: Text(product.name,style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text("${product.description}",
                    overflow: TextOverflow.ellipsis,
              maxLines: 1,),
             ),
              )) ,
          PopupMenuButton(
            itemBuilder: (context){
          return [
            const  PopupMenuItem<int>(
                      value: 0,
                      child: Row(children: [
                        Icon(Icons.remove_red_eye),
                        SizedBox(width: 5.0,),
                        Text('Voir')
                      ]),
                  ),
            const PopupMenuItem<int>(
                      value: 1,
                      child: Row(children: [
                        Icon(Icons.edit),
                        SizedBox(width: 5.0,),
                        Text('Modifier')
                      ]),
                  ),

            PopupMenuItem<int>(
                      value: 2,
                      enabled: canDelete,
                      child: const Row(children: [
                        Icon(Icons.delete),
                        SizedBox(width: 5.0,),
                        Text('Supprimer')
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
    );
  }

}