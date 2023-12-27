import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:stock_manager_app/models/product.dart';

class Stock {
  
  String? id;
  String ownerId;
  String userName;
  String name;
  String location;
  ListLots constituentslots;
  DateTime saveddate;

  Stock({ 
  this.id,
  required this.ownerId,
  required this.name,
  required this.location,
  required this.constituentslots,
  required this.userName,
  required this.saveddate
  });


  factory Stock.simple() {
      final format = DateFormat("dd/mm/yyyy");
      var date = "10/10/2023";
     return Stock(ownerId: "0",userName: "userName", name: "name", location: "location", constituentslots: ListLots(lots: []), saveddate: format.parse(date));
    }

  factory Stock.fromMap(Map<dynamic, dynamic> stock) {
    final format = DateFormat("dd/mm/yyyy");
    return Stock(id:stock["id"].toString(), ownerId :stock["ownerId"].toString() ,userName: stock["userName"], name: stock['name'],location: stock['location'], constituentslots : ListLots.fromJson(stock["constituentslots"]),saveddate: format.parse(stock['saveddate']!));
  }



  factory Stock.fromJson(String id, Map<String,dynamic> data){

   final format = DateFormat("dd/mm/yyyy");
    return Stock(
    id: id,
    ownerId : data['ownerId'].toString(),
    userName: data["userName"],
    name: data['name'],
    location: data['location'],
    constituentslots: ListLots.fromJson(data['constituentslots']),
    saveddate: format.parse(data['saveddate']),
    );

  }

  Stock copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? location,
    ListLots? constituentslots,
    String? userName,
    DateTime? saveddate}){
      return Stock(
        id: id?? this.id,
        ownerId: ownerId?? this.ownerId,
        userName: userName?? this.userName,
        name: name?? this.name,
        location: location?? this.location,
        constituentslots: constituentslots?? this.constituentslots,
        saveddate: saveddate?? this.saveddate,
      );
  }


toJson (){

  DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(saveddate.toString());
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('dd/MM/yyyy');
  var outputDate = outputFormat.format(inputDate);
  return {
    "ownerId" : ownerId,
    "userName" : userName,
    "name" : name,
    "location" : location,
    "constituentslots" : constituentslots.toJson(),
    "saveddate" : outputDate,
  };
}
  
}

class Lot {
  Product product;
  int numberofproduct;
  int seuilinstock;

  Lot({required this.product,required this.numberofproduct,required this.seuilinstock});

  factory Lot.fromJson(Map<String,dynamic> data){
    //print(data);
   return Lot(product: Product.fromMap(data), numberofproduct: int.parse(data['numberofproduct'].toString()), seuilinstock: int.parse(data['seuilinstock'].toString()));
  }

  
  Lot copyWith({
  Product? product,
  int? numberofproduct,
  int? seuilinstock,
  }){
      return Lot(
        product: product?? this.product,
        numberofproduct: numberofproduct?? this.numberofproduct,
        seuilinstock: seuilinstock?? this.seuilinstock,
      );
  }

  toJson(){
    return {
      "product" : product.toJson(),
      "numberofproduct" : numberofproduct,
      "seuilinstock" : seuilinstock
    };
  }
}

class ListLots {
  List<Lot> lots;
  ListLots({required this.lots});


 factory ListLots.fromJson(dynamic data){
      //print("listlot : $data");
      var lotObjsJson = jsonDecode(data.toString()) as List;
      //print("lots-from-db : ${lotObjsJson}");
      List<Lot> decodedlots  = lotObjsJson.map((lotJson) => Lot.fromJson(lotJson)).toList();

      //print(decodedlots);
      
      return ListLots(lots: decodedlots);
  }

  removeLot(Lot lot){
    lots.remove(lot);
  }

  updateLot(Lot newlot ){
    List<Lot> updatedlots = [];

    lots.forEach((lot) {
      if(lot.product==newlot.product){
        lot = newlot;
      }
      updatedlots.add(lot);
     });

    lots = updatedlots;
    
  }

  toJson(){

   /*  String listlotsjson = '{"lots" : [';

    for (var i = 0; i < lots.length; i++) {
      Lot lot = lots[i];
      listlotsjson += "${lot.toJson()}";
      if(i!=lots.length-1){
        listlotsjson+=",";
      }
    }
    listlotsjson+="]}";

    //print("LOTOTJSON : ----$listlotsjson"); */

     String listlotsjson = jsonEncode(lots);

    return listlotsjson;
  }

}
