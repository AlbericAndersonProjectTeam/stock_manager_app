import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/logo.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
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
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void makelogin(BuildContext context){
    //--Process connexion

    Navigator.of(context).pushReplacement(
        CustomPageTransistion(page: const HomeScreen(),duration: 500).maketransition()
    );
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
         SizedBox(height: MediaQuery.of(context).size.height * 0.25,child: const Align(alignment: Alignment.center,child: logoStockManager,),),
         const Text("CONNEXION",style: TextStyle(color: primaryColor,fontSize: 25.0,fontWeight: FontWeight.bold)),
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
                      final regexp = RegExp(r"^[a-z]{3,}@[a-z.]{3,}$",caseSensitive: false,multiLine: false);
                      return regexp.hasMatch(value?? "") ? null : "Adresse mail invalide";
                    },
                  ),
                  const SizedBox(height: 15.0,),    
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    obscureText: true,
                    decoration:  InputDecoration(
                      suffix: const Icon(Icons.lock),
                      labelText: "Entrez votre mot de passe", border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                      ),
                      
                    ),
                    validator: (String? value){
                      return value == "abcd" ? null : "Mot de passe incorrecte.";
                    },
                  ),
                  const SizedBox(height: 30.0,),   
                  Align(alignment: Alignment.centerRight,child:  ElevatedButton(onPressed: (){
                    if(formKey.currentState!.validate()){
                      makelogin(context);
                    }
                  }, child: const Text('Se connecter',style: TextStyle(color: Colors.white),)),
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
                        child: const Text('Enregistrer mon compte employé',style: TextStyle(color: primaryColor,fontSize: 18.0,decoration: TextDecoration.underline,decorationColor: primaryColor,decorationThickness: 2),),
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