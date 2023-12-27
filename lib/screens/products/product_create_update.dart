import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/blocs/product.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/product.dart';
import 'package:stock_manager_app/providers/product.dart';
import 'package:stock_manager_app/styles/colors.dart';


class ProductCreateUpdateScreen extends StatefulWidget{
  const ProductCreateUpdateScreen({super.key, this.iscreate = true, this.productModel,this.product});
  final bool iscreate ;
  final Product? product;
  final ProductUpdateNotifier? productModel ;

  @override
  ProductCreateUpdateScreenState createState() => ProductCreateUpdateScreenState(iscreate: iscreate,product:product,productModel: productModel);

}

class ProductCreateUpdateScreenState extends State<ProductCreateUpdateScreen>{
  ProductCreateUpdateScreenState({required this.iscreate,this.product,this.productModel});
  final bool iscreate ;
  final Product? product;
  final ProductUpdateNotifier? productModel ;
  bool showProgress = false;

  List<Product> products=[];

  final productBloc = ProductActionBloc();

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController seuilController = TextEditingController();
  TextEditingController dateController = TextEditingController();

 
  void saveProduct(BuildContext context) async{
    //save the product
    setState(() {
      showProgress = true;
    });
    final format = DateFormat('dd/MM/yyyy');

     
      try { 
      Product newProduct = Product.simple();
              
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String ownerId =  prefs.getString('ownerId')!;
        String userName = prefs.getString("userName")!;

        if(iscreate){

        newProduct = Product(
            ownerId: ownerId,
            userName: userName,
            name: nameController.text,
            price: int.parse(priceController.text),
            description: descriptionController.text,
            seuil: int.parse(seuilController.text),
            expireddate: dateController.text!="" ? format.parse(dateController.text) : null,
            saveddate: DateTime.now(),
          );

         await stockManagerdatabase.storeProduct(newProduct);
         

        }else{
      Product product = productModel != null ? productModel!.product : this.product!;
          newProduct = product.copyWith(
            userName: userName,
              name: nameController.text,
              price: int.parse(priceController.text),
              description: descriptionController.text,
              seuil: int.parse(seuilController.text),
              expireddate: dateController.text!="Aucune" ? format.parse(dateController.text) : null,
              saveddate: DateTime.now(),
            );
          await stockManagerdatabase.updateProduct(product.id?? -1, newProduct);
          if(productModel!=null){
            productModel!.setProduct(newProduct);
          }
            if(DATACONSTANTSOFSESSION.products!=null){
              for (var i = 0; i < DATACONSTANTSOFSESSION.products!.length; i++) {
                if(DATACONSTANTSOFSESSION.products![i].id! == newProduct.id!){
                  DATACONSTANTSOFSESSION.products![i] = newProduct;
                  break;
                }
              }
             }
        
        }

          String message = iscreate ? "Produit ajouté avec succès." : "Produit modifié avec succès.";
          ToastMessage(message: message).showToast();
          if(mounted){
             Navigator.of(context).pop();
          }
      } catch (e) {
        print(e);
        ToastMessage(message: "Une erreur s'est produite. Veuillez réssayer.").showToast();
      }


    setState(() {
      showProgress = false;
    });
  }
  loadProducts() async{
    //load
    print('-----loaded--------');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId =  prefs.getString('ownerId')!;
    List<Product> gotproducts = [];
    try {
     gotproducts = await stockManagerdatabase.getProducts(ownerId);
    } catch (e) {
      ToastMessage(message: "Une erreur s'est produite.").showToast();
      print(e);
    }

    if(gotproducts.isNotEmpty){
      if(mounted){
        setState(() {
          products = gotproducts;
        }); 
      }
    }
  }


  @override
  void initState() {
    super.initState();
    //set value of controllers if is update 
    if(!iscreate){
      Product product = productModel != null ? productModel!.product : this.product!;
      nameController.text = product.name;
      priceController.text = "${product.price}";
      descriptionController.text = product.description;
      seuilController.text = product.seuil.toString();

      var outputDate = "Aucune";
     if(product.expireddate != null){
        DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(product.expireddate.toString());
        var inputDate = DateTime.parse(parseDate.toString());
        var outputFormat = DateFormat('dd/MM/yyyy');
        outputDate = outputFormat.format(inputDate);
     }

      dateController.text = outputDate;
    }


    WidgetsBinding.instance.addPostFrameCallback((_) async {
       await loadProducts();
         if(mounted){
        setState(() { });    
     }
    });
  }

  Product? checkProductName(String name) {
    
    for (var element in products) {
      if(element.name.toLowerCase().trim() == name.toLowerCase().trim()){
        return element;
      }
    }

    return null;
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
                    keyboardType: TextInputType.number,
                    controller: priceController,
                    decoration:  InputDecoration(
                      suffix: const Text('francs CFA',style: TextStyle(color: primaryColor),),
                      label: const Text('Prix *'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      return value!.isNotEmpty ? (int.parse(value) != 0 ? null : "Saisie invalide") : "Saisie invalide";
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
                    
                    keyboardType: TextInputType.number,
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
                    format: DateFormat("dd/MM/yyyy"),
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
                      print('-------date : ${date.toString()}');
                      return null;
                    },
                  ),
          ],)),
             const SizedBox(height: 20.0,),
             Align(alignment: Alignment.centerLeft,child:  ElevatedButton(onPressed: () async {
                   if(formKey.currentState!.validate()){
                      saveProduct(context);
                   }
                  }, child: showProgress ? customCircularProcessIndicator : const Text('Enregistrer',style: TextStyle(color: Colors.white),)),
               )
          ],
        ),),
      ),
    );
  } 

}