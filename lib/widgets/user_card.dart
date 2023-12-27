import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/constants/delete_service.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/user.dart';
import 'package:stock_manager_app/screens/employees/create_employee.dart';
import 'package:url_launcher/url_launcher.dart';

class UserCard extends StatelessWidget{
  const UserCard({super.key, required this.employee, required this.canDelete});
  final Employee employee;
  final bool canDelete;
showBottomSheetMenu(BuildContext context){
  showModalBottomSheet(context: context, builder: (context){
    return Wrap(
            spacing: 10.0,
          children: [
            const SizedBox(height: 20.0,),
           ListTile(
            leading: Icon(Icons.phone),
            title: Text('Contacter par téléphone',style: TextStyle(fontWeight: FontWeight.w500),),
            onTap: () async {
              Navigator.of(context).pop();
               final Uri params = Uri(
                scheme: 'tel',
                path: employee.phonenumber,
              );

             if(await canLaunchUrl(params)){
                 await launchUrl(params);
             }else{
              ToastMessage(message: "Action impossible sur cet appareil.");
             }
            },
           ),
           ListTile(
            leading: Icon(Icons.mail),
            title: Text('Contacter par mail',style: TextStyle(fontWeight: FontWeight.w500),),
            onTap: () async {
              Navigator.of(context).pop();
              String title = "Contact depuis Stock Manager";
              String message= "";
              final Uri params = Uri(
                scheme: 'mailto',
                path: employee.email,
                query: 'subject=$title&body=$message',
              );

                try {
                   await launchUrl(params);
                } catch (e) {
                    ToastMessage(message: "Action impossible sur cet appareil.");
                }
              
            },
           ),

          /*  ListTile(
            leading: Icon(Icons.edit),
            title: Text('Modifier',style: TextStyle(fontWeight: FontWeight.w500),),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                            CustomPageTransistion(page:  UserCreateScreen(iscreate: false,),duration: 500).maketransition()
                          );
              
            },
           ), */
           canDelete ? ListTile(
            leading: Icon(Icons.delete),
            title: Text('Supprimer',style: TextStyle(fontWeight: FontWeight.w500),),
            onTap: () {
              Navigator.of(context).pop();
              DeleteService.showDeleteAlert(context,employee);
            },
           ) : Container(),
          ],
    );
  });
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
            bool isconnectedUser = false;
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String email =  prefs.getString('userEmail')!;
            if(email == employee.email){
              isconnectedUser = true;
            }

         Navigator.of(context).push(
                            CustomPageTransistion(page:  UserCreateScreen(iscreate: false,justview: true,isconnectedUser: isconnectedUser, user:employee),duration: 500).maketransition()
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
            Expanded(child: 
              SizedBox(
                width: 150,
                child: 
             ListTile(
              title: Text('${employee.name} ${employee.firstname}',style: const TextStyle(fontWeight: FontWeight.w500),),
              subtitle: Text(employee.email,maxLines: 1,),
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