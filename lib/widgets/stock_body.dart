import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/onprocess_error.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
import 'package:stock_manager_app/screens/stocks/stocks_create_update.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/widgets/stock_card.dart';

class StockBody extends StatefulWidget{
  const StockBody({super.key});

  
  @override
  StockBodyState createState() => StockBodyState();

}

class StockBodyState extends State<StockBody>{

  List stocks = [];

  loadStocks() async{
   setState(() {
      stocks = [1,2,3,4,5,6,7,8,9,10];
   });
  }

  searchStock(String name){

  }

  @override
  void initState() {
    super.initState();
    loadStocks();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Column(children: [
        stocks.isNotEmpty ? Container(height: 90.0,
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          maxLines: 2,
          decoration: const InputDecoration(hintText: "Chercher un stock",suffixIcon: Icon(Icons.search,size: 30.0,)),
          onChanged: (value) {
            searchStock(value);
          },
        ),
        ) : Container(),
        FutureBuilder(future: loadStocks(), builder: (context,snapshot){
            return snapshot.hasData && snapshot.data != null ? StockList(stocks:stocks) : snapshot.connectionState == ConnectionState.waiting && snapshot.hasData==false ? const 
            OnProcess() : snapshot.hasError ? const ErrorFetchingData() : StockList(stocks:stocks) ; // Container() après
          })

      ]),
      floatingActionButton: FloatingActionButton(onPressed: (){

         Navigator.of(context).push(
                            CustomPageTransistion(page:  StockCreateUpdateScreen(iscreate: true,),duration: 500).maketransition()
                          );
                          
      }, child: const Icon(Icons.add,color: Colors.white,),),
    );
  }

}

class StockList extends StatelessWidget{
  const StockList({super.key,required this.stocks});
  final List  stocks;
  @override
  Widget build(BuildContext context) {
   return stocks.isNotEmpty ? Expanded(child: ListView.builder(
    itemCount: stocks.length,
    itemBuilder: (context,index){
      return const StockCard();
   })) : Expanded(child: Container(
    width: MediaQuery.of(context).size.width,
    color: secondaryColor,
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