import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:stock_manager_app/constants/delete_service.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
import 'package:stock_manager_app/styles/colors.dart';

class StockHistoryScreen extends StatefulWidget{
  const StockHistoryScreen({super.key, this.iscreate = true});
  final bool iscreate ;

  @override
  StockHistoryScreenState createState() => StockHistoryScreenState(iscreate: iscreate);

}

class StockHistoryScreenState extends State<StockHistoryScreen>{
  StockHistoryScreenState({required this.iscreate});
  final bool iscreate ;
  final history = [1,2,3,4,5,6,7,8,9,10,11,12,13];
 
  void deleteHistoryItem(BuildContext context) async{
    //save the Stock

    String message = "Sauvegarde supprimée";
    ToastMessage(message: message).showToast();
  }

  @override
  void initState() {
    super.initState();
    //set value of controllers if is update 
  }

   Widget buildHistory() {
    return  SingleChildScrollView(
      child: ExpansionPanelList.radio(
      animationDuration: const Duration(milliseconds: 1000),
            expandedHeaderPadding: EdgeInsets.all(10),
            dividerColor: primaryColor,
            elevation: 4,
      children: history.map<ExpansionPanelRadio>((item) {
      List products = [1,2,3,4,5];
      
        return ExpansionPanelRadio(
          canTapOnHeader: true,
            value: item,
            headerBuilder: (BuildContext context, bool isExpanded) {
              return  ListTile(
                title: Text('Enregistrement - 20/12/14',style: TextStyle(color: primaryColor,fontWeight: FontWeight.w500),),
              );
            },
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [

                Expanded(child: ListTile(
              titleTextStyle:  TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title: const Text("Lots constitutifs "),
              subtitle: Text("25 lots"),
              
            )) ,IconButton(icon : const Icon(Icons.delete,color: primaryColor,),onPressed: (){
    DeleteService.showDeleteAlert(context,name: "Enregistrement - 20/12/14");
  } ,),
                  ],
                ),
             Container(
                height: MediaQuery.of(context).size.height*0.25,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
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
             const SizedBox(height: 10.0,),ListTile(
              titleTextStyle:  TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title: Text("Opération"),
              subtitle: Text("In this tutorial, we will learn how to create beautiful and customizable card UI in Flutter."),
            ),
              ],
            ));
      }).toList(),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size contextSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Historique de stock'),
      ),
      body: Column(children: [
         Container(
        color: Colors.white,
        height: 150.0,
        padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 40.0),
        child: Column(
          children: [
            Text('Stock000',textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),),
            Container(
              width: contextSize.width,
              padding: EdgeInsets.symmetric(horizontal: contextSize.width*0.05,vertical: 5.0),
              child: SingleChildScrollView(scrollDirection: Axis.horizontal,child:   Row(children: [
            Text('Période de :  '),
            const SizedBox(width: 5.0,),

            const SizedBox(width: 5.0,),
                  DateTimeField(
                    initialValue: DateTime.now(),
                    decoration:  InputDecoration(
                      suffixIcon: Icon(Icons.date_range),
                      contentPadding: EdgeInsets.symmetric(vertical: 1.0,horizontal: 25.0),
                        constraints: BoxConstraints(maxWidth: 200.0,maxHeight: 30.0),
                         border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                        ),
                    format: DateFormat.yMMM(),
                    onShowPicker: (context, currentValue) async {
                      final DateTime? dateTime = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime.now(),
                        );
                      return dateTime;
                    },
                    onChanged: (value) {
                      
                    },
                  ),
           ],),))
          ],
        )
        ),
        Expanded(child:  buildHistory()),

      ]),
    );
  } 

}
