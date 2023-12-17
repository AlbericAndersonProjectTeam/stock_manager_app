import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
import 'package:stock_manager_app/screens/employees/create_employee.dart';
import 'package:stock_manager_app/styles/colors.dart';
import 'package:stock_manager_app/widgets/user_card.dart';

class EmployeeHomeScreen extends StatefulWidget {
  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}
 
class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height
          child:AppBar(
          elevation: 0.0,
          bottom:  TabBar(
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
           UserListView(users: [1,2,3],areadmin: true,),
           UserListView(users: [1,2,3,4],areadmin: false,),
          ],
        ),
      floatingActionButton: FloatingActionButton(onPressed: (){

         Navigator.of(context).push(
                            CustomPageTransistion(page:  UserCreateScreen(),duration: 500).maketransition()
                          );
                          
      },child: const Icon(Icons.add,color: Colors.white,)
      ),
    ));
  }
}


class UserListView extends StatelessWidget{
   const UserListView({super.key,required this.users,required this.areadmin});
  final List  users;
  final bool areadmin;
  @override
  Widget build(BuildContext context) {
    String emptyText = areadmin ? "Aucun administrateurs":"Aucun employé";
   return users.isNotEmpty ? ListView.builder(
    itemCount: users.length,
    itemBuilder: (context,index){
      return const UserCard();
   }) : Container(
    width: MediaQuery.of(context).size.width,
    color: secondaryColor,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/Images/Bg_aucun_stock.png",width: 250.0,),
         Text(emptyText,style: const TextStyle(color: primaryColor,fontWeight: FontWeight.bold),)
      ],
    ),
   );
  }

}