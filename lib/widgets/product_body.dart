import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/onprocess_error.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
import 'package:stock_manager_app/screens/products/product_create_update.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/widgets/product_card.dart';

class ProductBody extends StatefulWidget{
  const ProductBody({super.key});

  
  @override
  ProductBodyState createState() => ProductBodyState();

}

class ProductBodyState extends State<ProductBody>{

  List products = [];

  loadProducts() async{

    //load
    setState(() {
      products = [1,2,3,4,5];
    }); //

  }

  searchProduct(String name){

  }

  @override
  void initState() {
    super.initState();

    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        products.isNotEmpty ? Container(height: 90.0,
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          maxLines: 2,
          decoration: const InputDecoration(hintText: "Chercher un produit",suffixIcon: Icon(Icons.search,size: 30.0,)),
          onChanged: (value) {
            searchProduct(value);
          },
        ),
        ) : Container(),
     FutureBuilder(future: loadProducts(), builder: (context,snapshot){
            return snapshot.hasData && snapshot.data != null ? ProductList(products:products) : snapshot.connectionState == ConnectionState.waiting && snapshot.hasData==false ? const 
            OnProcess() : snapshot.hasError ? const ErrorFetchingData() : ProductList(products:products) ; // Container() après
          })
      ]),
      floatingActionButton: FloatingActionButton(onPressed: (){
         Navigator.of(context).push(
                            CustomPageTransistion(page:  ProductCreateUpdateScreen(),duration: 500).maketransition()
                          );
      }, child: const Icon(Icons.add,color: Colors.white,),),
    );
  }

}

class ProductList extends StatelessWidget{
  const ProductList({super.key,required this.products});
  final List  products;
  @override
  Widget build(BuildContext context) {
   return products.isNotEmpty ? Expanded(child: ListView.builder(
    itemCount: products.length,
    itemBuilder: (context,index){
      return const ProductCard();
   })) : Expanded(child: Container(
    width: MediaQuery.of(context).size.width,
    color: secondaryColor,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/Images/Bg_aucun_produit.png",width: 250.0,),
        const Text('Aucun produit',style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold),)
      ],
    ),
   ));
  }

}