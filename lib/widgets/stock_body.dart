import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/onprocess_error.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/stock.dart';
import 'package:stock_manager_app/screens/stocks/stock_details.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/widgets/stock_card.dart';

class StockBody extends StatefulWidget{
  const StockBody({super.key});

  
  @override
  StockBodyState createState() => StockBodyState();

}

class StockBodyState extends State<StockBody>{

  List<Stock> stocks = [];
  List<Stock> resultsearching = [];
  bool connectedUSerisAdmin = false;
  var progressIndicator;

  static StockBodyState state = StockBodyState();

  bool searching = false;

  TextEditingController searchController = TextEditingController();

  refresh(){
    print("--rebuild stock future builder---");
    if(mounted){
       setState(() {
      stocks = stocks;
    });
    }
  }

  Future<List<Stock>> loadData() async{
    //load
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId =  prefs.getString('ownerId')!;
    connectedUSerisAdmin =  prefs.getInt('isAdmin')! == 1 ? true : false;
    List<Stock> gotstocks = [];
    try {
     gotstocks = await stockManagerdatabase.getStocks(ownerId);
    } catch (e) {
      ToastMessage(message: "Une erreur s'est produite.").showToast();
      //print(e);
    }

    if(gotstocks.isNotEmpty){
      if(mounted){
        setState(() {
          stocks = gotstocks;
        }); 
      }
    }

    //saved data to session
    DATACONSTANTSOFSESSION.stocks = gotstocks;

    return stocks;
  }

  Stock? checkStockName(String name) {
    
    for (var element in stocks) {
      if(element.name.toLowerCase().trim() == name.toLowerCase().trim()){
        return element;
      }
    }

    return null;
  }
  searchStock(String motif) async {

    List<Stock> results = [];

    setState(() {
      searching = true;
      resultsearching = results;
    });
  
      //filtering for search
      results = stocks.where((element) {
        String name = element.name.toLowerCase().trim();
        return name.startsWith(motif.toLowerCase().trim()) || name.contains(motif.toLowerCase().trim()) ;
      }).toList();

      setState(() {
            resultsearching = results;
          });
  }

   showAddStockDialog(BuildContext context){
    showDialog(context: context, builder: (dialogcontext){

    final addFormKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController locationController = TextEditingController();

      return AlertDialog(
        titlePadding: const EdgeInsets.all(5.0),
        insetPadding: const EdgeInsets.only(left: 10.0,right: 10.0),
         title: const ListTile(
          title: Text("Création de stock",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20.0),),
          subtitle: const Text('Donnez un nom à votre stock et renseignez son emplacement.',style: TextStyle(fontSize: 12.0),),
         ),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.elliptical(5, 5))),
        content: SizedBox(
          height: 200.0,
          child: Form(
          key: addFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration:  InputDecoration(
                      label: const Text('Nom'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      return value!.isNotEmpty ? (checkStockName(value.toLowerCase().trim()) ==null ? null : "Ce nom de stock existe déja." ) : "Saisie invalide";
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
            ],
          )
        ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(dialogcontext).pop();
          }, child:const Text('Annuler',style: TextStyle(color: primaryColor,fontSize: 18.0),)),
          TextButton(onPressed: () async {
           if(addFormKey.currentState!.validate()){
             Navigator.of(dialogcontext).pop();
            try {
             progressIndicator.showWithText("Chargement...");
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String ownerId =  prefs.getString('ownerId')!;
              String userName = prefs.getString("userName")!;
              Stock newStock = Stock(
              userName: userName,
              name: nameController.text,
              location: locationController.text,
              constituentslots: ListLots(lots: []),
              ownerId: ownerId,
              saveddate: DateTime.now(),
              );
              
              await stockManagerdatabase.storeStock(newStock);
              
              state.refresh();
              List<Stock> newAllStock = await stockManagerdatabase.getStocks(ownerId);
              newStock = newAllStock.first; //cause the newStock has not id yet
              progressIndicator.dismiss();
              if(mounted){
                Navigator.of(context).push(
                                CustomPageTransistion(page: StockDetailScreen(stock:newStock,canDelete: connectedUSerisAdmin,) ,duration: 500).maketransition()
                              ).then((value) => state.refresh());
              }
            } catch (e) {
              ToastMessage(message: "Une erreur s'est produite. Veuillez réssayer.").showToast();
              print(e);
            }
           }
            }, child:const Text('Enregistrer',style: TextStyle(color: primaryColor,fontSize: 18.0))),
        ],
      );
    }
    );
  }

  @override
  void initState() {
    super.initState();
    state = this;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadData();
         if(mounted){
        setState(() { });    
     }   
    });
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: ProgressHUD(
        child: Builder(builder: (context){
        progressIndicator = ProgressHUD.of(context)!;
        return  Column(children: [
        stocks.isNotEmpty || DATACONSTANTSOFSESSION.stocks !=null ? Container(height: 90.0,
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          maxLines: 2,
          controller: searchController,
          decoration:  InputDecoration(hintText: "Chercher un stock",suffix: searching ? IconButton(onPressed: (){
            setState(() {
              searching = false;
              searchController.text = "";
            });
          }, icon: const Icon(Icons.close)) : const Icon(Icons.search,size: 30.0,)),
          
          onChanged: (value) {
            searchStock(value);
          },
        ),
        ) : Container(),
        FutureBuilder(
          future: loadData(), builder: (context,snapshot){
            return  searching ? (resultsearching.isEmpty ? const Column(
          children: [
            SizedBox(height: 150.0,),
            Center(child: Text('Aucun stock'),)
          ],
        ):StockList(stocks: resultsearching,connectedUSerisAdmin:connectedUSerisAdmin)) : ( snapshot.hasData && snapshot.data != null ? StockList(stocks:stocks,connectedUSerisAdmin:connectedUSerisAdmin) : snapshot.connectionState == ConnectionState.waiting && snapshot.hasData==false ?  
            ( DATACONSTANTSOFSESSION.stocks != null ? StockList(stocks: DATACONSTANTSOFSESSION.stocks!,connectedUSerisAdmin:connectedUSerisAdmin): const OnProcess() ): snapshot.hasError ? const ErrorFetchingData() : Container()) ; 
          })

      ]);
        })
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){

        showAddStockDialog(context);
                          
      }, child: const Icon(Icons.add,color: Colors.white,),),
    );
  }

}

class StockList extends StatelessWidget{
  const StockList({super.key,required this.stocks, required this.connectedUSerisAdmin });
  final List<Stock>  stocks;
  final bool connectedUSerisAdmin;
  @override
  Widget build(BuildContext context) {
   return stocks.isNotEmpty ? Expanded(child: ListView.builder(
    itemCount: stocks.length,
    itemBuilder: (context,index){
      return  StockCard(stock: stocks[index],canDelete:connectedUSerisAdmin);
   })) : Expanded(child: Container(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/Images/Bg_aucun_stock.png",width: 250.0,),
        const Text('Aucun stock',style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),)
      ],
    ),
   ));
  }

}