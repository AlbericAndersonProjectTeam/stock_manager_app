import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/logo.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/user.dart';
import 'package:stock_manager_app/styles/colors.dart';

class SignupEmployeeScreen extends StatefulWidget{
  const SignupEmployeeScreen({super.key});

  @override
  SignupEmployeeScreenState createState() => SignupEmployeeScreenState();
  
}

class SignupEmployeeScreenState extends State<SignupEmployeeScreen>{

  bool showProgress = false;
  bool hidepass = true;
  bool hidepassconfirm = true;
  int currentStep = 0;
  final emailFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordVerifyController = TextEditingController();

  List<Employee> employees = [];

   Employee? checkEmployeeEmail(String email) {
    
    for (var element in employees) {
      print("mail----${element.email}");
      if(element.email == email.trim()){
        return element;
      }
    }

    return null;
  }

  void saveEmployee(BuildContext context,Employee employee) async {
    //--Enregistrer l'employé

    try {
      Employee newemployee = employee.copyWith(password: passwordController.text);
      await stockManagerdatabase.updateUser(employee.id!, newemployee);
     
     if(mounted){
       Navigator.of(context).pop();
     }

      ToastMessage(message: "Compte employé enregistré avec succès.").showToast();
    } catch (e) {
      ToastMessage(message: "Une erreur s'est produite. Veuillez recommencer.").showToast();
      print(e);
    }

  }

loadData() async{
    //load
    try {
     employees = await stockManagerdatabase.getAllEmployee();
    } catch (e) {
      ToastMessage(message: "Une erreur s'est produite.").showToast();
      print(e);
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
   return Scaffold(
    appBar:  PreferredSize(
          preferredSize: const Size.fromHeight(60.0), // here the desired height
          child:AppBar(
            title: const Text('Inscription assistant'),
            leading: Padding(padding: const EdgeInsets.all(5.0),child: logoStockManager,),
        )
            // ...
          ),
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 50.0,),
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
                      Employee employee = checkEmployeeEmail(emailController.text)!;
                      saveEmployee(context,employee);
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
                  Step(title: const Text("Vérification du type de compte",style: TextStyle(color: primaryColor,fontSize: 18.0,fontWeight: FontWeight.bold),), subtitle: const Text("Nous vérifions que vous avez bien été ajouté par un utilisateur propriétaire"), content: Form(
                    key: emailFormKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child:
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
                      return regexp.hasMatch(value?? "") ? (checkEmployeeEmail(value!)==null ? "Adresse mail introuvable." : null) : "Adresse mail invalide";
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
                      suffix:  IconButton(onPressed: (){
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