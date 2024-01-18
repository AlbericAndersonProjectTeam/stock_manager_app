import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/onprocess_error.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/product.dart';
import 'package:stock_manager_app/screens/products/product_create_update.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/widgets/product_card.dart';

class ProductBody extends StatefulWidget{

  const ProductBody({super.key});

  
  @override
  ProductBodyState createState() => ProductBodyState();

}

class ProductBodyState extends State<ProductBody>{

  List<Product> products = [];
  List<Product> resultsearching = [];
  static ProductBodyState state = ProductBodyState();

  bool searching = false;
  bool connectedUSerisAdmin=false;

  TextEditingController searchController = TextEditingController();

  refresh(){
    print("--rebuild product future builder---");
    if(mounted){
       setState(() {
      products = products;
    });
    }
  }

  Future<List<Product>> loadData() async{
    //load
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ownerId =  prefs.getString('ownerId')!;
    connectedUSerisAdmin =  prefs.getInt('isAdmin')! == 1 ? true : false;
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
    
    //saved data to session
    DATACONSTANTSOFSESSION.products = gotproducts;

    print('session products assigning : ${DATACONSTANTSOFSESSION.products }');

    return products;
  }


  searchProduct(String motif) {
    List<Product> results = [];
    setState(() {
      searching = true;
      resultsearching = results;
    });
   // SharedPreferences prefs = await SharedPreferences.getInstance();
   // String ownerId =  prefs.getString('ownerId')!;
   // results = await stockManagerdatabase.searchItem(type: "Product", motif: name,ownerId: ownerId);
      
      results = products.where((element) {
        String name = element.name.toLowerCase().trim();
        return name.startsWith(motif.toLowerCase().trim()) || name.contains(motif.toLowerCase().trim()) ;
      }).toList();

    print("----seraching-----${results.toString()}");

    setState(() {
      resultsearching = results;
    });
  }

  @override
  void initState() {
    super.initState(); 
    state = this;
    if(kDebugMode){
      print('session products : ${DATACONSTANTSOFSESSION.products }');
    }
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
      body: Column(children: [
        products.isNotEmpty || DATACONSTANTSOFSESSION.products!=null ? Container(height: 90.0,
        padding: const EdgeInsets.all(10.0),
        child: TextField(
          maxLines: 2,
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Chercher un produit",
            hintStyle: const TextStyle(color: primaryColor),
            contentPadding: const EdgeInsets.all(5.0),
            suffix: searching ? IconButton(onPressed: (){
            setState(() {
              searching = false;
              searchController.text = "";
              products = products;
            });
          }, icon: const Icon(Icons.close)) : const Icon(Icons.search,size: 30.0,)),
          onChanged: (value) {
            searchProduct(value);
          },
        ),
        ) : Container(),
         FutureBuilder(
          future: loadData(), builder: (context,snapshot){
            //print(" data : ${snapshot.data?? 'null'}");
            return  searching ? (resultsearching.isEmpty ? const Column(
          children: [
            SizedBox(height: 150.0,),
            Center(child: Text('Aucun produit'),)
          ],
        ): ProductList(products: resultsearching,connectedUSerisAdmin: connectedUSerisAdmin,)) : (snapshot.hasData && snapshot.data!=null ? ProductList(products:products,connectedUSerisAdmin:connectedUSerisAdmin) : snapshot.connectionState == ConnectionState.waiting && snapshot.hasData==false ? 
         ( DATACONSTANTSOFSESSION.products!=null ? ProductList(products: DATACONSTANTSOFSESSION.products!,connectedUSerisAdmin: connectedUSerisAdmin,) : const OnProcess()) : snapshot.hasError ? const ErrorFetchingData() : Container()); // Container() après
          })
      ]),
      floatingActionButton: FloatingActionButton(onPressed: (){
         Navigator.of(context).push(
                            CustomPageTransistion(page:  ProductCreateUpdateScreen(),duration: 500).maketransition()
                          ).then((value) => state.refresh());
      }, child: const Icon(Icons.add,color: Colors.white,),),
      
    );
  }


}

class ProductList extends StatelessWidget{
  const ProductList({super.key,required this.products,required this.connectedUSerisAdmin});
  final List  products;
  final bool connectedUSerisAdmin;
  @override
  Widget build(BuildContext context) {
    //print(" p : ${products}");
   return products.isNotEmpty ? Expanded(child: ListView.builder(
    itemCount: products.length,
    itemBuilder: (context,index){
      Product product = products[index];
      return ProductCard(product: product,canDelete : connectedUSerisAdmin);
   })) : Expanded(child: Container(
    width: MediaQuery.of(context).size.width,
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