import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/stock.dart';
import 'package:stock_manager_app/screens/stocks/stock_details.dart';
import 'package:stock_manager_app/styles/colors.dart';
class StockViewUpdateScreen extends StatefulWidget{
  const StockViewUpdateScreen({super.key,required this.stock, this.isview = true});
  final bool isview ;
  final Stock stock;

  @override
  StockCreateViewScreenState createState() => StockCreateViewScreenState(isview: isview,stock: stock);

}

class StockCreateViewScreenState extends State<StockViewUpdateScreen>{
  StockCreateViewScreenState({required this.isview,required this.stock});
  bool isview ;
  Stock stock;
  bool showProgress = false;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();

 
  void updateStock(BuildContext context) async{
    //save the Stock
      if (mounted) {
        setState(() {
          showProgress = true;
        });
      }
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userName = prefs.getString("userName")!;

        Stock newStock = stock.copyWith(name: nameController.text,location: locationController.text,userName: userName);
        //print("stock---${stock.toJson()}");
        await stockManagerdatabase.updateStock(stock.id!, newStock);

        //save to session
        if(DATACONSTANTSOFSESSION.stocks!=null){
              for (var i = 0; i < DATACONSTANTSOFSESSION.stocks!.length; i++) {
                if(DATACONSTANTSOFSESSION.stocks![i].id! == newStock.id!){
                  DATACONSTANTSOFSESSION.stocks![i] = newStock;
                  break;
                }
              }
        }

        if(mounted){
         StockDetailScreenState.of(context)!.changeStock(newStock);
         //print("++++++++++++changed");
        }
        String message = "Stock modifié avec succès.";
        ToastMessage(message: message).showToast();
        setState(() {
          stock = newStock;
          showProgress = false;
          isview = true;
        });
      } catch (e) {
        ToastMessage(message: "Une erreur s'est produite.").showToast();
        print(e);
      }
  }

 
  @override
  void initState() {
    super.initState();
    nameController.text = stock.name;
    locationController.text = stock.location;
  }

  @override
  Widget build(BuildContext context) {

    DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(stock.saveddate.toString());
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('dd/MM/yyyy');
    var outputDate = outputFormat.format(inputDate);

    return Padding(
        padding: EdgeInsets.only(left:10.0,right: 10.0,top: MediaQuery.of(context).size.height*0.10),
        child: SingleChildScrollView(child: 
    Column(
      children: [
        isview ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
               Image.asset("assets/Icones/Stock2.png",width: 30.0,),
               const SizedBox(width: 20.0,),
               Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                child:  Text(stock.name,
                maxLines: 2,
                overflow: TextOverflow.visible,
                style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 30.0),),
               ),
              ],
            ),
            const  SizedBox(height: 20.0,),
              ListTile(
              leading: const Icon(Icons.location_on,color: primaryColor,),
              titleTextStyle: const  TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title: const Text("Emplacement"),
              subtitle: Text(stock.location),
            ) , 
             ListTile(
              leading: const Icon(Icons.date_range,color: primaryColor,),
              titleTextStyle:   const TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title: const Text("Date d'enregistrement"),
              subtitle: Text(outputDate), 
            ) , 
             ListTile(
              leading: const Icon(Icons.person,color: primaryColor,),
              titleTextStyle:   const TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),
              title: const Text("Enregistré par"),
              subtitle: Text(stock.userName), 
            ) ,
          ],
        ) : 
          Form(
            key: formKey,
            child: Column(
            children: [
            const  SizedBox(height: 30.0,),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration:  InputDecoration(
                      label: const Text('Nom du stock'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      return value!.isNotEmpty ? null : "Saisie invalide";
                    },
                  ),
                  const SizedBox(height: 10.0,),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: locationController,
                    decoration:  InputDecoration(
                      label: const Text('Emplacement'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      return value!.isNotEmpty ? null : "Saisie invalide";
                    },
                  ),


          ],)),

           const  SizedBox(height: 30.0,),
            Align(
              alignment: Alignment.topRight,
                child: 
                  ElevatedButton(onPressed: () {
                       if(!showProgress){
                         if(!isview){
                          updateStock(context);
                        }else{
                        setState(() {
                          isview = false;
                        });
                        }
                       }
                   }, child: isview ? const Text('Modifier',style: TextStyle(color: Colors.white),) :(showProgress ? customCircularProcessIndicator : const Text('Enregistrer',style: TextStyle(color: Colors.white),))),
            )

      ],
    ),
      ),);
    
  } 

}
