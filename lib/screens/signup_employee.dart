import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/logo.dart';
import 'package:stock_manager_app/constants/others_constants.dart';
import 'package:stock_manager_app/screens/login.dart';
import 'package:stock_manager_app/styles/colors.dart';

class SignupEmployeeScreen extends StatefulWidget{
  const SignupEmployeeScreen({super.key});

  @override
  SignupEmployeeScreenState createState() => SignupEmployeeScreenState();
  
}

class SignupEmployeeScreenState extends State<SignupEmployeeScreen>{

  bool showProgress = false;
  int currentStep = 0;
  final emailFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordVerifyController = TextEditingController();

  void saveEmployee(BuildContext context){
    //--Enregistrer l'employé


      Navigator.of(context).pushReplacement(
         CustomPageTransistion(page: const LoginScreen(),duration: 1200).maketransition()
      );
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

         SizedBox(height: MediaQuery.of(context).size.height * 0.15,child: const Align(alignment: Alignment.center,child: logoStockManager,),),
          const  ListTile(title: Text("Inscription",textAlign: TextAlign.center, style: TextStyle(color: primaryColor,fontSize: 25.0,fontWeight: FontWeight.bold,)),subtitle: Text('Employé',textAlign: TextAlign.center,),),
          Stepper(
            connectorThickness: 2.0,
            controlsBuilder: (context, details) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children : [
                  currentStep == 0 ? ElevatedButton(onPressed: details.onStepContinue,child: const Text('Vérifier',style: TextStyle(color: Colors.white,fontSize: 15.0),)) : ElevatedButton(onPressed: details.onStepContinue,child: const Text('S\'inscrire',style: TextStyle(color: Colors.white,fontSize: 15.0),)),
                  const SizedBox(width: 20.0,) ,
                  currentStep ==1 ? ElevatedButton(onPressed: details.onStepCancel,child: const Text('Retour',style: TextStyle(color: Colors.white,fontSize: 15.0),)) : Container()
                  
                ]
              );
            },
               stepIconBuilder: (stepIndex, stepState) {
                        if (stepIndex < currentStep) {
                          return const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14,
                          );
                        } else if (stepIndex > currentStep) {
                          return const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          );
                        } else {
                          return const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 14,
                          );
                        }
                      },
              onStepContinue: () {
                if (currentStep == 0) {
                  if(emailFormKey.currentState!.validate()){
                    setState(() {
                      currentStep++;
                    });
                  }
                }else{
                    if(passwordFormKey.currentState!.validate()){
                      saveEmployee(context);
                    }
                }
              },
              onStepCancel: (){
                if(currentStep==1){
                  setState(() {
                    currentStep = 0;
                  });
                }
              },
            currentStep: currentStep,
            steps: [
                  Step(title: const Text("Vérification du type de compte",style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.bold),), subtitle: const Text("Cette vérification permet à Stock Manager d'identifier toute première connexion"), content: Form(
                    key: emailFormKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child:
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
                    ))),

                  Step(title: const Text("Mot de passe",style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.bold),), content: Form(
                    key: passwordFormKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
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
                  const SizedBox(height: 15.0,),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordVerifyController,
                    obscureText: true,
                    decoration:  InputDecoration(
                      
                      suffix: const Icon(Icons.lock),
                      labelText: "Confirmez votre mot de passe", border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                      ),
                      
                    ),
                    validator: (String? value){
                      return value == passwordController.text ? null : "Les mots de passe ne correspondent pas.";
                    },
                  ),
                        ],
                      ),
                    ))),
            ]
          ),
           Container(margin: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10.0), height: 60.0,decoration: const BoxDecoration(border: Border(top: BorderSide())),
           child:  Align(alignment: Alignment.centerLeft,child: ElevatedButton(onPressed: (){
                   
                    Navigator.of(context).pop();
                  }, child: const Text('Retour',style: TextStyle(color: Colors.white),)),
                  ),
           ),
                  
        ],
      ),
    ),
   );
  }

}