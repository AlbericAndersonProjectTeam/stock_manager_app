import 'package:stock_manager_app/models/product.dart';
import 'package:stock_manager_app/models/stock.dart';
import 'package:stock_manager_app/models/transactions.dart';
import 'package:stock_manager_app/models/user.dart';

class DataConstantsOfSession{
  List<Product>? products;
  List<Stock>? stocks;
  List<Employee>? employees;
  List<Map<String,dynamic>>? notificationswithstock ;
  Map<String,List<Vente>> ventes = {};
  Map<String,List<Achat>> achats = {};
  Map<String,List<TransactionToAnotherStock>> transfers = {};
  //ventes[stockid] = k;

  DataConstantsOfSession();
}