import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/notifications.dart';
import 'package:stock_manager_app/models/product.dart';
import 'package:stock_manager_app/models/stock.dart';
import 'package:stock_manager_app/models/transactions.dart';
import 'package:stock_manager_app/providers/notifications.dart';
import 'package:stock_manager_app/screens/stocks/stock_details.dart';
import 'package:stock_manager_app/styles/colors.dart';

class StockTransactionProductsAddView extends StatefulWidget{
  const StockTransactionProductsAddView({super.key,required this.stock,required this.type,this.name,this.stocktotransfer});
  final Stock stock;
  final String type;
  final dynamic stocktotransfer; //string
  final dynamic name; //String 
  //ListLots lots;

  @override
  StockTransactionProductsAddViewState createState() => StockTransactionProductsAddViewState(stock:stock,type: type,name: name,stocktotransfer: stocktotransfer);

}

class StockTransactionProductsAddViewState extends State<StockTransactionProductsAddView>{
  StockTransactionProductsAddViewState({required this.stock,required this.type,this.name,this.stocktotransfer});
  Stock stock;
  final String type;
  Stock? stocktotransfer;
  String? name;
  List<Lot> lots = [];
  bool productsloaded = false;
  late List<Product> products;
  Stock? updatedStock;
  NewNotificationNotifier notificationNotifier = NewNotificationNotifier();
  var progressIndicatorContext;

  static StockTransactionProductsAddViewState? of(BuildContext context) {
    return context.findAncestorStateOfType<StockTransactionProductsAddViewState>();
  }

  editLot(BuildContext context,Lot lot){
    showDialog(context: context, builder: (context){

    final editFormKey = GlobalKey<FormState>();
    TextEditingController quantityController = TextEditingController();
    quantityController.text = "${lot.numberofproduct}";
    String adviser = "";
    
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
        icon: Align(alignment: Alignment.topRight,child: IconButton(onPressed: (){
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.close)),),
        iconPadding: const EdgeInsets.all(0.0),
        titlePadding: const EdgeInsets.all(5.0),
        insetPadding: const EdgeInsets.only(left: 10.0,right: 10.0),
         title: ListTile(
          title: Text("Lot de ${lot.product.name}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20.0),),
          subtitle: const Text('Vous ne pouvez pas modifier le produit dans un lot. Vous pouvez toute fois supprimer le lot et en créer un autre.',style: TextStyle(fontSize: 12.0),),
         ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(5, 5))),
        content: Container(
          height: 110.0,
          child: Form(
          key: editFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                adviser !="" ? Text(adviser,style: const TextStyle(color: Colors.red,fontSize: 11.0),) : Container(),
                adviser !="" ? const SizedBox(height: 5.0,) : Container(),
                TextFormField(
                    keyboardType: TextInputType.number,
                    controller: quantityController,
                    decoration:  InputDecoration(
                      label: const Text('Quantité'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {
                      var lotstemp = stock.constituentslots.lots;
                      var lottemp;
                      for (var element in lotstemp) {
                        //print("${element.product.name} : ${lot.product.name}");
                        if(element.product.name == lot.product.name){
                          lottemp = element;
                          break;
                        }
                      }
                      if(value.isNotEmpty){
                        if(type!=stockTransactionTypeAchat && lottemp.numberofproduct - int.parse(value) < lottemp.seuilinstock){
                          setState(() {
                            adviser="Avertissement : Le seuil du stock de produit est dépassé.";
                          });
                      }else{
                        setState(() {
                          adviser="";
                        });
                      }
                      }else{
                        setState(() {
                          adviser="";
                        });
                      }
                    },
                    validator: (String? value){
                      var lotstemp = stock.constituentslots.lots;
                      var lottemp;
                      for (var element in lotstemp) {
                        //print("${element.product.name} : ${lot.product.name}");
                        if(element.product.name == lot.product.name){
                          lottemp = element;
                          break;
                        }
                       }
                       //print(lottemp.toString());
                      return type==stockTransactionTypeAchat && value!.isNotEmpty ? null : ( lottemp.numberofproduct - int.parse(value!) >= 0 ? null : "Stock de produit insuffisant !");
                    },
                  ),
            ],
          )
        ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
            updateLot(lot, null);
          }, child:const Text('Supprimer',style: TextStyle(color: primaryColor,fontSize: 18.0),)),
          TextButton(onPressed: (){
            if(editFormKey.currentState!.validate()){
            
            Navigator.of(context).pop();
            Lot newLot = lot.copyWith(
              numberofproduct: int.parse(quantityController.text),
              );
            updateLot(lot,newLot);
            }
            }, child:const Text('Enregistrer',style: TextStyle(color: primaryColor,fontSize: 18.0))),
        ],
      );
      },);
    }
    );
  }

  addLot(BuildContext context) async {
    List<Product> productsRemaining = [];
    List names = lots.map((e) => e.product.name).toList();
    products.forEach((product) {
      if(!names.contains(product.name)){
        productsRemaining.add(product);
      }
    },);
    if(productsRemaining.isEmpty){
        ToastMessage(message: "Tous les produits enregistrés se trouvent déjà dans ce stock.").showToast();
    }else{
     DropDownState(
      heightOfBottomSheet : MediaQuery.of(context).size.height*0.90,
      DropDown(
        searchHintText: "Rechercher...",
        isDismissible: true,
        bottomSheetTitle: const Text(
          "Choisissez un produit",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: const Text(
          'Valider',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        clearButtonChild: const Text(
          'Annuler',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        data: productsRemaining.map((e) => SelectedListItem(name: e.name,value: e.name)).toList(),
        selectedItems: (List<dynamic> selectedList) {
          ////print(selectedList.indexed);
          Product productToAdd = Product.simple();
          for (var product in products) {
            if (product.name == selectedList[0].name) {
             productToAdd = product;
            }
          }
          Lot newLot = Lot(product: productToAdd, numberofproduct: 0, seuilinstock: productToAdd.seuil!);
          updateLot(null,newLot);
        },
        
        enableMultipleSelection: false,
      ),
    ).showModal(context);
    }
  }

  updateLot(lot,newLot) async {
    
        List<Lot> newLots = [];
        if(lot!=null && newLot != null){
          lots.forEach((currentlot) {
          if(currentlot == lot){
            currentlot = newLot;
          }
          newLots.add(currentlot);
        });
        }else{
          newLots = lots;
          if(newLot!=null){
          newLots.add(newLot);
          }else{
            newLots.remove(lot);
          }
        }

        setState(() {
          lots = newLots;
        });
  }

 Future<void> loadsProducts() async {
  //loads
  ////print("'''''''enter");
    try {
        if(type!=stockTransactionTypeAchat){
          products = stock.constituentslots.lots.map((e) => e.product).toList();
        }else{
          products = await stockManagerdatabase.getProducts(stock.ownerId);
        }
          if(mounted){
            setState(() {
              productsloaded = true;
            });
          }
    } catch (e) {
      ToastMessage(message: "Une erreur s'est produite.").showToast();
      //print(e);
    }

 }

 checkSeuilForNotifications(List<Lot> lots) async {
   for (var lot in lots) {
    if(lot.numberofproduct <= lot.seuilinstock){
      String title =  "Rupture de Stock : ${stock.name}";
      String content = "Le produit ${lot.product.name} est en rupture.";
      StockNotification notification = StockNotification(
        ownerId: stock.ownerId,
        stockId: stock.id!,
        title: title,
        content: content ,
        saveddate: DateTime.now()
      );
      await stockManagerdatabase.storeNotification(notification);
      notificationNotifier.istherenewnotification = true;
      List<String> tokens = await stockManagerdatabase.getAllToken(stock.ownerId);
      try {
          if(SETTINGSSESSION.mailalert){
            //send mail alert
            //launchUrl('mailto:rajatrrpalankar@gmail.com?subject=This is Subject Title&body=This is Body of Email')
          }
          if(SETTINGSSESSION.notificationalert){
            for (var token in tokens) {
              await stockManagerNotificationService.sendPushMessage(notification.content, notification.title, token);
            }

          }
          if(SETTINGSSESSION.employeealert){
            //send mail alert
          }
      } catch (e) {
        ToastMessage(message: "Une erreur s'est produite.").showToast();
      }
    }
  }
 }

 saveTransaction(BuildContext mycontext) async {
  bool lotWithZeroProduit = false;

  for (var transactionlot in lots) {
    ////print('number : --------${transactionlot.numberofproduct}');
    if(transactionlot.numberofproduct==0){
          lotWithZeroProduit = true;
          break;
     }
  }
  //print('lotWithZeroProduit : -----$lotWithZeroProduit');
  if(!lotWithZeroProduit && lots.isNotEmpty){

     var progressIndicator  = ProgressHUD.of(progressIndicatorContext);
     progressIndicator!.showWithText('Chargement...');
     try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userName =  prefs.getString('userName')!;
      Stock newStock;
       if(type==stockTransactionTypeAchat){

        List<Lot> oldlots = stock.constituentslots.lots;
        List<Lot> newLots = [];

        for (var lot in oldlots) {
          for (var transactionlot in lots) {
            if(lot.product == transactionlot.product){
              lot.numberofproduct+=transactionlot.numberofproduct;
            }
          }
          newLots.add(lot);
        }

        for (var transactionlot in lots) {
          bool lotexist = false;
          for (var lot in oldlots) {
            if(lot.product == transactionlot.product){
              lotexist = true;
            }
          }
          if(!lotexist){
           newLots.add(transactionlot);
          }
        }
        
        newStock = stock.copyWith(constituentslots: ListLots(lots: newLots));
        await stockManagerdatabase.updateStock(stock.id!, newStock);
        Achat achat = Achat(stockId: stock.id!, providerName: name!, boughtlots: ListLots(lots: lots),userName: userName, saveddate: DateTime.now());
        await stockManagerdatabase.storeAchat(achat);

        //save to session
        if(DATACONSTANTSOFSESSION.achats[stock.id!] != null){
          DATACONSTANTSOFSESSION.achats[stock.id!]!.add(achat);
        }

        ToastMessage(message: "Achat enregistré avec succès !").showToast();
        if(mounted){
         //print("++++++++++++changed : $newStock");
         Navigator.pop(mycontext,newStock);
        }
      }else if(type==stockTransactionTypeVente){

        List<Lot> oldlots = stock.constituentslots.lots;
        List<Lot> newLots = [];
        oldlots.forEach((lot){
          for (var transactionlot in lots) {
            if(lot.product == transactionlot.product){
              lot.numberofproduct-=transactionlot.numberofproduct;
            }
          }
          newLots.add(lot);
        });
        
        newStock = stock.copyWith(constituentslots: ListLots(lots: newLots));
        await stockManagerdatabase.updateStock(stock.id!, newStock);
        Vente vente = Vente(stockId: stock.id!, customerName: name!, soldlots: ListLots(lots: lots),userName: userName, saveddate: DateTime.now());
        await stockManagerdatabase.storeVente(vente);


        //save to session
        if(DATACONSTANTSOFSESSION.ventes[stock.id!] != null){
          DATACONSTANTSOFSESSION.ventes[stock.id!]!.add(vente);
        }
        
        ToastMessage(message: "Vente enregistrée avec succès !").showToast();
        if(mounted){
        // StockTransactionScreenState.of(context)!.changeStock(newStock);
         //print("++++++++++++changed");
         Navigator.pop(mycontext,newStock);
        }
      }else{


        List<Lot> oldlots = stocktotransfer!.constituentslots.lots;
        List<Lot> newLots = [];
        oldlots.forEach((lot){
          for (var transactionlot in lots) {
            if(lot.product.name == transactionlot.product.name){
              lot.numberofproduct+=transactionlot.numberofproduct;
            }
          }
          newLots.add(lot);
        });

        for (var transactionlot in lots) {
          bool lotexist = false;
          for (var lot in oldlots) {
            if(lot.product == transactionlot.product){
              lotexist = true;
            }
          }
          if(!lotexist){
           newLots.add(transactionlot);
          }
        }
        
        newStock = stocktotransfer!.copyWith(constituentslots: ListLots(lots: newLots));
        await stockManagerdatabase.updateStock(stocktotransfer!.id!, newStock);

         oldlots = stock.constituentslots.lots;
         newLots = [];
        oldlots.forEach((lot){
          for (var transactionlot in lots) {
            if(lot.product == transactionlot.product){
              lot.numberofproduct-=transactionlot.numberofproduct;
            }
          }
          newLots.add(lot);
        });
        
        newStock = stock.copyWith(constituentslots: ListLots(lots: newLots));
        await stockManagerdatabase.updateStock(stock.id!, newStock);

        TransactionToAnotherStock transfer = TransactionToAnotherStock(stockId: stock.id!,stocktotransfername: stocktotransfer!.name, lots: ListLots(lots: lots),userName: userName, saveddate: DateTime.now());
        await stockManagerdatabase.storeTransaction(transfer);


        //save to session
        if(DATACONSTANTSOFSESSION.transfers[stock.id!] != null){
          DATACONSTANTSOFSESSION.transfers[stock.id!]!.add(transfer);
        }else{

        }

        ToastMessage(message: "Transfert enregistré avec succès !").showToast();
        if(mounted){
         Navigator.pop(mycontext,newStock);
         //print("++++++++++++changed");
        }
      }

    checkSeuilForNotifications(newStock.constituentslots.lots);
       
  } catch (e) {
    //print(e);
    ToastMessage(message: "Une erreur s'est produite. Veuillez réssayer.").showToast();
  }
  progressIndicator.dismiss();
  }else{
    ToastMessage(message: lots.isNotEmpty ? "Supprimez les lots avec zéro produit dans la transaction. et ajouter" : "Ajoutez au moins un lot pour la transaction.").showToast();
  }
 }

 @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
       await loadsProducts();
         if(mounted){
        setState(() { });    
     }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle transaction'),
        leading: CloseButton(),
        actions: [
          IconButton(onPressed: (){
            saveTransaction(context);
          }, icon: Icon(Icons.check)),
        ],
      ),
      body:  ProgressHUD(
      child: Builder(builder: (context){
        progressIndicatorContext = context;
        return  Column(
      children: [
       Padding(padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 5.0),
       child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ListTile(
                title: Text('$type de produits',style: const TextStyle(fontSize: 20.0,fontWeight: FontWeight.w500),),
                subtitle: const Text('Ajoutez les produits concernés par la transaction. Tappez double sur un lot pour voir plus.',style: TextStyle(fontSize: 10.0),),
              )
              ),
            ElevatedButton(onPressed: () {
              addLot(context);
            }, child: productsloaded ? const Row(children: [
               Icon(Icons.add_shopping_cart,color: Colors.white,),
              Text('Ajouter',style: TextStyle(color: Colors.white),)
            ],) : customCircularProcessIndicator)
          ],
        ),
       ) ,

        LotsGridView(lots:lots,istransaction : true),
      ],
    );
      }) ,
    ),
    );
  }

}