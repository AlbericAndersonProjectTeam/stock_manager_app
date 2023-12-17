import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/delete_service.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
import 'package:stock_manager_app/screens/products/product_create_update.dart';
import 'package:stock_manager_app/screens/products/product_details.dart';

class ProductCard extends StatelessWidget{
  const ProductCard({super.key});


  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onDoubleTap: (){
          Navigator.of(context).push(
            CustomPageTransistion(page: const ProductDetailScreen(),duration: 500).maketransition()
          );
      },
      child: Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4),
  ),
  clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.all(5.0),
      child: Padding(padding: const EdgeInsets.all(10.0),child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
       const Icon(Icons.file_open,size: 30.0,),
             const Expanded(child: 
              SizedBox(
                width: 150,
                child: 
             ListTile(
              title: Text('Spaghettis',style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('Matanti pour une saveur ...',maxLines: 1,),
             ),
              )) ,
          PopupMenuButton(
            itemBuilder: (context){
          return const [
            PopupMenuItem<int>(
                      value: 0,
                      child: Row(children: [
                        Icon(Icons.remove_red_eye),
                        SizedBox(width: 5.0,),
                        Text('Voir')
                      ]),
                  ),
            PopupMenuItem<int>(
                      value: 1,
                      child: Row(children: [
                        Icon(Icons.edit),
                        SizedBox(width: 5.0,),
                        Text('Modifier')
                      ]),
                  ),

            PopupMenuItem<int>(
                      value: 2,
                      child: Row(children: [
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
               CustomPageTransistion(page: const ProductDetailScreen(),duration: 500).maketransition()
            );
          }
           if(value == 1){
             Navigator.of(context).push(
                            CustomPageTransistion(page: const  ProductCreateUpdateScreen(iscreate: false,),duration: 500).maketransition()
                          );
          }
           if(value == 2){
              DeleteService.showDeleteAlert(context,name: "Spaghettis");
              if(DeleteService.delete){
                    DeleteService.deleteItem(context);
                   }
          
          }
           
        },
        
        )
        ],
      ),),
    ),
    );
  }

}