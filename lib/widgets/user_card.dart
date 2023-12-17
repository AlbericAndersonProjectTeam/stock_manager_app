import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/delete_service.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
import 'package:stock_manager_app/screens/employees/create_employee.dart';

class UserCard extends StatelessWidget{
  const UserCard({super.key});

showBottomSheetMenu(BuildContext context){
  showModalBottomSheet(context: context, builder: (context){
    return Wrap(
            spacing: 10.0,
          children: [
            const SizedBox(height: 20.0,),
           ListTile(
            leading: Icon(Icons.phone),
            title: Text('Contacter par téléphone',style: TextStyle(fontWeight: FontWeight.w500),),
            onTap: () {
              Navigator.of(context).pop();
              
            },
           ),
           ListTile(
            leading: Icon(Icons.mail),
            title: Text('Contacter par mail',style: TextStyle(fontWeight: FontWeight.w500),),
            onTap: () {
              Navigator.of(context).pop();
              
            },
           ),

           ListTile(
            leading: Icon(Icons.edit),
            title: Text('Modifier',style: TextStyle(fontWeight: FontWeight.w500),),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                            CustomPageTransistion(page:  UserCreateScreen(iscreate: false,),duration: 500).maketransition()
                          );
              
            },
           ),
           ListTile(
            leading: Icon(Icons.delete),
            title: Text('Supprimer',style: TextStyle(fontWeight: FontWeight.w500),),
            onTap: () {
              Navigator.of(context).pop();
              DeleteService.showDeleteAlert(context,name: "TONI Parker");
            },
           )
          ],
    );
  });
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
          
         Navigator.of(context).push(
                            CustomPageTransistion(page:  UserCreateScreen(iscreate: false,justview: true,),duration: 500).maketransition()
                          );
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
       const Icon(Icons.file_open,size: 30.0,),
             const Expanded(child: 
              SizedBox(
                width: 150,
                child: 
             ListTile(
              title: Text('TONI Parker',style: TextStyle(fontWeight: FontWeight.w500),),
              subtitle: Text('usermail@gmail.com',maxLines: 1,),
             ),
              )) ,

              IconButton(onPressed: (){
                showBottomSheetMenu(context);
              }, icon: Icon(Icons.more_horiz))
              ]
      ),),
    ),
    );
  }

}