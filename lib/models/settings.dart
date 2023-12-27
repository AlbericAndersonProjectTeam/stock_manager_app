class StockManagerAppSettings {
  String? id;
  //String userId;
  bool lighttheme;
  bool mailalert;
  bool notificationalert;
  bool employeealert;

  StockManagerAppSettings({ 
  this.id,
  //required this.userId,
  this.lighttheme = true,
  this.mailalert  = false,
  this.notificationalert = true,
  this.employeealert = false,
  });

  factory StockManagerAppSettings.fromMap(Map<dynamic,dynamic> data){

    return StockManagerAppSettings(
    id : data['id'].toString(),
    //userId: data['userId'].toString(),
    lighttheme: data['lighttheme']==0 ? false : true,
    notificationalert: data['notificationalert']==0 ? false : true,
    mailalert: data['mailalert']==0 ? false : true,
    employeealert: data['employeealert']==0 ? false : true,
    );

  }

    factory StockManagerAppSettings.fromJson(String id ,Map<String,dynamic> data){

    return StockManagerAppSettings(
    id : id,
   // userId: data['userId'].toString(),
    lighttheme: data['lighttheme']==0 ? false : true,
    notificationalert: data['notificationalert']==0 ? false : true,
    mailalert: data['mailalert']==0 ? false : true,
    employeealert: data['employeealert']==0 ? false : true,
    );

  }


  StockManagerAppSettings copyWith({
    bool? mailalert,
    bool? lighttheme,
    bool? notificationalert,
    bool? employeealert,}){
      return StockManagerAppSettings(
        //userId: userId,
        lighttheme: lighttheme?? this.lighttheme,
        mailalert: mailalert?? this.mailalert,
        notificationalert: notificationalert?? this.notificationalert,
        employeealert: employeealert?? this.employeealert,
      );
  }


toJson (){
  return {
    //"userId" : userId,
    "mailalert" : mailalert.toString(),
    "lighttheme" : lighttheme.toString(),
    "notificationalert" : notificationalert.toString(),
    "employeealert" : employeealert.toString(),
  };
}
  
}
