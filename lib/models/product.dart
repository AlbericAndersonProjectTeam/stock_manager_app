import 'package:intl/intl.dart';

class Product {
  
  String? id;
  String ownerId;
  String userName;
  String name;
  int price;
  String description;
  int? seuil;
  DateTime? expireddate;
  DateTime saveddate;

  Product({ 
  this.id,
  required this.ownerId,
  required this.userName,
  required this.name,
  required this.price,
  required this.description,
  required this.saveddate,
  this.seuil,
  this.expireddate
  });

  factory Product.simple(){
    final savedateformat = DateFormat("dd/MM/yyyy hh:mm");
      var saveddate =  "10/10/10 12:00";
    return Product(ownerId: "-1", name: "name", price: 10, description: "description",userName: "userName",saveddate: savedateformat.parse(saveddate));
  }

  factory Product.fromMap(Map<dynamic, dynamic> product) {
    final savedateformat = DateFormat("dd/MM/yyyy hh:mm");
    final expireddateformat = DateFormat("dd/MM/yyyy");
    product = product['product']?? product; //because for json of stock lots
   //print("prod--${product}");
    return Product(id: product["id"].toString() , ownerId : product["ownerId"].toString(),userName: product["userName"], name: product['name'],price: int.parse(product['price'].toString()), description : product["description"] ,seuil: product['seuil']!="null" ? int.parse(product['seuil'].toString()) : null, expireddate: product['expireddate']!= "" ? expireddateformat.parse(product['expireddate']!) : null ,saveddate : savedateformat.parse(product['saveddate']));
  }

  factory Product.fromJson(String id, Map<String,dynamic> data){ 
    final savedateformat = DateFormat("dd/MM/yyyy hh:mm");
    final expireddateformat = DateFormat("dd/MM/yyyy");

    return Product(
    id: id,
    ownerId : data['ownerId'].toString(),
    userName: data["userName"],
    name: data['name'],
    price: int.parse(data['price'].toString()),
    description: data['description'],
    seuil: int.parse(data['seuil'].toString()),
    expireddate: data['expireddate'] != "" ? expireddateformat.parse(data['expireddate']) : null,
    saveddate: savedateformat.parse(data['saveddate']),
    );

  }

  Product copyWith({
    String? id,
    String? ownerId,
    String? userName,
    String? name,
    int? price,
    String? description,
    int? seuil,
    DateTime? expireddate,
    DateTime? saveddate}){
      return Product(
        id: id?? this.id,
        ownerId: ownerId?? this.ownerId,
        userName: userName?? this.userName,
        name: name?? this.name,
        price: price?? this.price,
        description: description?? this.description,
        seuil: seuil?? this.seuil,
        expireddate: expireddate?? this.expireddate,
        saveddate: saveddate?? this.saveddate,
      );
  }


toJson (){
 var expireddatetostring = "";
 if(expireddate!=null){
   DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(expireddate.toString());
  var inputDate = DateTime.parse(parseDate.toString());
  var expireddateformat = DateFormat("dd/MM/yyyy");
   expireddatetostring = expireddateformat.format(inputDate);
 }
   DateTime parseDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(saveddate.toString());
  var inputDate = DateTime.parse(parseDate.toString());
  var saveddatedateformat = DateFormat("dd/MM/yyyy hh:mm");
   var saveddatetostring = saveddatedateformat.format(inputDate);

  return {
    "ownerId" : ownerId,
    "userName" : userName,
    "name" : name,
    "price" : price,
    "description" : description,
    "seuil" : seuil,
    "expireddate" :expireddatetostring,
    "saveddate" : saveddatetostring
  };
}
  
}
