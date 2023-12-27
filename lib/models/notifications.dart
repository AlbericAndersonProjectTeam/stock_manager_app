import 'package:intl/intl.dart';

class StockNotification {
  
  String? id;
  String ownerId;
  String stockId;
  String title;
  String content;
  bool viewed;
  DateTime saveddate;

  StockNotification({ 
  this.id,
  this.ownerId = "0",
  this.title  = "title",
  this.content = "content",
  this.viewed = false,
  required this.stockId,
  required this.saveddate,
  });

  factory StockNotification.fromJson(String id, Map<String,dynamic> data){

    final format = DateFormat("dd/MM/yyyy HH:mm");
    return StockNotification(
    id : id ,
    ownerId: data['ownerId'].toString(),
    stockId: data['stockId'].toString(),
    title: data['title'],
    content: data['content'],
    viewed: data['viewed'],
    saveddate: format.parse(data['saveddate']),
    );

  }

  factory StockNotification.fromMap(Map<dynamic,dynamic> data){

    final format = DateFormat("dd/MM/yyyy HH:mm");

    return StockNotification(
    id : data['id'].toString(),
    ownerId: data['ownerId'].toString(),
    stockId: data['stockId'].toString(),
    title: data['title'],
    content: data['content'],
    viewed: data['viewed'],
    saveddate: format.parse(data['saveddate']),
    );

  }

 /*  Notification copyWith({
    bool? mailalert,
    bool? lighttheme,
    bool? notificationalert,
    bool? employeealert,}){
      return Notification(
        lighttheme: lighttheme?? this.lighttheme,
        mailalert: mailalert?? this.mailalert,
        notificationalert: notificationalert?? this.notificationalert,
        employeealert: employeealert?? this.employeealert,
      );
  } */


toJson (){

  DateTime parseDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(saveddate.toString());
  var inputDate = DateTime.parse(parseDate.toString());
  var saveddatedateformat = DateFormat("dd/MM/yyyy HH:mm");
   var saveddatetostring = saveddatedateformat.format(inputDate);
  return {
    "ownerId" : ownerId,
    "stockId" : stockId,
    "title" :title,
    "content" : content,
    "viewed" : viewed,
    "saveddate" : saveddatetostring
  };
}
  
}
