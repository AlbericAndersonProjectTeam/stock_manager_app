import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/notifications.dart';
import 'package:stock_manager_app/models/product.dart';
import 'package:stock_manager_app/models/settings.dart';
import 'package:stock_manager_app/models/stock.dart';
import 'package:stock_manager_app/models/transactions.dart';
import 'package:stock_manager_app/models/user.dart';

class DatabaseService {
  static const _dbname = "StockMangerDb39";
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _db;

  DatabaseService._internal();

  Future<Database?> get database async {
    if (_db != null) {
      return _db;
    }

    _db = await _initDB();
    return _db;
  }

  _initDB() async {
    /*  Directory documentsDirectory = await getApplicationDocumentsDirectory(); */
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, _dbname),
      version: 1,
      onCreate: (db, version) async {

        //create insert owner
        await db.execute(
            "CREATE TABLE Owner ( id INTEGER PRIMARY KEY AUTOINCREMENT,boutique TEXT, name TEXT, firstname TEXT,address TEXT,phonenumber TEXT, email TEXT, password TEXT )");

        await db.execute(
            "INSERT INTO Owner ('boutique', 'name', 'firstname','address','phonenumber', 'email','password') values ('CP-SHOP','AWOLOSSOU', 'Albéric','Golo-Djigbé','+229 90 68 58 26', 'sejoawalan@gmail.com', 'alan1009')");
        
        //create insert employee
        await db.execute(
            "CREATE TABLE Employee ( id INTEGER PRIMARY KEY AUTOINCREMENT,ownerId INTEGER,role TEXT, name TEXT, firstname TEXT,address TEXT,phonenumber TEXT, email TEXT, password TEXT )");

        await db.execute(
            "INSERT INTO Employee ('ownerId','role', 'name', 'firstname','address','phonenumber', 'email','password') values ('1','admin','LARY', 'Alen','Zè','+229 60 68 58 26', 'laryalen@gmail.com', 'alen1009')");

          await db.execute(
            "INSERT INTO Employee ('ownerId','role', 'name', 'firstname','address','phonenumber', 'email','password') values ('1','simple','LAW', 'Charles','Zè','+229 70 68 58 26', 'lawcharles@gmail.com', 'charles1009')");

        //create insert product
        await db.execute(
            "CREATE TABLE Product ( id INTEGER PRIMARY KEY AUTOINCREMENT,ownerId INTEGER,userName TEXT, name TEXT,price TEXT, description TEXT, seuil INTEGER, expireddate TEXT, saveddate TEXT)");
        
        await db.execute(
        "INSERT INTO Product ('ownerId','userName','name','price', 'description', 'seuil' ,'expireddate','saveddate') values (?, ?, ?, ?, ?, ?, ?, ?)",
        ["1","LAW Charles","Matanti Spaghettis","800", "Repellat voluptatum et quia occaecati porro et explicabo quam. Expedita cum sit debitis consequatur sunt. Dolorem quo et eligendi ipsum debitis quisquam fuga.", "30", "10/07/2025","10/12/2023 10:00"]);
         
        await db.execute(
        "INSERT INTO Product ('ownerId','userName','name','price', 'description', 'seuil' ,'expireddate','saveddate') values (?, ?, ?, ?, ?, ?, ?, ?)",
        ["1","LAW Charles","Matanti Coquillettes","800", "Repellat voluptatum et quia occaecati porro et explicabo quam. Expedita cum sit debitis consequatur sunt. Dolorem quo et eligendi ipsum debitis quisquam fuga.", "30", "10/07/2025","10/12/2023 10:30"]);
        
        await db.execute(
        "INSERT INTO Product ('ownerId','userName','name','price', 'description', 'seuil' ,'expireddate','saveddate') values (?, ?, ?, ?, ?, ?, ?, ?)",
        ["1","LAW Charles","Lait Djago","500", "Repellat voluptatum et quia occaecati porro et explicabo quam. Expedita cum sit debitis consequatur sunt. Dolorem quo et eligendi ipsum debitis quisquam fuga.", "30", "10/07/2025","10/12/2023 11:00"]);
         
           await db.execute(
        "INSERT INTO Product ('ownerId','userName','name','price', 'description', 'seuil' ,'expireddate','saveddate') values (?, ?, ?, ?, ?, ?, ?, ?)",
        ["1","LAW Charles","Mayonnaise Calvé","300", "Repellat voluptatum et quia occaecati porro et explicabo quam. Expedita cum sit debitis consequatur sunt. Dolorem quo et eligendi ipsum debitis quisquam fuga.", "30", "10/07/2025","10/12/2023 15:00"]);
         
         
        //create insert stock
         await db.execute(
            "CREATE TABLE Stock ( id INTEGER PRIMARY KEY AUTOINCREMENT,ownerId INTEGER,userName TEXT, name TEXT,location TEXT, constituentslots TEXT, saveddate TEXT)");
        
        await db.execute(
        "INSERT INTO Stock ('ownerId','userName','name','location', 'constituentslots', 'saveddate') values (?, ?, ?, ?, ?, ?)",
        ["1","LARY Alen","Stock primaire","Cotonou", '[{ "product" : {"id" : 1, "ownerId" : 1,"userName" : "LAW Charles", "name" : "Matanti Spaghettis", "price" : "800", "description" : "Repellat voluptatum et quia occaecati porro et explicabo quam. Expedita cum sit debitis consequatur sunt. Dolorem quo et eligendi ipsum debitis quisquam fuga.","seuil":"30","expireddate": "10/07/2025","saveddate" : "10/12/2023 10:00"}, "numberofproduct" : 50,"seuilinstock" : 10},{ "product" : {"id" : 2, "ownerId" : 1, "userName" : "LAW Charles", "name" : "Matanti Coquillettes","price" : "800", "description" : "Repellat voluptatum et quia occaecati porro et explicabo quam. Expedita cum sit debitis consequatur sunt. Dolorem quo et eligendi ipsum debitis quisquam fuga.","seuil":"30","expireddate": "10/07/2025","saveddate" : "10/12/2023 10:30"}, "numberofproduct" : 50,"seuilinstock" : 10},{ "product" : {"id" : 3, "ownerId" : 1,"userName" : "LAW Charles",  "name" : "Lait Djago","price" : "500", "description" : "Repellat voluptatum et quia occaecati porro et explicabo quam. Expedita cum sit debitis consequatur sunt. Dolorem quo et eligendi ipsum debitis quisquam fuga.","seuil":"30","expireddate": "10/07/2025","saveddate" : "10/12/2023 11:00"}, "numberofproduct" : 50,"seuilinstock" : 10},{ "product" : {"id" : 4, "ownerId" : 1,"userName" : "LAW Charles",  "name" : "Mayonnaise Calvé","price" : "300", "description" : "Repellat voluptatum et quia occaecati porro et explicabo quam. Expedita cum sit debitis consequatur sunt. Dolorem quo et eligendi ipsum debitis quisquam fuga.","seuil":"30","expireddate": "10/07/2025","saveddate" : "10/12/2023 15:00"}, "numberofproduct" : 50,"seuilinstock" : 10}]', "10/07/2025"]);
        
        await db.execute(
        "INSERT INTO Stock ('ownerId','userName','name','location', 'constituentslots', 'saveddate') values (?, ?, ?, ?, ?, ?)",
        ["1",'LARY Alen',"Stock secondaire","Parakou", '[{ "product" : {"id" : 1, "ownerId" : 1,"userName" : "LAW Charles",  "name" : "Matanti Spaghettis", "price" : "800", "description" : "Repellat voluptatum et quia occaecati porro et explicabo quam. Expedita cum sit debitis consequatur sunt. Dolorem quo et eligendi ipsum debitis quisquam fuga.","seuil":"30","expireddate": "10/07/2025","saveddate" : "10/12/2023 10:00"}, "numberofproduct" : 80,"seuilinstock" : 10},{ "product" : {"id" : 2, "ownerId" : 1,"userName" : "LAW Charles",  "name" : "Matanti Coquillettes","price" : "800", "description" : "Repellat voluptatum et quia occaecati porro et explicabo quam. Expedita cum sit debitis consequatur sunt. Dolorem quo et eligendi ipsum debitis quisquam fuga.","seuil":"30","expireddate": "10/07/2025","saveddate" : "10/12/2023 10:30"}, "numberofproduct" : 80,"seuilinstock" : 10},{ "product" : {"id" : 3, "ownerId" : 1,"userName" : "LAW Charles",  "name" : "Lait Djago","price" : "500", "description" : "Repellat voluptatum et quia occaecati porro et explicabo quam. Expedita cum sit debitis consequatur sunt. Dolorem quo et eligendi ipsum debitis quisquam fuga.","seuil":"30","expireddate": "10/07/2025","saveddate" : "10/12/2023 11:00"}, "numberofproduct" : 80,"seuilinstock" : 10},{ "product" : {"id" : 4, "ownerId" : 1,"userName" : "LAW Charles",  "name" : "Mayonnaise Calvé","price" : "300", "description" : "Repellat voluptatum et quia occaecati porro et explicabo quam. Expedita cum sit debitis consequatur sunt. Dolorem quo et eligendi ipsum debitis quisquam fuga.","seuil":"30","expireddate": "10/07/2025","saveddate" : "10/12/2023 15:00"}, "numberofproduct" : 80,"seuilinstock" : 10}]', "10/07/2025"]);
        
        
        //create  vente
         await db.execute(
            "CREATE TABLE Vente ( id INTEGER PRIMARY KEY AUTOINCREMENT,stockId INTEGER,userName TEXT, customerName TEXT,soldlots TEXT, saveddate TEXT)");
        
        //create  achat
         await db.execute(
            "CREATE TABLE Achat ( id INTEGER PRIMARY KEY AUTOINCREMENT,stockId INTEGER,userName TEXT, providerName TEXT,boughtlots TEXT, saveddate TEXT)");
        
        
        //create  transactionToAnotherStock
         await db.execute(
            "CREATE TABLE TransactionToAnotherStock ( id INTEGER PRIMARY KEY AUTOINCREMENT,stockId INTEGER,userName TEXT,stocktotransfername TEXT, lots TEXT, saveddate TEXT)");
        
          //create insert notifications
        await db.execute(
            "CREATE TABLE Notification ( id INTEGER PRIMARY KEY AUTOINCREMENT,ownerId INTEGER,stockId INTEGER,title TEXT,content TEXT,viewed BOOLEAN saveddate TEXT)");
        
        
         //create insert settings
        await db.execute(
            "CREATE TABLE Settings ( id INTEGER PRIMARY KEY AUTOINCREMENT,userId TEXT,lighttheme BOOLEAN,mailalert BOOLEAN, notificationalert BOOLEAN, employeealert BOOLEAN )");
        
        await db.execute(
        "INSERT INTO Settings ('userId','lighttheme', 'mailalert', 'notificationalert','employeealert') values (?, ?, ?, ?,?)",
        ["0", true , false , true, false]);
        
        //create insert token
        await db.execute(
            "CREATE TABLE Token (id INTEGER PRIMARY KEY AUTOINCREMENT,value TEXT)");


      },
    );
  }
  
  storeNotification(StockNotification notification) async {
    _db = await database;

          DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(notification.saveddate.toString());
          var inputDate = DateTime.parse(parseDate.toString());
          var outputFormat = DateFormat('dd/MM/yyyy');
          var savedate = outputFormat.format(inputDate);

    var result =  await _db?.execute(
        "INSERT INTO Notification ('ownerId', 'stockId', 'title', 'content','viewed', 'saveddate') values (?, ?, ?, ?, ?, ?)",
        [int.parse(notification.ownerId),int.parse(notification.stockId),notification.title, notification.content,notification.viewed, savedate]);

        return result;
  }

  storeOwner(Owner owner) async {
    _db = await database;

    var result =  await _db?.execute(
        "INSERT INTO Owner ('boutique', 'name', 'firstname','address','phonenumber', 'email','password') values (?, ?, ?, ?, ?, ?, ?)",
        [owner.boutique,owner.name, owner.firstname,owner.address,owner.phonenumber, owner.email, owner.password]);

        return result;
  }


  storeEmployee(Employee employee) async {
    _db = await database;

   var result = await _db?.execute(
        "INSERT INTO Employee ('ownerId','role', 'name', 'firstname','address','phonenumber', 'email','password') values (?, ?, ?, ?, ?, ?, ?, ?)",
        [int.parse(employee.ownerId),employee.role, employee.name, employee.firstname,employee.address,employee.phonenumber, employee.email, employee.password]);

        return result;
  }

  storeProduct(Product product) async {
    _db = await database;

        var expireddate = "";
        var saveddate = "";
        if(product.expireddate!=null){
          DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(product.expireddate.toString());
          var inputDate = DateTime.parse(parseDate.toString());
          var outputFormat = DateFormat('dd/MM/yyyy');
          expireddate = outputFormat.format(inputDate);
        }
          DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(product.saveddate.toString());
          var inputDate = DateTime.parse(parseDate.toString());
          var outputFormat = DateFormat('dd/MM/yyyy hh:mm');
          saveddate = outputFormat.format(inputDate);

   var result =  await _db?.execute(
        "INSERT INTO Product ('ownerId','userName','name','price', 'description', 'seuil' ,'expireddate','saveddate') values (?, ?, ?, ?, ?, ?, ?, ?)",
        [int.parse(product.ownerId),product.userName, product.name, product.price, product.description,product.seuil, expireddate, saveddate]);
        
        return result;
  }

  storeStock(Stock stock) async {
    _db = await database;


  DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(stock.saveddate.toString());
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('dd/MM/yyyy');
  var outputDate = outputFormat.format(inputDate);

   var result = await _db?.execute(
        "INSERT INTO Stock ('ownerId','userName', 'name', 'location','constituentslots','saveddate') values (?, ?, ?, ?, ?, ?)",
        [int.parse(stock.ownerId),stock.userName, stock.name, stock.location, stock.constituentslots.toJson(), outputDate]);
        
        return result;
  }

  storeVente(Vente vente) async {
    _db = await database;


  DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(vente.saveddate.toString());
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat("dd/MM/yyyy hh:mm");
  var outputDate = outputFormat.format(inputDate);

   var result = await _db?.execute(
        "INSERT INTO Vente ('stockId','userName', 'customerName','soldlots','saveddate') values (?, ?, ?, ?, ?)",
        [int.parse(vente.stockId),vente.userName, vente.customerName, vente.soldlots.toJson(), outputDate]);
        
        return result;
  }

  storeAchat(Achat achat) async {
    _db = await database;


  DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(achat.saveddate.toString());
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat("dd/MM/yyyy hh:mm");
  var outputDate = outputFormat.format(inputDate);

   var result = await _db?.execute(
        "INSERT INTO Achat ('stockId','userName', 'providerName','boughtlots','saveddate') values (?, ?, ?, ?, ?)",
        [int.parse(achat.stockId),achat.userName, achat.providerName, achat.boughtlots.toJson(), outputDate]);
        
        return result;
  }

   storeToken(value) async {
    _db = await database;

   var result = await _db?.execute(
        "INSERT INTO Token ('value') values (?)",
        [value]);
        
        return result;
  }

  storeTransaction(TransactionToAnotherStock transaction) async {
    _db = await database;


  DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(transaction.saveddate.toString());
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat("dd/MM/yyyy hh:mm");
  var outputDate = outputFormat.format(inputDate);

   var result = await _db?.execute(
        "INSERT INTO TransactionToAnotherStock ('stockId','userName','stocktotransfername','lots','saveddate') values (?, ?, ?, ?, ?)",
        [int.parse(transaction.stockId), transaction.userName, transaction.stocktotransfername, transaction.lots.toJson(), outputDate]);
        
        return result;
}

Future<List<StockNotification>> getAllNotifications(String ownerId) async {
    _db = await database;
    List<Map>? results ;
    List<StockNotification> notifications = [];
      results = await _db?.query("Notification", where: "ownerId = ?", orderBy: "id DESC",whereArgs: [int.parse(ownerId)]);
      results?.forEach((result) {
      StockNotification notification = StockNotification.fromMap(result);
      notifications.add(notification);
    });
    return notifications;
}



Future<dynamic> getUserWithId(String id,String type) async {
    _db = await database;
    List<Map>? results ;
    var users = [];
    if(type=="Owner"){
      results = await _db?.query("Owner", where: "id = ?", orderBy: "id DESC",whereArgs: [int.parse(id)]);
      results?.forEach((result) {
      Owner owner = Owner.fromMap(result);
      users.add(owner);
    });
    }else{
      results = await _db?.query("Employee", where: "id = ?", orderBy: "id DESC",whereArgs: [int.parse(id)]);
      results?.forEach((result) {
      Employee employee = Employee.fromMap(result);
      users.add(employee);
    });
    }
    return users.first;
  }

  Future<User?> getUserWithEmail(String email) async {
    _db = await database;
    bool isowner = true;
    List<Map>? results = await _db?.query("Owner", where: "email = ?", orderBy: "id DESC",whereArgs: [email]);
    if(results!.isEmpty){  
        isowner = false;
        results = await _db?.query("Employee", where: "email = ?", orderBy: "id DESC",whereArgs: [email]);
    }
    var users = [];
    if(isowner){
      results?.forEach((result) {
      Owner owner = Owner.fromMap(result);
      users.add(owner);
    });
    }else{
      results?.forEach((result) {
      Employee employee = Employee.fromMap(result);
      users.add(employee);
    });
    }
    return users.isNotEmpty ? users.first : null;
  }

Future<User> getUserWithCredentials(String email, String password) async {
    _db = await database;
    bool isowner = true;
    List<Map>? results = await _db?.query("Owner", where: "email = ? AND password = ?", orderBy: "id DESC",whereArgs: [email,password]);
    if(results!.isEmpty){  
        isowner = false;
        results = await _db?.query("Employee", where: "email = ? AND password = ?", orderBy: "id DESC",whereArgs: [email,password]);
    }
    print("---$results----");
    var users = [];
    if(isowner){
      results?.forEach((result) {
      Owner owner = Owner.fromMap(result);
      users.add(owner);
    });
    }else{
      results?.forEach((result) {
      Employee employee = Employee.fromMap(result);
      users.add(employee);
    });
    }
    return users.first;
  }

  Future<List<Employee>> getEmployee(String ownerId) async {
    _db = await database;
    List<Map>? results = await _db?.query("Employee", where: "ownerId = ?", orderBy: "id DESC",whereArgs: [int.parse(ownerId)]);
    List<Employee> employees = [];

    results?.forEach((result) {
      Employee employee = Employee.fromMap(result);
      employees.add(employee);
    });

    return employees;
  }

   Future<List<Employee>> getAllEmployee() async {
    _db = await database;
    List<Map>? results = await _db?.query("Employee", orderBy: "id DESC");
    List<Employee> employees = [];

    results?.forEach((result) {
      Employee employee = Employee.fromMap(result);
      employees.add(employee);
    });

    return employees;
  }
  
  Future<List<Product>> getProducts(String id) async {
    _db = await database;
    List<Map>? results = await _db?.query("Product", where: "ownerId = ?", orderBy: "id DESC",whereArgs: [int.parse(id)]);

    List<Product> products = [];

    results?.forEach((result) {
      Product product = Product.fromMap(result);
      products.add(product);
    });

    return products;
  }

    Future<List<Stock>> getStocks(String id) async {
    _db = await database;
    List<Map>? results = await _db?.query("Stock", where: "ownerId = ?", orderBy: "id DESC",whereArgs: [int.parse(id)]);

    List<Stock> stocks = [];

    results?.forEach((result) {
      Stock stock = Stock.fromMap(result);
      stocks.add(stock);
    });

    return stocks;
  }

    Future<Stock> getOneStock(String id) async {
    _db = await database;
    List<Map>? results = await _db?.query("Stock", where: "id = ?", orderBy: "id DESC",whereArgs: [int.parse(id)]);

    List<Stock> stocks = [];

    results?.forEach((result) {
      Stock stock = Stock.fromMap(result);
      stocks.add(stock);
    });

    return stocks.first;
  }

  Future<List<Vente>> getVente(String id) async {
    _db = await database;
    List<Map>? results = await _db?.query("Vente", where: "stockId = ?", orderBy: "id DESC",whereArgs: [int.parse(id)]);

    List<Vente> ventes = [];

    results?.forEach((result) {
      Vente vente = Vente.fromMap(result);
      ventes.add(vente);
    });

    return ventes;
  }

  Future<List<Achat>> getAchat(String id) async {
    _db = await database;
    List<Map>? results = await _db?.query("Achat", where: "stockId = ?", orderBy: "id DESC",whereArgs: [int.parse(id)]);

    List<Achat> achats = [];

    results?.forEach((result) {
      Achat achat = Achat.fromMap(result);
      achats.add(achat);
    });

    return achats;
  }

    Future<List<TransactionToAnotherStock>> getTransactionToAnotherStock(String id) async {
    _db = await database;
    List<Map>? results = await _db?.query("TransactionToAnotherStock", where: "stockId = ?", orderBy: "id DESC",whereArgs: [int.parse(id)]);

    List<TransactionToAnotherStock> transactions = [];

    results?.forEach((result) {
      TransactionToAnotherStock transaction = TransactionToAnotherStock.fromMap(result);
      transactions.add(transaction);
    });

    return transactions;
  }


Future<String> getToken() async {
    _db = await database;
    List<Map>? results ;
    String token = "";
    
      results = await _db?.query("Token", where: "id = ?",whereArgs: [1]);
      results?.forEach((result) {
      token = result['value'];
    });
    return token;
}

Future<StockManagerAppSettings> getSettings() async {
    _db = await database;
    List<Map>? results ;
    StockManagerAppSettings settings = StockManagerAppSettings() ;
    
      results = await _db?.query("Settings", where: "id = ?",whereArgs: [1]);
      results?.forEach((result) {
      settings = StockManagerAppSettings.fromMap(result);
    });
    return settings;
}

  updateUser(String id, dynamic user) async {
    _db = await database;
   
   var result;
   if(user is Owner){
    result = await _db?.update("Owner", user.toJson(),
    where: "id = ?", whereArgs: [int.parse(id)]);
   }else{
     result = await _db?.update("Employee", user.toJson(),
    where: "id = ?", whereArgs: [int.parse(id)]);
   }

    return result;
  }

   updateProduct(dynamic id, Product product) async {
    _db = await database;
   
   var result = await _db?.update("Product", product.toJson(),
    where: "id = ?", whereArgs: [int.parse(id)]);
   
    return result;
  }

  updateStock(String id, Stock stock) async {
    _db = await database;
   print("id : $id");
   var result = await _db?.update("Stock", stock.toJson(),
    where: "id = ?", whereArgs: [int.parse(id)]);
   
    return result;
  }

  updateSettings(StockManagerAppSettings settings) async {
    _db = await database;
   
   var result = await _db?.update("Settings", settings.toJson(),
    where: "id = ?", whereArgs: [1]);
   
    return result;
  }


  updateNotification(StockNotification notification) async {
    _db = await database;
   
   var result = await _db?.update("Notification", notification.toJson(),
    where: "id = ?", whereArgs: [notification.id]);
   
    return result;
  }


  deleteOneProduct(id) async {
    _db = await database;
   
   var result = await _db?.delete("Product",
    where: "id = ?", whereArgs: [int.parse(id)]);
   
    return result;
  }

  deleteAllProduct(id) async {
    _db = await database;
   
   var result = await _db?.delete("Product");
   
    return result;
  }

    deleteOneStock(id) async {
    _db = await database;
   
   var result = await _db?.delete("Stock",
    where: "id = ?", whereArgs: [int.parse(id)]);
   
    return result;
  }

  deleteAllStock(id) async {
    _db = await database;
   
   var result = await _db?.delete("Stock");
   
    return result;
  }

    deleteOneEmployee(id) async {
    _db = await database;
   
   var result = await _db?.delete("Employee",
    where: "id = ?", whereArgs: [int.parse(id)]);
   
    return result;
  }

  deleteAllEmployee(id) async {
    _db = await database;
   
   var result = await _db?.delete("Employee");
   
    return result;
  }

  searchItem({required type,required motif, required ownerId}) async {
    var results;
    _db = await database;

    if(type=="Product"){
     results = await _db?.query("Product", where: "ownerId = ? AND name LIKE ? OR name LIKE ?", orderBy: "id DESC",whereArgs: [ownerId,'$motif%','%$motif%']);

      List<Product> products = [];

      results?.forEach((result) {
        Product product = Product.fromMap(result);
        products.add(product);
      });

      return products;
    }else{results = await _db?.query("Stock", where: "ownerId = ?  AND name LIKE ? OR name LIKE ?", orderBy: "id DESC",whereArgs: [ownerId,'$motif%','%$motif%']);

      List<Stock> stocks = [];

      results?.forEach((result) {
        Stock stock = Stock.fromMap(result);
        stocks.add(stock);
      });
      return stocks;
    }

  }


  searchTransaction({required type,required date,required ownerId}) async {
    var results;
    _db = await database;

    if(type==stockTransactionTypeAchat){
     results = await _db?.query("Achat", where: "ownerId = ? AND saveddate LIKE ?", orderBy: "id DESC",whereArgs: [ownerId,'%$date%']);

      List<Achat> achats = [];

      results?.forEach((result) {
        Achat achat = Achat.fromMap(result);
        achats.add(achat);
      });

      return achats;
    }else if(type==stockTransactionTypeVente){
      results = await _db?.query("Vente", where: "ownerId = ? AND saveddate LIKE ?", orderBy: "id DESC",whereArgs: [ownerId,'%$date%']);

      List<Vente> ventes = [];

      results?.forEach((result) {
        Vente vente = Vente.fromMap(result);
        ventes.add(vente);
      });
      return ventes;
    }else{
      results = await _db?.query("TransactionToAnotherStock", where: "ownerId = ? AND saveddate LIKE ?", orderBy: "id DESC",whereArgs: [ownerId,'%$date%']);

      List<TransactionToAnotherStock> transactionToAnotherStocks = [];

      results?.forEach((result) {
        TransactionToAnotherStock transactionToAnotherStock = TransactionToAnotherStock.fromMap(result);
        transactionToAnotherStocks.add(transactionToAnotherStock);
      });
      return transactionToAnotherStocks;
    }

  }
}


