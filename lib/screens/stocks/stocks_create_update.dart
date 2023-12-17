import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
class StockCreateUpdateScreen extends StatefulWidget{
  const StockCreateUpdateScreen({super.key, this.iscreate = true});
  final bool iscreate ;

  @override
  StockCreateUpdateScreenState createState() => StockCreateUpdateScreenState(iscreate: iscreate);

}

class StockCreateUpdateScreenState extends State<StockCreateUpdateScreen>{
  StockCreateUpdateScreenState({required this.iscreate});
  final bool iscreate ;

  final List products = [
    "Spaghettis","Produit2","Produit3","Produit4","Produit5",
    "Produit6","Produit7","Produit8","Produit9","Produit10","Produit11"
    ];
    
  List productspicked= [ "Spaghettis","Produit2","Produit3","Produit4","Produit5"];

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();

 
  void saveStock(BuildContext context) async{
    //save the Stock

    String message = iscreate ? "Stock ajouté avec succès." : "Stock modifié avec succès.";
    ToastMessage(message: message).showToast();
    Navigator.of(context).pop();
  }

  void _showMultiSelect(BuildContext context) async {
  await showModalBottomSheet(
    isScrollControlled: true, // required for min/max child size
    context: context,
    builder: (ctx) {
      return  MultiSelectBottomSheet(
        items: products.map((e) => MultiSelectItem(e, e)).toList(),
        initialValue: products[1],
        onConfirm: (values) {
          //get Selected Value
        },
        maxChildSize: 0.8,
      );
    },
  );
}
void showDialogQuantityEdit(BuildContext context){
  showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Quantité de Produit 1',style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500),),
        insetPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 24.0),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('Quitter')),
            TextButton(onPressed: (){
              //Store picked products


              Navigator.of(context).pop();
            }, child: Text('Valider')),
          ],
          content: TextFormField(
                style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.w500),
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                hintStyle: TextStyle(fontSize: 12.0),
                hintText: "Quantité",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                
              },

            ),
        );
  },
  
  );
}

void searchProductToPick(String value){

}

void showProductsDialogPicker(BuildContext context){
  showDialog(context: context, builder: (context){
      return AlertDialog(
        title: 
          TextField(
          maxLines: 2,
          decoration: const InputDecoration(hintText: "Chercher un produit",suffixIcon: Icon(Icons.search,size: 30.0,)),
          onChanged: (value) {
            searchProductToPick(value);
          },
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 24.0),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('Quitter')),
            TextButton(onPressed: (){
              //Store picked products


              Navigator.of(context).pop();
            }, child: Text('Valider')),
          ],
          content: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width:  MediaQuery.of(context).size.width * 0.80,
            child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
        child: Column(
        children:  products.map((e) => Form(child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Checkbox(value: true, onChanged: (value){

            }),
            Text('Produit : ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
            const SizedBox(width: 10.0,),
            Container(
              constraints: BoxConstraints(
                maxWidth: 100.0,
                maxHeight: 30.0
              ),
              child:  TextFormField(
                style: TextStyle(fontSize: 12.0,fontWeight: FontWeight.w500),
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                hintStyle: TextStyle(fontSize: 12.0),
                hintText: "Quantité",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                
              },

            ),
            )
          ],
        ))).toList(),
      ),
      ),
          ),
          ),
        );
  },
  
  );
}

  @override
  void initState() {
    super.initState();
    //set value of controllers if is update 
  }

  @override
  Widget build(BuildContext context) {
    Size contextSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: iscreate ? const Text('Création de stock '): const Text('Modification de stock '),
      ),
      body: SingleChildScrollView(
        child: Padding(padding:  EdgeInsets.only(
          top: contextSize.height*0.08,left: contextSize.width*0.05,right: contextSize.width*0.05),child: Column(
          
          children: [
          Form(
            key: formKey,
            child: Column(
            children: [
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
             const SizedBox(height: 10.0,),
                  DateTimeField(
                    initialValue: DateTime.now(),
                    controller: dateController,
                    decoration:  InputDecoration(
                        labelText: 'Date d\'enregistrement ', 
                         border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                        ),
                    format: DateFormat("d/M/y"),
                    onShowPicker: (context, currentValue) async {
                      final DateTime? dateTime = await showDatePicker(
                        firstDate: DateTime(2023),
                        lastDate: DateTime(2040),
                        context: context,
                        initialDate: DateTime.now(),
                      );
                      return dateTime;
                    },
                    validator: (DateTime? date) {
                      return date == null ? "Choisssez une date !" : null;
                    },
                  ),
             const SizedBox(height: 10.0,),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              constraints: const BoxConstraints(
                minHeight: 60.0
              ),

              decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(10),
                  border: Border.all(),
              ),
              child:  Column(children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Lots constitutifs',style: TextStyle(fontSize: 16.0)),
                  IconButton(onPressed: (){
                    showProductsDialogPicker(context);
                  }, icon: Icon(Icons.storage))
                ],
              ),
              productspicked.isNotEmpty ? Container(
                height: MediaQuery.of(context).size.height*0.25,
                padding: const EdgeInsets.all(5.0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: productspicked.length,
                  itemBuilder: (context,index){
                    return Row(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width*0.35,child: Text('Product',style: TextStyle(fontWeight: FontWeight.bold),),),
                        SizedBox(width: 5.0,),
                        Text('20',style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: MediaQuery.of(context).size.width*0.13,),
                        IconButton(onPressed: (){
                            showDialogQuantityEdit(context);
                        }, icon: Icon(Icons.edit)),
                        IconButton(onPressed: (){

                        }, icon: Icon(Icons.delete)),
                      ],
                    );
                 }),
              ) : Container()
              ],)
            ),


          ],)),
             const SizedBox(height: 20.0,),
             Align(alignment: Alignment.centerLeft,child:  ElevatedButton(onPressed: () async {
                   if(formKey.currentState!.validate()){
                      saveStock(context);
                   }
                  }, child: const Text('Enregistrer',style: TextStyle(color: Colors.white),)),
               )
          ],
        ),),
      ),
    );
  } 

}