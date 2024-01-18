import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/onprocess_error.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/stock.dart';
import 'package:stock_manager_app/models/transactions.dart';
import 'package:stock_manager_app/screens/stocks/stock_details.dart';
import 'package:stock_manager_app/styles/colors.dart';

class StockTransactionScreen extends StatefulWidget{
  const StockTransactionScreen({super.key,required this.stock});
  final Stock stock ;

  @override
  StockTransactionScreenState createState() => StockTransactionScreenState(stock: stock);

}

class StockTransactionScreenState extends State<StockTransactionScreen>{
  StockTransactionScreenState({required this.stock});
  Stock stock ;
  List<Stock> stocks = [];
  bool dataloaded = false;

  List<Vente> ventes = [];
  List<Achat> achats = [];
  List<TransactionToAnotherStock> transactionsToAnotherStock = [];


  static StockTransactionScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<StockTransactionScreenState>();
  }
  

 
  void deleteTransactionItem(BuildContext context) async{
    //save the Stock

    String message = "Transaction supprimée";
    ToastMessage(message: message).showToast();
  }

  chooseTypeTransaction(BuildContext context){
   
  showModalBottomSheet(context: context, builder: (bottomSheetContext){
    return Wrap(
            spacing: 10.0,
          children: [
            const ListTile(
              title: Text('Choisissez un type de transaction',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20.0),),
            ),
           ListTile(
            title: const Text('Vente',style: TextStyle(fontWeight: FontWeight.w500),),
            onTap: () {
              Navigator.of(bottomSheetContext).pop();
              fillInformationOfTransactionDialog(context, stockTransactionTypeVente);
            },
           ),
           const Divider(),
           ListTile(
            title: Text('Achat',style: TextStyle(fontWeight: FontWeight.w500),),
            onTap: () {
              Navigator.of(bottomSheetContext).pop();
              fillInformationOfTransactionDialog(context, stockTransactionTypeAchat);
              
            },
           ),
           const Divider(),

           ListTile(
            title: Text('Transfert entre stock',style: TextStyle(fontWeight: FontWeight.w500),),
            onTap: () {
              Navigator.of(bottomSheetContext).pop();
              fillInformationOfTransactionDialog(context, stockTransactionTypeTransfer);
              
            },
           ),
          ],
    );
  });
  }

  Stock? checkStockName(String name) {
    
    for (var element in stocks) {
      if(element.name.toLowerCase().trim() == name.toLowerCase().trim()){
        return element;
      }
    }

    return null;
  }

  fillInformationOfTransactionDialog(BuildContext context,String type){
    print('type : $type');
    showDialog(
      context: context, builder: (dialogcontext){

    final editFormKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    String label = type == stockTransactionTypeVente ? "Nom du client" : (type == stockTransactionTypeAchat ? "Nom du fournisseur" : "Nom du Stock");

      return AlertDialog(
        icon: Align(alignment: Alignment.topRight,child: IconButton(onPressed: (){
          Navigator.of(dialogcontext).pop();
        }, icon: const Icon(Icons.close)),),
        iconPadding: const EdgeInsets.all(0.0),
        titlePadding: const EdgeInsets.all(5.0),
        insetPadding: const EdgeInsets.only(left: 10.0,right: 10.0),
         title: ListTile(
          title: const Text("Nouvelle Transaction",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20.0),),
          subtitle: Text(type,style: const TextStyle(fontSize: 15.0),),
         ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(5, 5))),
        content: Container(
          height: 100.0,
          child: Form(
          key: editFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration:  InputDecoration(
                      label:  Text(label),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      if(type!=stockTransactionTypeTransfer){
                        return value!.isNotEmpty ? null : "Saisie invalide";
                      }else{
                        return value!.toLowerCase().trim() == stock.name.toLowerCase().trim() ? "Entrez le nom d'un autre stock" : (checkStockName(value) !=null ? null : "Stock inexistant");
                      }
                      
                    },
                  ),
            ],
          )
        ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(dialogcontext).pop();

          }, child:const Text('Annuler',style: TextStyle(color: primaryColor,fontSize: 18.0),)),
          TextButton(onPressed: (){
            if(editFormKey.currentState!.validate()){
            Navigator.of(dialogcontext).pop();
            if(type==stockTransactionTypeAchat){

            StockDetailScreenState.of(context)!.gotoStockTransitionaddProduct(stockTransactionTypeAchat, stock, nameController.text,null);
          }else if(type==stockTransactionTypeVente){
            StockDetailScreenState.of(context)!.gotoStockTransitionaddProduct(stockTransactionTypeVente, stock, nameController.text,null);
              
          }else{
               Stock? stocktotransfer = checkStockName(nameController.text);

                StockDetailScreenState.of(context)!.gotoStockTransitionaddProduct(stockTransactionTypeTransfer, stock, null,stocktotransfer);
            }
            }
            }, child:const Text('Continuer',style: TextStyle(color: primaryColor,fontSize: 18.0))),
        ],
      );
    }
    );
  }

  loadStocksAndTransactions() async {
    try {
      print('--load---transactions-listes');
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ownerId =  prefs.getString('ownerId')!;
      stocks = await stockManagerdatabase.getStocks(ownerId);

      if(DATACONSTANTSOFSESSION.ventes[stock.id]!=null){
          ventes  = DATACONSTANTSOFSESSION.ventes[stock.id]!;
      }else{
          ventes = await stockManagerdatabase.getVente(stock.id!);
          DATACONSTANTSOFSESSION.ventes[stock.id!] = ventes;
      }
       if(DATACONSTANTSOFSESSION.achats[stock.id]!=null){
          achats  = DATACONSTANTSOFSESSION.achats[stock.id]!;
      }else{
          achats = await stockManagerdatabase.getAchat(stock.id!);
          DATACONSTANTSOFSESSION.achats[stock.id!] = achats;
      }
       if(DATACONSTANTSOFSESSION.transfers[stock.id]!=null){
          transactionsToAnotherStock  = DATACONSTANTSOFSESSION.transfers[stock.id]!;
      }else{
          transactionsToAnotherStock = await stockManagerdatabase.getTransactionToAnotherStock(stock.id!);
          DATACONSTANTSOFSESSION.transfers[stock.id!] = transactionsToAnotherStock;
      }
      
     if(mounted){
       setState(() {
        dataloaded = true;
      });
     }
    } catch (e) {
      ToastMessage(message: "Une erreur s'est produite.");
    }
  }

  @override
  void initState() {
    print('---------------init trans view-----------------');
    super.initState();
    if(DATACONSTANTSOFSESSION.achats[stock.id]==null || DATACONSTANTSOFSESSION.ventes[stock.id]==null || DATACONSTANTSOFSESSION.transfers[stock.id]==null){

      WidgetsBinding.instance.addPostFrameCallback((_) async {
       await loadStocksAndTransactions();
        if(mounted){
          setState(() {});  
        }  
    });

    }else{

          ventes  = DATACONSTANTSOFSESSION.ventes[stock.id]!;
          achats  = DATACONSTANTSOFSESSION.achats[stock.id]!;
          transactionsToAnotherStock  = DATACONSTANTSOFSESSION.transfers[stock.id]!;

          if(mounted){
            setState(() {
              dataloaded = true;
            });
          }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
      children: [
       Padding(padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 5.0),
       child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
           const  Expanded(
              child: ListTile(
                title: Text('Transactions',style: const TextStyle(fontSize: 20.0,fontWeight: FontWeight.w500,color: primaryColor,),),
                subtitle: Text('Managez vos entrées et sorties de stock.',style: TextStyle(fontSize: 10.0),),
              )
              ),
            ElevatedButton(onPressed: () {
              if(dataloaded){
                chooseTypeTransaction(context);
              }
            }, child: dataloaded ? const Row(children: [
               Icon(Icons.add_circle_outline,color: Colors.white,),
              Text('Nouvelle',style: TextStyle(color: Colors.white),)
            ],) : customCircularProcessIndicator)
          ],
        ),
       ) ,
      const SizedBox(height: 50.0,),
      TransactionCard(type: stockTransactionTypeVente, number: ventes.length, description: "Vente de produit du stock à des clients.",stock: stock,),
      const SizedBox(height: 20.0,),
      TransactionCard(type: stockTransactionTypeAchat, number: achats.length, description: "Achat de produits chez un fournisseur pour le stock.",stock: stock,),
      const SizedBox(height: 20.0,),
      TransactionCard(type: stockTransactionTypeTransfer, number: transactionsToAnotherStock.length, description: "Transfert de produits du présent stock à un autre stock.",stock: stock,),
      ],
    ),
    );
  } 

}

class TransactionCard extends StatelessWidget{
  const TransactionCard({super.key, required this.type, required this.number, required this.description, required this.stock});
  final String type;
  final String description;
  final int number;
  final Stock stock;


  @override
  Widget build(BuildContext context) {
    print("type : $type -- number : $number");
   return 
       Card(
          elevation: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            //decoration: const BoxDecoration(color: secondaryColor),
            child: Column(
              children: [

       ListTile(
          contentPadding:
            const  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: const EdgeInsets.only(right: 12.0),
            decoration: const  BoxDecoration(
                border: Border(
                    right:  BorderSide(width: 1.0, color: Colors.black26))),
            child: Text(
            "$number",
            style: const TextStyle( fontWeight: FontWeight.bold,fontSize: 20.0,color: primaryColor,),
          ),
          ),
          title: Text(
            type,
            style: const TextStyle( fontWeight: FontWeight.bold,fontSize: 20.0,color: primaryColor,),
          ),
          subtitle: Text(
              description,
               style: const TextStyle(fontSize: 11.0,color: primaryColor,)),
          trailing:
             const Icon(Icons.keyboard_arrow_right,  size: 30.0,color: primaryColor,),
          onTap: () {
            if(number!=0){

              if(type==stockTransactionTypeVente){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context){
                    return StockTransactionHistoryView(stock: stock, type: type);
                  })
                );
              }else if (type==stockTransactionTypeAchat){
                 Navigator.of(context).push(
                  MaterialPageRoute(builder: (context){
                    return StockTransactionHistoryView(stock: stock, type: type);
                  }));
              }else{

                 Navigator.of(context).push(
                  MaterialPageRoute(builder: (context){
                    return StockTransactionHistoryView(stock: stock, type: type);
                  }));
              }
            }else{
              ToastMessage(message: "Aucune transaction du type $type enregistrée.").showToast();
            }
          },
        ),
       ] )
          ),
        );
  }

}

class StockTransactionHistoryView extends StatefulWidget{
  const StockTransactionHistoryView({super.key, required this.stock, required this.type});
  final Stock stock;
  final String type;
  @override
 StockTransactionHistoryViewState createState() => StockTransactionHistoryViewState(stock: stock,type: type);
  
}

class StockTransactionHistoryViewState extends State<StockTransactionHistoryView>{

  StockTransactionHistoryViewState({required this.stock,required this.type});
  final Stock stock;
  List transactions = [];
  final String type;
  bool dataloaded = true;
  bool searching = false;

  List<StockTransaction>   resultsearching = [];

  showTransactionProducts(BuildContext context,List<Lot> transactslots){
     DropDownState(
      heightOfBottomSheet : MediaQuery.of(context).size.height*0.90,
      DropDown(
        searchHintText: "Rechercher...",
        isDismissible: true,
        bottomSheetTitle: const Text(
          "Produits de la transaction",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        submitButtonChild: null,
        clearButtonChild: null,
        listItemBuilder: (index) {
          Lot lot = transactslots[index];
          return Text("${lot.product.name} : ${lot.numberofproduct}",style: TextStyle(fontWeight: FontWeight.w500),);
        },
        data: transactslots.map((e) => SelectedListItem(name: "${e.product.name} : ${e.numberofproduct}",value: e.product.id.toString())).toList(),
        selectedItems: null,
      ),
    ).showModal(context);
  }

  Widget buildTransaction(BuildContext context,transactionsToShow) {

    return  transactionsToShow.isNotEmpty ? Expanded(
      child: ListView.builder(
      itemCount: transactionsToShow.length,
      itemBuilder: (context,index){
        var e = transactionsToShow[index];
         DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(e.saveddate.toString());
        var inputDate = DateTime.parse(parseDate.toString());
        var outputFormat = DateFormat("dd/MM/yyyy HH:mm");
        var outputDate = outputFormat.format(inputDate);
          return Column(
            children: [
              ListTile(
                title: Text(outputDate,style: const TextStyle(fontSize: 20.0,color: primaryColor,fontWeight: FontWeight.w400),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    e is Vente ? RichText(text: TextSpan(
                      children: [
                        const TextSpan(text: 'Client : ',style: TextStyle(color: primaryColor)),
                        TextSpan(text: e.customerName,style:const  TextStyle(fontWeight: FontWeight.w500,color: Colors.black87))
                      ]
                    )): (e is Achat ? RichText(text: TextSpan(
                      children: [
                        const TextSpan(text: 'Fournisseur : ',style: TextStyle(color: primaryColor)),
                        TextSpan(text: e.providerName,style:const  TextStyle(fontWeight: FontWeight.w500,color: Colors.black87))
                      ]
                    )) : RichText(text: TextSpan(
                      children: [
                        const TextSpan(text: 'Stock de destination : ',style: TextStyle(color: primaryColor)),
                        TextSpan(text: e.stocktotransfername,style:const  TextStyle(fontWeight: FontWeight.w500,color: Colors.black87))
                      ]
                    ))),
                    RichText(text: TextSpan(
                      children: [
                        const TextSpan(text: 'Enregistré(e) par : ',style: TextStyle(color: primaryColor)),
                        TextSpan(text: e.userName,style:const  TextStyle(fontWeight: FontWeight.w500,color: Colors.black87))
                      ]
                    ))
                  ],
                ),
                onTap: (){
                  List<Lot> transactlots = e is Vente ? e.soldlots.lots : (e is Achat ? e.boughtlots.lots : e.lots.lots);
                  showTransactionProducts(context,transactlots);
                },
              ),
              const Divider(),
            ],
          );
    }) ,
    ) : Center(child: Text('Aucune transaction pour cette date.'),);
  }

  searchTransaction(String type,DateTime? date) async {

    setState(() {
      searching = true;
    });
    DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(date.toString());
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat("dd/MM/yyyy");
    var motifDate = outputFormat.format(inputDate);
     List<StockTransaction> results = [];

   /*  List<StockTransaction> results = [];
    print("date : $outputDate");
    results = await stockManagerdatabase.searchTransaction(type: type, date: outputDate,stockId: stock.id!);
 */

    if(type==stockTransactionTypeAchat){

      for (var achat in transactions) {
        var achatDate = achat.toJson()['saveddate'];

        if(achatDate.contains(motifDate)){
          results.add(achat);
        }
      }

    }else if(type==stockTransactionTypeVente){
    
      for (var vente in transactions) {
        var venteDate = vente.toJson()['saveddate'];

        if(venteDate.contains(motifDate)){
          results.add(vente);
        }
      }
    }else{
       for (var transfer in transactions) {
        var transferDate = transfer.toJson()['saveddate'];

        if(transferDate.contains(motifDate)){
          results.add(transfer);
        }
      }
    }

    setState(() {
      resultsearching = results;
    });

  }

  loadTransactions() async {
    if(type==stockTransactionTypeAchat){
      if(DATACONSTANTSOFSESSION.achats[stock.id]!=null){
        transactions =  DATACONSTANTSOFSESSION.achats[stock.id!] as List<dynamic>;
      }else{
        setState(() {
          dataloaded = false;
        });
        transactions = await stockManagerdatabase.getAchat(stock.id!);
        DATACONSTANTSOFSESSION.achats[stock.id!] = transactions as List<Achat>;
      }
    }else if(type==stockTransactionTypeVente){
      if(DATACONSTANTSOFSESSION.ventes[stock.id]!=null){
        transactions =  DATACONSTANTSOFSESSION.ventes[stock.id!] as List<dynamic>;
      }else{
        setState(() {
          dataloaded = false;
        });
        transactions = await stockManagerdatabase.getVente(stock.id!);
        DATACONSTANTSOFSESSION.ventes[stock.id!] = transactions as List<Vente>;
      }
    }else{
      if(DATACONSTANTSOFSESSION.transfers[stock.id]!=null){
        transactions =  DATACONSTANTSOFSESSION.transfers[stock.id!] as List<dynamic>;
      }else{
        setState(() {
          dataloaded = false;
        });
        transactions = await stockManagerdatabase.getTransactionToAnotherStock(stock.id!);
        DATACONSTANTSOFSESSION.transfers[stock.id!] = transactions as List<TransactionToAnotherStock>;
      }
    }

    setState(() {
      dataloaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadTransactions();
         if(mounted){
        setState(() { });    
     }   
    });
  }
  @override
  Widget build(BuildContext context) {
  var contextSize = MediaQuery.of(context).size;
    return Scaffold(
    appBar: AppBar(
    title: Text(type),
    ),
    body: Column(
    children: [
      const SizedBox(height: 20.0,),
      Text(stock.name,
                maxLines: 2,
                overflow: TextOverflow.visible,
                style: const TextStyle(color: primaryColor, fontWeight: FontWeight.bold,fontSize: 20.0),),
      const SizedBox(height: 10.0,),
     Container(
              alignment: Alignment.topRight,
              width: contextSize.width,
              padding: EdgeInsets.only(right : 10.0,top: 10.0),
              child: SingleChildScrollView(scrollDirection: Axis.horizontal,child:   Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
               
            const Text('Filtre/Date :  ',style: TextStyle(color: primaryColor),),
            const SizedBox(width: 5.0,),
                   DateTimeField(
                    decoration:  InputDecoration(
                      
                      contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 25.0),
                        constraints: BoxConstraints(maxWidth: 200.0,maxHeight: 50.0),
                         border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                        ),
                    format: DateFormat("dd/MM/yyyy"),
                    onShowPicker: (context, currentValue) async {
                      final DateTime? dateTime = await showDatePicker(
                        firstDate: DateTime(2010),
                        lastDate: DateTime.now(),
                        context: context,
                        initialDate: DateTime.now(),
                      );
                      return dateTime;
                    },
                    onChanged: (value) {
                      if(value!=null){
                        searchTransaction(type,value);
                      }else{
                        setState(() {
                          searching = false;
                        });
                      }
                    },
                  ),
           ],),)),
           const SizedBox(height: 30.0,),

          dataloaded ?( searching ?  buildTransaction(context,resultsearching) : buildTransaction(context,transactions)) : OnProcess(),

        ],
           
    ),
    );
  }
}