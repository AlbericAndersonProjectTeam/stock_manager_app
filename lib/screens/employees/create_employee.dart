import 'package:flutter/material.dart';
import 'package:stock_manager_app/constants/others_constants.dart';

class UserCreateScreen extends StatefulWidget{
  const UserCreateScreen({super.key, this.iscreate = true, this.justview = false});
  final bool iscreate ;
  final bool justview ;

  @override
  UserCreateScreenState createState() => UserCreateScreenState(iscreate: iscreate,justview: justview);

}

class UserCreateScreenState extends State<UserCreateScreen>{
  UserCreateScreenState({required this.iscreate,this.justview=false});
  final bool iscreate ;
  bool justview ;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController firstController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  String role = "";
  

 
  void saveProduct(BuildContext context) async{
    //save the product

    String message = iscreate ? "Produit ajouté avec succès." : "Produit modifié avec succès.";
    ToastMessage(message: message).showToast();
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    //set value of controllers if is update 
    if(justview){
      nameController.text = "TONI";
      firstController.text = "Parker";
      emailController.text = "parkertoni@gmail.com";
      telController.text = "+548 685 789 451";
      adressController.text = "Yale";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size contextSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: iscreate ? const Text('Ajout d\'un employé ') : const Text('Profil utilisateur'),
      ),
      body: SingleChildScrollView(
        child: Padding(padding:  EdgeInsets.only(
          top: contextSize.height*0.08,left: contextSize.width*0.05,right: contextSize.width*0.05),child: Column(
          
          children: [
          Form(
            key: formKey,
            child: Column(
            children: [
              IgnorePointer(
                ignoring: justview,
                child:  DropdownButtonFormField(
                    value: justview ? "Employé" : null,
                    decoration:  InputDecoration(
                      label: justview ? null : const Text('Rôle *'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                items: ["Administrateur","Employé"].map((e) => DropdownMenuItem(value: e, child: Text(e),)).toList(),

                 onChanged: (String? value) {
                   role = value!;
                 },
                 ),
              ),
                  const SizedBox(height: 10.0,),
                  AbsorbPointer(
                    absorbing: justview,
                    child: TextFormField(
                    enableInteractiveSelection: false,
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration:  InputDecoration(
                      label: const Text('Nom *'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      return value!.isNotEmpty ? null : "Choisissez un rôle";
                    },
                  ),
                  ),
                  const SizedBox(height: 10.0,),
                  
                  AbsorbPointer(
                    absorbing: justview,
                    child: TextFormField(
                    readOnly: justview,
                    keyboardType: TextInputType.name,
                    controller: firstController,
                    decoration:  InputDecoration(
                      label: const Text('Prénom(s) *'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      return value!.isNotEmpty ? null : "Saisie invalide";
                    },
                  ),
                  ),
             const SizedBox(height: 10.0,),
                  AbsorbPointer(
                    absorbing: justview,
                    child: TextFormField(
                    readOnly: justview,
                    keyboardType: TextInputType.name,
                    controller: telController,
                    decoration:  InputDecoration(
                      alignLabelWithHint: true,
                      label: const Text('Téléphone *'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      return value!.isNotEmpty ? null : "Saisie invalide";
                    },
                  ),
                  ), const SizedBox(height: 10.0,),
                  
                  AbsorbPointer(
                    absorbing: justview,
                    child: TextFormField(
                    readOnly: justview,
                    keyboardType: TextInputType.name,
                    controller: emailController,
                    decoration:  InputDecoration(
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
                  ),
                  const SizedBox(height: 10.0,),
                  AbsorbPointer(
                    absorbing: justview,
                    child: TextFormField(
                    readOnly: justview,
                    keyboardType: TextInputType.name,
                    controller: adressController,
                    decoration:  InputDecoration(
                      label: const Text('Adresse *'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      return value!.isNotEmpty ? null : "Saisie invalide";
                    },
                  ),
                  ),
          ],)),
             const SizedBox(height: 20.0,),
             Align(alignment: Alignment.center,child:  ElevatedButton(onPressed: () async {
                  if(justview){
                      setState(() {
                        justview = false;
                      });
                  }else{
                     if(formKey.currentState!.validate()){
                      saveProduct(context);
                   }
                  }
                  }, child:  Text( justview ? 'Modifier':'Enregistrer',style: TextStyle(color: Colors.white),)),
               )
          ],
        ),),
      ),
    );
  } 

}