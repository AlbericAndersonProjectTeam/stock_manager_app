import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/logo.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/user.dart';
import 'package:stock_manager_app/screens/home.dart';
import 'package:stock_manager_app/screens/signup_employee.dart';
import 'package:stock_manager_app/screens/signup_owner.dart';
import 'package:stock_manager_app/styles/colors.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
  
}

class LoginScreenState extends State<LoginScreen>{

  bool showProgress = false;
  bool hidepass = true;
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void makelogin(BuildContext context) async {
   
      setState(() {
        showProgress = true;
      });

   String email = emailController.text;
   String password = passwordController.text;
   dynamic user ;
   dynamic owner ;

   try {
     user = await stockManagerdatabase.getUserWithCredentials(email, password);
    if(user is Employee){
       owner = await stockManagerdatabase.getUserWithId(user.ownerId,"Owner");
    }else{
      owner = user;
    }
    //SETTINGSSESSION
   } catch (e) {
     print(e);
   }

    if(user!=null){
      print("user : ${user.toJson()}");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('loggedUserId', user.id);
      prefs.setString('ownerId', owner.id);
      prefs.setString('userName', "${user.firstname} ${user.name}");
      prefs.setString('userEmail', user.email);
      prefs.setInt('isOwner', user is Owner ? 1 : 0);
      prefs.setInt('isAdmin', user is Owner ? 1 : (user.role=="admin" ? 1 : 0));

      
      String token = await stockManagerdatabase.getOneToken(user.id);
      if(token==""){
        token = prefs.getString("token")!;
         await stockManagerdatabase.storeToken(user.id, owner.id, token);
      }

      if(mounted){
        Navigator.of(context).pushReplacement(
          CustomPageTransistion(page: const HomeScreen(),duration: 500).maketransition()
      );
      }
    }else{
      setState(() {
        showProgress = false;
         ToastMessage(message: "Identifiants incorrectes.").showToast();
      });
    }

  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0), // here the desired height
          child:AppBar(
            title: const Text('Connexion'),
            leading: Padding(padding: const EdgeInsets.all(5.0),child: logoStockManager,),
        )
            // ...
          ),
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
         SizedBox(height: MediaQuery.of(context).size.height * 0.20,),
         Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                      child: Column(
                      children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: emailController,
                    decoration:  InputDecoration(
                      suffix: const Icon(Icons.mail),
                      label: const Text('Adresse Email'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      final regexp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",caseSensitive: false,multiLine: false);
                      return regexp.hasMatch(value?? "") ? null : "Adresse mail invalide";
                    },
                  ),
                  const SizedBox(height: 15.0,),    
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    obscureText: hidepass,
                    decoration:  InputDecoration(
                      suffix: IconButton(onPressed: (){
                        setState(() {
                          hidepass = !hidepass;
                        });
                      }, icon: hidepass ? const Icon(Icons.visibility): const Icon(Icons.visibility_off)),
                      labelText: "Entrez votre mot de passe", border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                      ),
                      
                    ),
                    validator: (String? value){
                      return value!.length >= 8 ? null : "Au moins 8 caractères.";
                    },
                  ),
                  const SizedBox(height: 30.0,),   
                  Align(alignment: Alignment.centerRight,child:  ElevatedButton(onPressed: (){
                    if(formKey.currentState!.validate()){
                      makelogin(context);
                    }
                  }, child: showProgress ? customCircularProcessIndicator : const Text('Se connecter',style: TextStyle(color: Colors.white),)),
                 ),
                 const SizedBox(height: 20.0,),  
                  Container(height: 20.0,decoration: const BoxDecoration(border: Border(top: BorderSide())),),
                  
                  Align(alignment: Alignment.centerLeft,child: ElevatedButton(onPressed: (){
                          Navigator.of(context).push(
                             CustomPageTransistion(page: const SignupOwnerScreen()).maketransition()
                           );
                  }, child: const Text('Créer un compte propriétaire',style: TextStyle(color: Colors.white),)),
                  ),
                  const SizedBox(height: 20.0,),  
                  GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            CustomPageTransistion(page: const SignupEmployeeScreen(),duration: 500).maketransition()
                          );
                        },
                        child: const Text('Enregistrer mon compte Assistant',style: TextStyle(color: primaryColor,fontSize: 18.0,decoration: TextDecoration.underline,decorationColor: primaryColor,decorationThickness: 2),),
                      ),
                        ],
                      ),
                    ))

        ],
      ),
    ),
   );
  }

}