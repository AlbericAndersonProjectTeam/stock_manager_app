import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/onprocess_error.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/user.dart';
import 'package:stock_manager_app/screens/employees/create_employee.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/widgets/user_card.dart';

class EmployeeHomeScreen extends StatefulWidget {
  @override
  EmployeeHomeScreenState createState() => EmployeeHomeScreenState();
}
 
class EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  List<Employee> employees = [];
  List<Employee> admins = [];
  List<Employee> simpleemployees = [];
  bool isOwner = false;
  bool dataloaded = false;
  static  EmployeeHomeScreenState? state ;

  refresh(newadmins,newsimpleemployees){
    if(mounted){
      setState(() {
      admins = newadmins;
      simpleemployees = newsimpleemployees;
    });
    }
  }

  loadData() async {
    try {

      state = this;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ownerId =  prefs.getString('ownerId')!;
      print('ownerId : $ownerId');
      int isOwnerPrefs = prefs.getInt('isOwner')!;
      if(isOwnerPrefs==1) isOwner = true;
      if(DATACONSTANTSOFSESSION.employees != null){
        employees = DATACONSTANTSOFSESSION.employees! ;
      }else{
        employees =  await stockManagerdatabase.getEmployee(ownerId);
        DATACONSTANTSOFSESSION.employees = employees;
      }
      admins = [];
      simpleemployees = [];
      for (var employee in employees) {
          if(employee.role=="admin"){
            admins.add(employee);
          }else{
            simpleemployees.add(employee);
          }
      }

    } catch (e) {
      ToastMessage(message: "Une erreur s'est produite.").showToast();
    }
    if(mounted){
    setState(() {
      dataloaded = true;
    });
    }

  }

  @override
  void initState() {
    super.initState(); 
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadData();
         if(mounted){
        setState(() { });    
     }   
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height
          child:AppBar(
          elevation: 0.0,
          bottom: const  TabBar(
            unselectedLabelColor : Colors.white,
            labelColor: Colors.white,
            indicatorColor: secondaryColor,
            labelStyle: TextStyle(fontSize: 20.0),
            tabs: [
              Tab(text: "Administrateurs",),
              Tab( text: "Employés"),
            ],
          ),
        )
            // ...
          ),
        body: TabBarView(
          children: [
           dataloaded ? UserListView(users: admins,areadmin: true,isOwner:isOwner) : const OnProcess(),
           dataloaded ? UserListView(users: simpleemployees,areadmin: false,isOwner:isOwner) : const OnProcess(),
          ],
        ),
      floatingActionButton: isOwner ? FloatingActionButton(onPressed: (){

         Navigator.of(context).push(
                            CustomPageTransistion(page:  UserCreateScreen(),duration: 500).maketransition()
                          );
                          
      },child: const Icon(Icons.add,color: Colors.white,)
      ) : null,
    ));
  }
}


class UserListView extends StatelessWidget{
  const UserListView({super.key,required this.users,required this.areadmin, required this.isOwner});
  final List  users;
  final bool areadmin;
  final bool isOwner;
  @override
  Widget build(BuildContext context) {
    String emptyText = areadmin ? "Aucun administrateur":"Aucun employé";
   return users.isNotEmpty ? ListView.builder(
    itemCount: users.length,
    itemBuilder: (context,index){
      return UserCard(employee : users[index],canDelete:isOwner);
   }) : Container(
    width: MediaQuery.of(context).size.width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/Images/Bg_aucun_employe.png",width: 250.0,),
         Text(emptyText,style: const TextStyle(color: primaryColor,fontWeight: FontWeight.bold),)
      ],
    ),
   );
  }

}