
import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/delete_service.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
import 'package:stock_manager_app/screens/stocks/stock_history.dart';
import 'package:stock_manager_app/screens/stocks/stocks_create_update.dart';
import 'package:stock_manager_app/styles/colors.dart';

class StockDetailScreen extends StatelessWidget {
   StockDetailScreen({super.key});
  
  final List products = [1,2,3,4,5];
  @override
  Widget build(BuildContext context) {

    /* final format = DateFormat("yyyy-mm-dd"); */
    return Scaffold(
      appBar: AppBar(
        title: const Text("Détails Stock"),
        leading: const CloseButton(),
      ),
      body:  Padding(
        padding: EdgeInsets.only(left:10.0,right: 10.0,top: MediaQuery.of(context).size.height*0.10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: Row(children: [
                   Icon(Icons.file_open,size: 30.0,),
                Text("Stock000",style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 30.0),),
                ]),),

                 ElevatedButton(onPressed: () {

                   Navigator.of(context).push(
                            CustomPageTransistion(page: const  StockHistoryScreen(iscreate: false,),duration: 1500).maketransition()
                          );

                  }, child: const Text('Historique',style: TextStyle(color: Colors.white),)),
              ],
            ),
             SizedBox(height: 20.0,),
              ListTile(
              leading: Icon(Icons.location_on),
              titleTextStyle:  TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title:  Text("Emplacement"),
              subtitle: Text("Parakou"),
            ) , 
             ListTile(
              leading: Icon(Icons.date_range),
              titleTextStyle:  TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title: Text("Date d'enregistrement"),
              subtitle: Text("20/10/2027"),
            ) ,
             ListTile(
              leading: Icon(Icons.storage),
              titleTextStyle:  TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title: const Text("Lots constitutifs "),
              subtitle: Text("25 lots"),
              
            ) ,
             Container(
                height: MediaQuery.of(context).size.height*0.25,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)
                ),
              child:  SingleChildScrollView(
                child:   SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(  
              columns: [  
              const  DataColumn(label: Text(  
                    'Produit',  
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)  
                )),  
                DataColumn(label: Text(  
                    'Qté',  
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)  
                )),  
                DataColumn(label: Text(  
                    'Seuil',  
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)  
                )),  
              ],  
              rows: products.map((e) => 
                DataRow(cells: [  
                  DataCell(Text('Nom Produit')),  
                  DataCell(Text('Quantité')),  
                  DataCell(Text('10 unités')),  
                ]), ).toList(),  
            ),
                ),  
              )
              ,),
             const SizedBox(height: 30.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(onPressed: (){

             Navigator.of(context).push(
                            CustomPageTransistion(page: const  StockCreateUpdateScreen(iscreate: false,),duration: 500).maketransition()
                          );

                   }, child: const Text('Modifier',style: TextStyle(color: Colors.white),)),
                  const SizedBox(width: 5.0,),
                 ElevatedButton(onPressed: () async {
                    Navigator.of(context).pop();
                    DeleteService.showDeleteAlert(context,name: "Stock000");
                  }, child: const Text('Supprimer',style: TextStyle(color: Colors.white),)),
                ],
            ),
          ],
        ),
      ),
    );
  }

}
