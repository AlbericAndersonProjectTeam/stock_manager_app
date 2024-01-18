import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/delete_service.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/product.dart';
import 'package:stock_manager_app/models/stock.dart';
import 'package:stock_manager_app/screens/stocks/add_stock_transaction.dart';
import 'package:stock_manager_app/screens/stocks/stock_transaction_view.dart';
import 'package:stock_manager_app/screens/stocks/stocks_view_update.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/widgets/lot_card.dart';

class StockDetailScreen extends StatefulWidget {

  const StockDetailScreen({super.key,required this.stock, this.initialviewIndex = 0,required this.canDelete});
  final Stock stock;
  final bool canDelete;
  final int initialviewIndex ;
  
  @override
  StockDetailScreenState createState() => StockDetailScreenState(stock: stock,currentViewIndex: initialviewIndex,canDelete: canDelete);
  
  }
class StockDetailScreenState extends State<StockDetailScreen> {

  StockDetailScreenState({required this.stock, this.currentViewIndex = 0,required this.canDelete});

  Stock stock;
  final bool canDelete;
  int currentViewIndex ;

  static StockDetailScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<StockDetailScreenState>();
  }


  changeStock(Stock newStock){
    setState(() {
      stock = newStock;
    });
  }

  gotoStockTransitionaddProduct(String type,Stock stock,String? name,Stock? stocktotransfer){
    Navigator.of(context).push(
                MaterialPageRoute(builder: (context){
                  return StockTransactionProductsAddView(type: type,stock: stock,name: name,stocktotransfer: stocktotransfer,);
                })
              ).then((newStock){
                print("-----changed stock from transaction----------");
                if( newStock != null ){ 
                  changeStock(newStock);
                  setState(() {
                    currentViewIndex = 0;
                  });
                }
                });
  }

  buildBody(Stock stock,int index){
    return index == 0 ? 
    StockProductsView(stock: stock,) : ( index == 1 ? 
    StockViewUpdateScreen(stock:stock) : 
   StockTransactionScreen(stock: stock));
  }
  
  @override
  Widget build(BuildContext context) {

    /* final format = DateFormat("yyyy-mm-dd"); */
    return Scaffold(
      appBar: AppBar(
        title:  Text(stock.name),
        actions: [
          canDelete ? IconButton(onPressed: (){
                Navigator.of(context).pop();
                DeleteService.showDeleteAlert(context,stock);
          }, icon: const Icon(Icons.delete)) : Container()
        ],
      ),
      body:  buildBody(stock,currentViewIndex),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        selectedFontSize: 16,
        selectedItemColor:primaryColor,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        currentIndex: currentViewIndex, //New
        onTap: (index) {
       // Stock laststockVersion = await stockManagerdatabase.getOneStock(stock.id!);//to hold any new state
         setState(() {
           currentViewIndex = index;
           //stock = laststockVersion;
         });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart,),label: "Lots"),
          BottomNavigationBarItem(icon: Icon(Icons.details,),label: "Autres détails"),
          BottomNavigationBarItem(icon: Icon(Icons.currency_exchange,),label: "Transactions"),
        ],
),
    );
  }

}

class StockProductsView extends StatefulWidget{
  const StockProductsView({super.key,required this.stock});

  final Stock stock;
  //ListLots lots;

  @override
  StockProductsViewState createState() => StockProductsViewState(stock:stock);

}

class StockProductsViewState extends State<StockProductsView>{
  StockProductsViewState({required this.stock});
  Stock stock;
  List<Lot> lots = [];
  List<Product> products = DATACONSTANTSOFSESSION.products?? [];
  Stock? updatedStock;
  String userName = "";
  bool productsloaded = true;

  static StockProductsViewState? of(BuildContext context) {
    return context.findAncestorStateOfType<StockProductsViewState>();
  }

  editLot(BuildContext context,Lot lot){
    showDialog(context: context, builder: (dialogcontext){

    final editFormKey = GlobalKey<FormState>();
    TextEditingController quantityController = TextEditingController();
    TextEditingController seuilController = TextEditingController();
    quantityController.text = "${lot.numberofproduct}";
    seuilController.text = "${lot.seuilinstock}";

      return AlertDialog(
        icon: Align(alignment: Alignment.topRight,child: IconButton(onPressed: (){
          Navigator.of(dialogcontext).pop();
        }, icon: const Icon(Icons.close)),),
        iconPadding: const EdgeInsets.all(0.0),
        titlePadding: const EdgeInsets.all(5.0),
        insetPadding: const EdgeInsets.only(left: 10.0,right: 10.0),
         title: ListTile(
          title: Text("Lot de ${lot.product.name}",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20.0,color: primaryColor,),),
          subtitle: const Text('Vous ne pouvez pas modifier le produit dans un lot. Vous pouvez toute fois supprimer le lot et en créer un autre.',style: TextStyle(fontSize: 12.0),),
         ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(5, 5))),
        content: Container(
          height: 200.0,
          child: Form(
          key: editFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                TextFormField(
                    keyboardType: TextInputType.number,
                    controller: seuilController,
                    decoration:  InputDecoration(
                      label: const Text('Seuil dans le Stock'),
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
                    controller: quantityController,
                    decoration:  InputDecoration(
                      label: const Text('Quantité'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      return value!.isNotEmpty ? (int.parse(value) <= int.parse(seuilController.text) ? "La quantité doit être supérieure au seuil." : null) : "Saisie invalide";
                    },
                  ),
            ],
          )
        ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(dialogcontext).pop();
            updateLot(context,lot, null);
          }, child:const Text('Supprimer',style: TextStyle(color: primaryColor,fontSize: 18.0),)),
          TextButton(onPressed: (){
            if(editFormKey.currentState!.validate()){

            Navigator.of(dialogcontext).pop();
            Lot newLot = lot.copyWith(
              numberofproduct: int.parse(quantityController.text),
              seuilinstock: int.parse(seuilController.text)
              );
            updateLot(context,lot,newLot);
            }
            }, child:const Text('Enregistrer',style: TextStyle(color: primaryColor,fontSize: 18.0))),
        ],
      );
    }
    );
  }

  addLot(BuildContext context) async {
    if(products.isNotEmpty){
    List<Product> productsRemaining = [];
    List names = lots.map((e) => e.product.name).toList();
    print("------lots : ${lots.toString()}");
    print("-----porducts : ${products.toString()}");
    for (var product in products) {
      if(!names.contains(product.name)){
        productsRemaining.add(product);
      }
    }
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
          //print(selectedList.indexed);
          Product productToAdd = Product.simple();
          for (var product in products) {
            if (product.name == selectedList[0].name) {
             productToAdd = product;
            }
          }
          Lot newLot = Lot(product: productToAdd, numberofproduct: 0, seuilinstock: productToAdd.seuil!);
        
          updateLot(context,null,newLot);
        },
        
        enableMultipleSelection: false,
      ),
    ).showModal(context);
    }
    }
  }

  updateLot(BuildContext context,lot,newLot) async {  final progress = ProgressHUD.of(context);
      progress!.showWithText('Chargement...');
      print('++++++++++++++lots : $lots');
      try {
        List<Lot> newLots = [];
        if(lot!=null && newLot != null){
          for (var currentlot in lots) {
          if(currentlot.product.name == lot.product.name){
            print('-----------changes------');
            currentlot = newLot;
          }
          newLots.add(currentlot);
        }
        }else{
          newLots = lots;
          if(newLot!=null){
          newLots.add(newLot);
          }else{
            newLots.remove(lot);
          }
        }
          Stock newStock = stock.copyWith(
            constituentslots: ListLots(lots: newLots),
            userName: userName,
          );
          await stockManagerdatabase.updateStock(stock.id!, newStock);
          updatedStock = newStock;

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
         print("++++++++++++changed");
        }
        
        setState(() {
          lots = newLots;
        });
        
      } catch (e) {
        ToastMessage(message: "Une erreur s'est produite.").showToast();
        //print(e);
      }
          progress.dismiss();
  }



 loadsProducts() async {
  
  if(DATACONSTANTSOFSESSION.products==null){
    if(mounted){
        setState(() {
          productsloaded = false;
        });
      }
  try {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String ownerId =  prefs.getString('ownerId')!;
     userName = prefs.getString("userName")!;
     products = await stockManagerdatabase.getProducts(ownerId);
     DATACONSTANTSOFSESSION.products = products;

     print('products loaded : $products');
  } catch (e) {
      ToastMessage(message: "Une erreur s'est produite.").showToast();
      print(e);
  }
     if(mounted){
      setState(() {
        productsloaded = true;
      });
     }
  }
 }

 @override
  void initState() {
    super.initState(); 
    lots = stock.constituentslots.lots;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadsProducts();
       if(mounted) {
        setState(() { });   
       }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(builder: (context){
        return Column(
      children: [
       Padding(padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 5.0),
       child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: ListTile(
                title: Text('${lots.length} lots constitutifs',style: const TextStyle(fontSize: 20.0,fontWeight: FontWeight.w500,color: primaryColor,),),
                subtitle: const Text('Tappez double sur un lot pour plus d\'options. N\'apportez ici que des modifications dont vous ne souhaitez garder aucune trace.',style: TextStyle(fontSize: 10.0),),
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
       LotsGridView(lots:lots),
      ],
    );
      }) ,
    );
  }

}


class LotsGridView extends StatelessWidget{
  const LotsGridView({super.key,required this.lots, this.istransaction = false});
  final List  lots;
  final bool istransaction;
  @override
  Widget build(BuildContext context) {
    ////print(" p : ${products}");
   return lots.isNotEmpty ? Expanded(child: GridView.builder(
           gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 1.5 ,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
    itemCount: lots.length,
    itemBuilder: (context,index){
      Lot lot = lots[index];
      return LotCard(lot: lot,istransaction : istransaction);
   })) : Expanded(child: Container(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/Images/Bg_aucun_produit.png",width: 250.0,),
        Text( istransaction ? 'Aucun lot de produit ajouté.' : "Aucun produit dans ce stock.",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),)
      ],
    ),
   ));
  }

}