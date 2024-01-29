import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/logo.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/user.dart';
import 'package:stock_manager_app/screens/login.dart';
import 'package:stock_manager_app/styles/colors.dart';

class SignupOwnerScreen extends StatefulWidget{
  const SignupOwnerScreen({super.key});

  @override
  SignupOwnerScreenState createState() => SignupOwnerScreenState();
  
}

class SignupOwnerScreenState extends State<SignupOwnerScreen>{

  bool showProgressStep1 = false;
   bool showProgressStep2 = false;
  bool hidepass = true;
  bool hidepassconfirm = true;
  int currentStep = 0;
  final personnalFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  TextEditingController boutiqueController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordVerifyController = TextEditingController();


 Future<bool> checkEmail(String email) async {
  dynamic user = await stockManagerdatabase.getUserWithEmail(email);
  if(user!=null){
    return true;
  }else{
    return false;
  }
  
 }

  void saveOwner(BuildContext context) async {
    //--Enregistrer le proprio

    setState(() {
      showProgressStep2 = true;
    });
    
    Owner owner = Owner(boutique: boutiqueController.text,
     name: nameController.text, 
     firstname: firstnameController.text, 
     address: addressController.text, 
     phonenumber: phonenumberController.text, 
     email: emailController.text, 
     password: passwordController.text);

    try {
      await stockManagerdatabase.storeOwner(owner);
    ToastMessage(message: "Compte propriétaire créé avec succès.").showToast();
    
      if(mounted){
      Navigator.of(context).pushReplacement(
          CustomPageTransistion(page: const LoginScreen(),duration: 700).maketransition()
      );
      }

   } catch (e) {
     print(" erreur signup : $e");
   }

      setState(() {
          showProgressStep2 = false;
        });

  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar:  PreferredSize(
          preferredSize: const Size.fromHeight(60.0), // here the desired height
          child:AppBar(
            title: const Text('Inscription propriétaire'),
            leading: Padding(padding: const EdgeInsets.all(5.0),child: logoStockManager,),
        )
            // ...
          ),
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 20.0,),
          Stepper(
            connectorThickness: 2.0,
            controlsBuilder: (context, details) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children : [
                  currentStep ==1 ? ElevatedButton(onPressed: details.onStepCancel,child: const Text('Précédent',style: TextStyle(color: Colors.white,fontSize: 15.0),)) : Container(),
                  const SizedBox(width: 20.0,) ,
                  currentStep == 0 ? ElevatedButton(onPressed: details.onStepContinue,child: showProgressStep1 ? customCircularProcessIndicator  : const Text('Continuer',style: TextStyle(color: Colors.white,fontSize: 15.0),)) : ElevatedButton(onPressed: details.onStepContinue,child: showProgressStep2 ?customCircularProcessIndicator : const Text('S\'inscrire',style: TextStyle(color: Colors.white,fontSize: 15.0),)),
                  
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
              onStepContinue: () async {
                if (currentStep == 0) {
                  if(personnalFormKey.currentState!.validate()){
                    setState(() {
                      showProgressStep1 = true;
                    });
                      bool exist = await checkEmail(emailController.text);

                    setState(() {
                      showProgressStep1 = false;
                    });
                    if(exist){
                      ToastMessage(message: "Cette adresse email appartient déjà à l'un de nos utilisateurs.").showToast();
                    }else{
                      setState(() {
                        currentStep = 1;
                      });
                    }
                  }
                }else{
                    if(passwordFormKey.currentState!.validate()){
                      saveOwner(context);
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
                  Step(title: const Text("Etape 1/2",style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.bold),), subtitle:  Text(currentStep == 1 ? "Vérification de non conflit des informations personnelles faite." :""), content: Form(
                    key: personnalFormKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration:  InputDecoration(
                      suffix: const Icon(Icons.person,color: primaryColor,),
                      label: const Text('Votre nom'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      return value!.isNotEmpty ? null : "Saisie invalide";
                    },
                  ),
                  const SizedBox(height: 10.0,),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: firstnameController,
                    decoration:  InputDecoration(
                      suffix: const Icon(Icons.person,color: primaryColor,),
                      label: const Text('Prénom'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                       return value!.isNotEmpty ? null : "Saisie invalide";
                    },
                  ),
                  const SizedBox(height: 10.0,),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: phonenumberController,
                    decoration:  InputDecoration(
                      suffix: const Icon(Icons.phone,color: primaryColor,),
                      label: const Text('Téléphone'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      final regexp = RegExp(r"^(\+[0-9]{2,})?( ?[0-9]{2,3} ?){4,}$",caseSensitive: false,multiLine: false);
                      return regexp.hasMatch(value?? "") ? null : "Adresse téléphonique invalide";
                    },
                  ),
                  const SizedBox(height: 10.0,),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    controller: emailController,
                    decoration:  InputDecoration(
                      suffix: const Icon(Icons.mail,color: primaryColor,),
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
                        ],
                      )
                    ))),

                  Step(title: const Text("Etape 2/2",style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.bold),), content: Form(
                    key: passwordFormKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: [
                          TextFormField(
                    keyboardType: TextInputType.name,
                    controller: boutiqueController,
                    decoration:  InputDecoration(
                      suffix: const Icon(Icons.store,color: primaryColor,),
                      label: const Text('Nom de votre Boutique/Société'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      return value!.isNotEmpty ? null : "Saisie invalide";
                    },
                  ),
                  const SizedBox(height: 10.0,),
                          TextFormField(
                    keyboardType: TextInputType.name,
                    controller: addressController,
                    decoration:  InputDecoration(
                      suffix: const Icon(Icons.store,color: primaryColor,),
                      label: const Text('Votre adresse'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      return value!.isNotEmpty ? null : "Saisie invalide";
                    },
                  ),
                  const SizedBox(height: 10.0,),
                          TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    obscureText: hidepass,
                    decoration:  InputDecoration(
                      suffix:  IconButton(onPressed: (){
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
                  const SizedBox(height: 15.0,),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordVerifyController,
                    obscureText: hidepassconfirm,
                    decoration:  InputDecoration(
                      
                      suffix: IconButton(onPressed: (){
                        setState(() {
                          hidepassconfirm = !hidepassconfirm;
                        });
                      }, icon: hidepassconfirm ? const Icon(Icons.visibility): const Icon(Icons.visibility_off)),
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