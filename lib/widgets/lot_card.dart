import 'package:flutter/material.dart';
import 'package:stock_manager_app/models/stock.dart';
import 'package:stock_manager_app/screens/stocks/add_stock_transaction.dart';
import 'package:stock_manager_app/screens/stocks/stock_details.dart';
import 'package:stock_manager_app/styles/colors.dart';

class LotCard extends StatelessWidget{

  final Lot lot;
  const LotCard({super.key,required this.lot, required this.istransaction});
  final bool istransaction;


  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onDoubleTap: (){
       istransaction ? StockTransactionProductsAddViewState.of(context)!.editLot(context, lot) :   StockProductsViewState.of(context)!.editLot(context, lot);
      },
      child: Card(
      color: const Color.fromRGBO(235, 231, 231, 1),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(padding: const EdgeInsets.only(bottom : 5.0),child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
             Expanded(child: 
             ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("${lot.numberofproduct}",
                  maxLines: 2,
                  style: const TextStyle(
                    color: primaryColor,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
                    )),
                ],
              ),
              subtitle:  Container(
                    width: MediaQuery.of(context).size.width / 5,
                    child: Text("${lot.product.name}",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: istransaction ? 14.0 : 12.0,fontWeight: FontWeight.w600,color: primaryColor,),),
                  ),
             ),),
           istransaction ? Container() : Text('Seuil : ${lot.seuilinstock}',style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w500,color: primaryColor,),)
        ],
      ),),
    ),
    );
  }

}