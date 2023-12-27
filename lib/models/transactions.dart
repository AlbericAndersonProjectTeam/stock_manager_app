import 'package:intl/intl.dart';
import 'package:stock_manager_app/models/stock.dart';

class StockTransaction{}

//Vente
class Vente extends StockTransaction{
  
  String? id;
  String stockId;
  String customerName;
  ListLots soldlots;
  String? userName;
  DateTime saveddate;

  Vente({ 
  this.id,
  required this.stockId,
  required this.customerName,
  required this.soldlots,
  required this.userName,
  required this.saveddate
  });


  factory Vente.simple() {
      final format = DateFormat("dd/MM/yyyy HH:mm");
      var date = "10/10/2023 15:00";
     return Vente(stockId: "0", customerName: "name", soldlots: ListLots(lots: []),userName: "userName", saveddate: format.parse(date));
    }

  factory Vente.fromMap(Map<dynamic, dynamic> vente) {
    final format = DateFormat("dd/MM/yyyy HH:mm");
    return Vente(id: vente["id"].toString(), stockId : vente["stockId"].toString() ,customerName: vente['customerName'], soldlots : ListLots.fromJson(vente["soldlots"]),userName: vente["userName"], saveddate: format.parse(vente['saveddate']!));
  }



  factory Vente.fromJson(String id,Map<String,dynamic> data){

   final format = DateFormat("dd/MM/yyyy HH:mm");
    return Vente(
    id: id,
    stockId : data['stockId'].toString(),
    customerName: data['customerName'],
    soldlots: ListLots.fromJson(data['soldlots']),
    userName: data["userName"],
    saveddate: format.parse(data['saveddate']),
    );

  }

  Vente copyWith({
    String? id,
    String? stockId,
    String? customerName,
    String? userName,
    ListLots? soldlots,
    DateTime? saveddate}){
      return Vente(
        id: id?? this.id,
        stockId: stockId?? this.stockId,
        customerName: customerName?? this.customerName,
        soldlots: soldlots?? this.soldlots,
        userName: userName?? this.userName,
        saveddate: saveddate?? this.saveddate,
      );
  }


toJson (){

  DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(saveddate.toString());
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat("dd/MM/yyyy HH:mm");
  var outputDate = outputFormat.format(inputDate);
  print('tojson date : $outputDate');
  return {
    "stockId" : stockId,
    "customerName" : customerName,
    "soldlots" : soldlots.toJson(),
    "saveddate" : outputDate,
    "userName" : userName,
  };
}
  
}


//Achat
class Achat  extends StockTransaction{
  
  String? id;
  String stockId;
  String providerName;
  ListLots boughtlots;
  DateTime saveddate;
  String userName;

  Achat({ 
  this.id,
  required this.stockId,
  required this.providerName,
  required this.boughtlots,
  required this.saveddate,
  required this.userName
  });


  factory Achat.simple() {
      final format = DateFormat("dd/MM/yyyy HH:mm");
      var date = "10/10/2023";
     return Achat(stockId: "0", providerName: "name", boughtlots: ListLots(lots: []), saveddate: format.parse(date),userName: "userName");
    }

  factory Achat.fromMap(Map<dynamic, dynamic> achat) {
    final format = DateFormat("dd/MM/yyyy HH:mm");
    return Achat(id: achat["id"].toString(), stockId : achat["stockId"].toString() ,providerName: achat['providerName'], boughtlots : ListLots.fromJson(achat["boughtlots"]),saveddate: format.parse(achat['saveddate']!),userName: achat['userName']);
  }



  factory Achat.fromJson(String id,Map<String,dynamic> data){

   final format = DateFormat("dd/MM/yyyy HH:mm");
    return Achat(
    id:id,
    stockId : data['stockId'].toString(),
    providerName: data['providerName'],
    boughtlots: ListLots.fromJson(data['boughtlots']),
    saveddate: format.parse(data['saveddate']),
    userName: data['userName']
    );

  }

  Achat copyWith({
    String? id,
    String? stockId,
    String? providerName,
    ListLots? boughtlots,
    String? userName,
    DateTime? saveddate}){
      return Achat(
        id: id?? this.id,
        stockId: stockId?? this.stockId,
        providerName: providerName?? this.providerName,
        boughtlots: boughtlots?? this.boughtlots,
        userName: userName?? this.userName,
        saveddate: saveddate?? this.saveddate,
      );
  }


toJson (){

  DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(saveddate.toString());
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat("dd/MM/yyyy HH:mm");
  var outputDate = outputFormat.format(inputDate);
  return {
    "stockId" : stockId,
    "providerName" : providerName,
    "boughtlots" : boughtlots.toJson(),
    "userName" : userName,
    "saveddate" : outputDate,
  };
}
  
}


//Transfert
class TransactionToAnotherStock  extends StockTransaction {
  
  String? id;
  String stockId;
  String stocktotransfername;
  ListLots lots;
  String userName;
  DateTime saveddate;

  TransactionToAnotherStock({ 
  this.id,
  required this.stockId,
  required this.stocktotransfername,
  required this.lots,
  required this.userName,
  required this.saveddate
  });


  factory TransactionToAnotherStock.simple() {
      final format = DateFormat("dd/MM/yyyy HH:mm");
      var date = "10/10/2023";
     return TransactionToAnotherStock(stockId: "0",stocktotransfername: "name", lots: ListLots(lots: []),userName: "userName", saveddate: format.parse(date));
    }

  factory TransactionToAnotherStock.fromMap(Map<dynamic, dynamic> transactionToAnotherStock) {
    final format = DateFormat("dd/MM/yyyy HH:mm");
    return TransactionToAnotherStock(id: transactionToAnotherStock["id"].toString(), stocktotransfername: transactionToAnotherStock["stocktotransfername"].toString(), stockId : transactionToAnotherStock["stockId"].toString() , lots : ListLots.fromJson(transactionToAnotherStock["lots"]),userName: transactionToAnotherStock["userName"], saveddate: format.parse(transactionToAnotherStock['saveddate']!));
  }



  factory TransactionToAnotherStock.fromJson(String id, Map<String,dynamic> data){

   final format = DateFormat("dd/MM/yyyy HH:mm");
    return TransactionToAnotherStock(
    id: id,
    stockId : data['stockId'].toString(),
    stocktotransfername: data['stocktotransfername'],
    lots: ListLots.fromJson(data['lots']),
    userName: data['userName'],
    saveddate: format.parse(data['saveddate']),
    );

  }

  TransactionToAnotherStock copyWith({
    String? id,
    String? stockId,
    String? stocktotransfername,
    String? userName,
    ListLots? lots,
    DateTime? saveddate}){
      return TransactionToAnotherStock(
        id: id?? this.id,
        stockId: stockId?? this.stockId,
        stocktotransfername: stocktotransfername?? this.stocktotransfername,
        lots: lots?? this.lots,
        userName: userName?? this.userName,
        saveddate: saveddate?? this.saveddate,
      );
  }


toJson (){

  DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(saveddate.toString());
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat("dd/MM/yyyy HH:mm");
  var outputDate = outputFormat.format(inputDate);
  return {
    "stockId" : stockId,
    "lots" : lots.toJson(),
    "saveddate" : outputDate,
    "userName" : userName,
  };
}
  
}


