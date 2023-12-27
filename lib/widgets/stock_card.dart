import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/delete_service.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/stock.dart';
import 'package:stock_manager_app/screens/stocks/stock_details.dart';
import 'package:stock_manager_app/widgets/stock_body.dart';

class StockCard extends StatelessWidget{
  final Stock stock;
  final bool canDelete;
  const StockCard({super.key, required this.stock,required this.canDelete});


  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onDoubleTap: (){
          Navigator.of(context).push(
            CustomPageTransistion(page: StockDetailScreen(stock:stock,canDelete: canDelete,),duration: 500).maketransition()
          ).then((value) => StockBodyState.state.refresh());
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
              Expanded(child: 
              SizedBox(
                width: 150,
                child: 
             ListTile(
              title: Text(stock.name,style: const TextStyle(fontWeight: FontWeight.w500),),
              subtitle: Text(stock.location,maxLines: 1,),
             ),
              )) ,
          PopupMenuButton(
            itemBuilder: (context){
          return [
            const PopupMenuItem<int>(
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
                        Icon(Icons.history),
                        SizedBox(width: 5.0,),
                        Text('Transactions')
                      ]),
                  ),
            const PopupMenuItem<int>(
                      value: 2,
                      child: Row(children: [
                        Icon(Icons.edit),
                        SizedBox(width: 5.0,),
                        Text('Modifier')
                      ]),
                  ),

            PopupMenuItem<int>(
                      value: 3,
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
               CustomPageTransistion(page: StockDetailScreen(stock:stock,canDelete: canDelete,),duration: 500).maketransition()
            );
          }
           if(value == 1){

                   Navigator.of(context).push(
                            CustomPageTransistion(page: StockDetailScreen(stock:stock,initialviewIndex: 2,canDelete: canDelete,) ,duration: 500).maketransition()
                          );
          }
           if(value == 2){

             Navigator.of(context).push(
                            CustomPageTransistion(page: StockDetailScreen(stock:stock,canDelete: canDelete, initialviewIndex: 2,) ,duration: 500).maketransition()
                          ).then((value) => StockBodyState.state.refresh());
          }
           if(value == 3){
              DeleteService.showDeleteAlert(context,stock);
          
          }
           
        },
        
        )
        ],
      ),),
    ),
    );
  }

}