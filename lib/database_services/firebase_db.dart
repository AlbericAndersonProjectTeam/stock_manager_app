import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/notifications.dart';
import 'package:stock_manager_app/models/product.dart';
import 'package:stock_manager_app/models/settings.dart';
import 'package:stock_manager_app/models/stock.dart';
import 'package:stock_manager_app/models/transactions.dart';
import 'package:stock_manager_app/models/user.dart';

class StockManagerFirebaseService { //db.settings = const Settings(persistenceEnabled: true);
  static final FirebaseFirestore dbinstance = FirebaseFirestore.instance; 
  
  enablePersistence(){
    dbinstance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
  }

  storeNotification(StockNotification notification) async {

   await dbinstance.collection("Notification")
        .doc()
        .set(notification.toJson()).catchError((e){
          print(e);
          ToastMessage(message: "Vérifiez votre connection internet.");
        });
  }

  storeOwner(Owner owner) async {
   await dbinstance.collection("Owner")
        .doc()
        .set(owner.toJson()).catchError((e){
          print(e);
          ToastMessage(message: "Vérifiez votre connection internet.");
        });
  }


  storeEmployee(Employee employee) async {
   await dbinstance.collection("Employee")
        .doc()
        .set(employee.toJson()).catchError((e){
          print(e);
          ToastMessage(message: "Vérifiez votre connection internet.");
        });
  }

  storeProduct(Product product) async {
  await dbinstance.collection("Product")
        .doc()
        .set(product.toJson()).catchError((e){
          print(e);
          ToastMessage(message: "Vérifiez votre connection internet.");
        });
  }

  storeStock(Stock stock) async {
   await dbinstance.collection("Stock")
        .doc()
        .set(stock.toJson()).catchError((e){
          print(e);
          ToastMessage(message: "Vérifiez votre connection internet.");
        });
  }

  storeVente(Vente vente) async {
   await dbinstance.collection("Vente")
        .doc()
        .set(vente.toJson()).catchError((e){
          print(e);
          ToastMessage(message: "Vérifiez votre connection internet.");
        });
  }

  storeAchat(Achat achat) async {
   await dbinstance.collection("Achat")
        .doc()
        .set(achat.toJson()).catchError((e){
          print(e);
          ToastMessage(message: "Vérifiez votre connection internet.");
        });
  }

  storeTransaction(TransactionToAnotherStock transaction) async {
   await  dbinstance.collection("TransactionToAnotherStock")
        .doc()
        .set(transaction.toJson()).catchError((e){
          print(e);
          ToastMessage(message: "Vérifiez votre connection internet.");
        });
  }

  storeToken(String id,String ownerId,String value) async {
  await  dbinstance.collection("Tokens")
        .doc()
        .set({"userId" : id,"ownerId":ownerId,"value" : value}).catchError((e){
          print(e);
          ToastMessage(message: "Vérifiez votre connection internet.");
        });
  }


Future<List<StockNotification>> getAllNotifications(String ownerId) async {
   
    var snapshot = await
    dbinstance.collection("Notification").where("ownerId", isEqualTo:ownerId).get();

    List<StockNotification> notifications = [];

      for (var document in snapshot.docs) {
        //print("-------docnotif : ${document.data()}");
        StockNotification notification = StockNotification.fromJson(document.id, document.data());
        notifications.add(notification);
      }
        notifications.sort(((a, b) {
          int millisecondsA = a.saveddate.millisecondsSinceEpoch;
          int millisecondsB = b.saveddate.millisecondsSinceEpoch;
          return millisecondsB.compareTo(millisecondsA);
        }));
    

    return notifications;
}

Future<dynamic> getUserWithId(String id,String type) async {
   
    dynamic user;
    if(type=="Owner"){
      var docSnapshot = await dbinstance.collection('Owner').doc(id).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
      Owner owner = Owner.fromJson(id,data!);
      user = owner;
      }
    }else{
       var docSnapshot = await dbinstance.collection('Employee').doc(id).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
      Employee employee = Employee.fromJson(id,data!);
      user = employee;
      }
    }

    return user;
}

  Future<User?> getUserWithEmail(String email) async {

    dynamic user;
    var snapshot = await
    dbinstance.collection("Owner").where("email", isEqualTo:email).get();

     if(snapshot.docs.isNotEmpty){
      var document = snapshot.docs.first;
      user = Owner.fromJson(document.id, document.data());
     }

    if(user == null){
      snapshot = await
      dbinstance.collection("Employee").where("email", isEqualTo:email).get();

      if(snapshot.docs.isNotEmpty){
        var document = snapshot.docs.first;
        user = Employee.fromJson(document.id, document.data());
      }
    }

    return user;
  }

Future<User?> getUserWithCredentials(String email, String password) async {
   
   print("---$email----$password------");
    dynamic user;
  var snapshot = await
    dbinstance.collection("Owner").where("email", isEqualTo:email).where("password",isEqualTo: password).get();

   
     if(snapshot.docs.isNotEmpty){
      var document = snapshot.docs.first;
      user = Owner.fromJson(document.id, document.data());
     }

    if(user == null){
      snapshot = await
      dbinstance.collection("Employee").where("email", isEqualTo:email).where("password",isEqualTo: password).get();
      if(snapshot.docs.isNotEmpty){
        var document = snapshot.docs.first;
        user = Employee.fromJson(document.id, document.data());
      }
    }

    return user;
  }

  Future<List<Employee>> getEmployee(String ownerId) async {
   
    List<Employee> employees = [];

     var snapshot = await 
    dbinstance.collection("Employee").where("ownerId", isEqualTo:ownerId).get();

      for (var document in snapshot.docs) {
        Employee employee = Employee.fromJson(document.id, document.data());
        employees.add(employee);
      }


    return employees;
  }

   Future<List<Employee>> getAllEmployee() async {
   
  
    List<Employee> employees = [];

    var snapshot = await 
    dbinstance.collection("Employee").get();


      for (var document in snapshot.docs) {
        Employee employee = Employee.fromJson(document.id, document.data());
        employees.add(employee);
      }

    
    return employees;
  }
  
  Future<List<Product>> getProducts(String id) async {
   
    List<Product> products = [];

     var snapshot = await 
    dbinstance.collection("Product").where("ownerId", isEqualTo:id).get();

      for (var document in snapshot.docs) {
        Product product = Product.fromJson(document.id, document.data());
        products.add(product);
      }

        products.sort(((a, b) {
          int millisecondsA = a.saveddate.millisecondsSinceEpoch;
          int millisecondsB = b.saveddate.millisecondsSinceEpoch;
          return millisecondsB.compareTo(millisecondsA);
        }));
    

    
    return products;
  }

    Future<List<Stock>> getStocks(String id) async {
   
    List<Stock> stocks = [];

     var snapshot = await 
    dbinstance.collection("Stock").where("ownerId", isEqualTo:id).get();

      for (var document in snapshot.docs) {
        Stock stock = Stock.fromJson(document.id, document.data());
        stocks.add(stock);
      }

        stocks.sort(((a, b) {
          int millisecondsA = a.saveddate.millisecondsSinceEpoch;
          int millisecondsB = b.saveddate.millisecondsSinceEpoch;
          return millisecondsB.compareTo(millisecondsA);
        }));
    
    return stocks;
  }

  Future<Stock?> getOneStock(String id) async {

    Stock? stock ;
    var docSnapshot = await dbinstance.collection('Stock').doc(id).get();
      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data();
        stock = Stock.fromJson(id,data!);
      }
    
    return stock;

  }

  Future<List<Vente>> getVente(String id) async {
   
   List<Vente> ventes = [];
  
   var snapshot = await 
    dbinstance.collection("Vente").where("stockId", isEqualTo:id).get();



      for (var document in snapshot.docs) {
        Vente vente = Vente.fromJson(document.id, document.data());
        ventes.add(vente);
      }
      ventes.sort(((a, b) {
          int millisecondsA = a.saveddate.millisecondsSinceEpoch;
          int millisecondsB = b.saveddate.millisecondsSinceEpoch;
          return millisecondsB.compareTo(millisecondsA);
        }));

    return ventes;
  }

  Future<List<Achat>> getAchat(String id) async {

    List<Achat> achats = [];
  
  var snapshot = await 
    dbinstance.collection("Achat").where("stockId", isEqualTo:id).get();


      for (var document in snapshot.docs) {
        Achat achat = Achat.fromJson(document.id, document.data());
        achats.add(achat);
      }
        achats.sort(((a, b) {
          int millisecondsA = a.saveddate.millisecondsSinceEpoch;
          int millisecondsB = b.saveddate.millisecondsSinceEpoch;
          return millisecondsB.compareTo(millisecondsA);
        }));

    return achats;
  }

    Future<List<TransactionToAnotherStock>> getTransactionToAnotherStock(String id) async {
   

    List<TransactionToAnotherStock> transactions = [];

    var snapshot = await 
    dbinstance.collection("TransactionToAnotherStock").where("stockId", isEqualTo:id).get();


      for (var document in snapshot.docs) {
        TransactionToAnotherStock transactionToAnotherStock = TransactionToAnotherStock.fromJson(document.id, document.data());
        transactions.add(transactionToAnotherStock);
      }
      transactions.sort(((a, b) {
          int millisecondsA = a.saveddate.millisecondsSinceEpoch;
          int millisecondsB = b.saveddate.millisecondsSinceEpoch;
          return millisecondsB.compareTo(millisecondsA);
        }));

    return transactions;
  }


Future<List<String>> getAllToken(String ownerId) async {
   
    var snapshot = await
    dbinstance.collection("Tokens").where("ownerId", isEqualTo:ownerId).get();

    List<String> tokens = [];

      for (var document in snapshot.docs) {
        tokens.add(document['value']);
      }

    return tokens;
}

  Future<String> getOneToken(String id) async {

    String token ="" ;
    var docSnapshots = await dbinstance.collection('Tokens').where("userId", isEqualTo: id).get();
  
      for (var document in docSnapshots.docs) {
        token = document['value'];
        break;
      }
    
    return token;

  }

   updateUser(String id, dynamic user) async {
   
   var result ;
   if(user is Owner){
      await dbinstance.collection("Owner").doc(id).set(user.toJson());
   }else{
      await dbinstance.collection("Employee").doc(id).set(user.toJson());
   }

    return result;
  }

  updateNotification(StockNotification notification) async {

    await dbinstance.collection("Notification").doc(notification.id).set(notification.toJson());

  }

   updateProduct(dynamic id, Product product) async {
    
     await dbinstance.collection("Product").doc(id).set(product.toJson());
   
  }

  updateStock(String id, Stock stock) async {

   await dbinstance.collection("Stock").doc(id).set(stock.toJson());
   
  }

  updateSettings(StockManagerAppSettings settings) async {
   
  // var  await dbinstance.collection("Settings").doc(id).set(settings.toJson());
    ///return result;
  }


  deleteOneProduct(id) async {
   //doc.ref.delete()

    var docSnapshot = await dbinstance.collection('Product').doc(id).get();
    if (docSnapshot.exists) {
      docSnapshot.reference.delete();
    }
  }

  deleteAllProduct(id) async {
   
    var docSnapshot = await dbinstance.collection('Product').where("ownerId",isEqualTo: id).get();
    for (var doc in docSnapshot.docs) {
      doc.reference.delete();
    }
  }

deleteOneStock(id) async {
   
    var docSnapshot = await dbinstance.collection('Stock').doc(id).get();
    if (docSnapshot.exists) {
      docSnapshot.reference.delete();
    }
}

  deleteAllStock(id) async {
    var docSnapshot = await dbinstance.collection('Stock').where("ownerId",isEqualTo: id).get();
    for (var doc in docSnapshot.docs) {
      doc.reference.delete();
    }
  }

    deleteOneEmployee(id) async {
   
    var docSnapshot = await dbinstance.collection('Employee').doc(id).get();
    if (docSnapshot.exists) {
      docSnapshot.reference.delete();
    }
  }

  deleteAllEmployee(id) async {
    var docSnapshot = await dbinstance.collection('Employee').where("ownerId",isEqualTo: id).get();
    for (var doc in docSnapshot.docs) {
      doc.reference.delete();
    }
  }


 deleteOwnerAccount(id) async {
   var docSnapshot = await dbinstance.collection('Owner').doc(id).get();
    if (docSnapshot.exists) {
      docSnapshot.reference.delete();
    }

  }


  searchItem({required type,required motif,required ownerId}) async {
   

    if(type=="Product"){

      List<Product> results = [];
      List<Product> products = [];

     var snapshot = await 
     dbinstance.collection("Product").where("ownerId", isEqualTo:ownerId).get();
 
      
      for (var document in snapshot.docs) {
        Product product = Product.fromJson(document.id, document.data()); 
        results.add(product);
      }
      products = results.where((element) {
        String name = element.name.toLowerCase().trim();
        return name.startsWith(motif.toLowerCase().trim()) || name.contains(motif.toLowerCase().trim()) ;
      }).toList();

      return products;
    }else{

      List<Stock> results = [];
      List<Stock> stocks = [];
     var snapshot = await 
     dbinstance.collection("Stock").where("ownerId", isEqualTo:ownerId).get();

      for (var document in snapshot.docs) {
        Stock stock = Stock.fromJson(document.id, document.data()); 
        results.add(stock);
      }
      stocks = results.where((element) {
        String name = element.name.toLowerCase().trim();
        return name.startsWith(motif.toLowerCase().trim()) || name.contains(motif.toLowerCase().trim()) ;
      }).toList();
      return stocks;
    }

  }


  searchTransaction({required type,required date, required stockId}) async {
   

    if(type==stockTransactionTypeAchat){

      List<Achat> achats = [];
     var snapshot = await 
     dbinstance.collection("Achat").where("stockId", isEqualTo:stockId).get();



      for (var document in snapshot.docs) {
        Achat achat = Achat.fromJson(document.id, document.data());

        DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(achat.saveddate.toString());
        var inputDate = DateTime.parse(parseDate.toString());
        var outputFormat = DateFormat('dd/MM/yyyy');
        var outputDate = outputFormat.format(inputDate);

        if(outputDate.contains(date)){
          achats.add(achat);
        }
      }
      return achats;
    }else if(type==stockTransactionTypeVente){
    
      List<Vente> ventes = [];
     var snapshot = await 
     dbinstance.collection("Vente").where("stockId", isEqualTo:stockId).get();

      for (var document in snapshot.docs) {
        Vente vente = Vente.fromJson(document.id, document.data());

        DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(vente.saveddate.toString());
        var inputDate = DateTime.parse(parseDate.toString());
        var outputFormat = DateFormat('dd/MM/yyyy');
        var outputDate = outputFormat.format(inputDate);

        if(outputDate.contains(date)){
          ventes.add(vente);
        }
      }

      return ventes;
    }else{

      List<TransactionToAnotherStock> transactionToAnotherStocks = [];

     var snapshot = await 
     dbinstance.collection("TransactionToAnotherStock").where("stockId", isEqualTo:stockId).get();

      for (var document in snapshot.docs) {
        TransactionToAnotherStock transaction = TransactionToAnotherStock.fromJson(document.id, document.data());

        DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(transaction.saveddate.toString());
        var inputDate = DateTime.parse(parseDate.toString());
        var outputFormat = DateFormat('dd/MM/yyyy');
        var outputDate = outputFormat.format(inputDate);

        if(outputDate.contains(date)){
          transactionToAnotherStocks.add(transaction);
        }
      }
      return transactionToAnotherStocks;
    }

  }
}
