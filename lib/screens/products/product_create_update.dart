import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
class ProductCreateUpdateScreen extends StatefulWidget{
  const ProductCreateUpdateScreen({super.key, this.iscreate = true});
  final bool iscreate ;

  @override
  ProductCreateUpdateScreenState createState() => ProductCreateUpdateScreenState(iscreate: iscreate);

}

class ProductCreateUpdateScreenState extends State<ProductCreateUpdateScreen>{
  ProductCreateUpdateScreenState({required this.iscreate});
  final bool iscreate ;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController seuilController = TextEditingController();
  TextEditingController dateController = TextEditingController();

 
  void saveProduct(BuildContext context) async{
    //save the product

    String message = iscreate ? "Produit ajouté avec succès." : "Produit modifié avec succès.";
    ToastMessage(message: message).showToast();
    Navigator.of(context).pop();
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
        title: iscreate ? const Text('Création de produit '): const Text('Modification de produit '),
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
                      label: const Text('Nom *'),
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
                    controller: priceController,
                    decoration:  InputDecoration(
                      label: const Text('Prix *'),
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
                    controller: descriptionController,
                    maxLines: 5,
                    decoration:  InputDecoration(
                      alignLabelWithHint: true,
                      label: const Text('Description *'),
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
                    controller: seuilController,
                    decoration:  InputDecoration(
                      label: const Text('Seuil'),
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
                        labelText: 'Date de péremption ', 
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
          ],)),
             const SizedBox(height: 20.0,),
             Align(alignment: Alignment.centerLeft,child:  ElevatedButton(onPressed: () async {
                   if(formKey.currentState!.validate()){
                      saveProduct(context);
                   }
                  }, child: const Text('Enregistrer',style: TextStyle(color: Colors.white),)),
               )
          ],
        ),),
      ),
    );
  } 

}