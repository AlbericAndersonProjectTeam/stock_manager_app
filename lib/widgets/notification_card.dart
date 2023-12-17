import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget{
  const NotificationCard({super.key});


  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onDoubleTap: (){
         
      },
      child: Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4),
  ),
  clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.all(5.0),
      child: Padding(padding: const EdgeInsets.all(10.0),child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
       const Icon(Icons.notifications_active,size: 30.0,),
             const Expanded(child: 
              SizedBox(
                width: 150,
                child: 
             ListTile(
              title: Text('Titre',style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text('Matanti pour une saveur Matanti pour une saveur ... Matanti pour une saveur ...',),
             ),
              )) ,
          IconButton(onPressed: (){

          }, icon: Icon(Icons.read_more))
        ],
      ),),
    ),
    );
  }

}