import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_manager_app/constants/db_instaces.dart';
import 'package:stock_manager_app/constants/static_widgets_constants.dart';
import 'package:stock_manager_app/models/user.dart';
import 'package:stock_manager_app/screens/employees/employees_body.dart';
import 'package:stock_manager_app/screens/home.dart';

class UserCreateScreen extends StatefulWidget{
  const UserCreateScreen({super.key, this.iscreate = true, this.justview = false, this.isconnectedUser = false, this.user});
  final bool iscreate ;
  final bool justview ;
  final bool isconnectedUser;
  final dynamic user;

  @override
  UserCreateScreenState createState() => UserCreateScreenState(iscreate: iscreate,justview: justview,isconnectedUser: isconnectedUser, user: user);

}

class UserCreateScreenState extends State<UserCreateScreen>{
  UserCreateScreenState({required this.iscreate,this.justview=false,this.isconnectedUser=false, this.user});
  final bool iscreate ;
  bool justview ;
  bool isconnectedUser ;
  bool connectedUSerisOwner = false;
  bool editrole = false;
  final dynamic user;
  bool showProgress = false;


  bool hidepass = true;
  bool hidepassconfirm = true;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController firstController = TextEditingController();
  TextEditingController boutiqueController = TextEditingController();
  TextEditingController telController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordVerifyController = TextEditingController();
  String role = "";
  

 
  void saveEmployee(BuildContext context) async{
    //save the employee
    setState(() {
      showProgress = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String ownerId =  prefs.getString('ownerId')!;
      var result;
      if (iscreate) {
        Employee employeeToSave = Employee(ownerId: ownerId, role: role, name: nameController.text, firstname: firstController.text, address: adressController.text, phonenumber: telController.text, email: emailController.text, password: "");
         result = await stockManagerdatabase.storeEmployee(employeeToSave);
         
      }else{
          if(user is Employee){
              Employee employeeToSave = user!.copyWith(ownerId: ownerId, role: role, name: nameController.text, firstname: firstController.text, address: adressController.text, phonenumber: telController.text, email: emailController.text, password: passwordController.text);
              result = await stockManagerdatabase.updateUser(user!.id!,employeeToSave);

              if(DATACONSTANTSOFSESSION.employees!=null){
              for (var i = 0; i < DATACONSTANTSOFSESSION.employees!.length; i++) {
                if(DATACONSTANTSOFSESSION.employees![i].id! == employeeToSave.id!){
                  DATACONSTANTSOFSESSION.employees![i] = employeeToSave;
                  break;
                }
              }
             }

          }else{
              Owner ownerToSave = user!.copyWith(name: nameController.text, firstname: firstController.text,boutique : boutiqueController.text, address: adressController.text, phonenumber: telController.text, email: emailController.text, password: passwordController.text);
              result = await stockManagerdatabase.updateUser(ownerId,ownerToSave);
              prefs.setString('userName', "${ownerToSave.firstname} ${ownerToSave.name}");

              
              
          }

          String userId =  prefs.getString('loggedUserId')!;
          Owner newowner =  await stockManagerdatabase.getUserWithId(ownerId,"Owner");
          var newconnecteduser;
          if(prefs.getInt('isOwner')==1){
            newconnecteduser = newowner;
          }else{
           newconnecteduser =   await stockManagerdatabase.getUserWithId(userId,"Employee");
          }

         if(isconnectedUser){
           HomeScreenState.state.refresh(newconnecteduser,newowner);
         }
      }
      var employees =  await stockManagerdatabase.getEmployee(ownerId);
      List<Employee> newadmins = [];
      List<Employee> newsimpleemployees = [];
      for (var employee in employees) {
          if(employee.role=="admin"){
            newadmins.add(employee);
          }else{
            newsimpleemployees.add(employee);
          }
      }
      if(EmployeeHomeScreenState.state!=null){
        EmployeeHomeScreenState.state!.refresh(newadmins, newsimpleemployees);
      }
      print(result);
      String message = iscreate ? "Assistant ajouté avec succès." : "Profil modifié avec succès.";
      ToastMessage(message: message).showToast();
      if(mounted){
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
      ToastMessage(message: "Une erreur s'est produite.").showToast();
    }


    setState(() {
      showProgress = false;
    });
  }

  checkConnectedUserIsOwner() async {
     try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(prefs.getInt('isOwner')! == 1){
        connectedUSerisOwner =  true;
      }
     } catch (e) {
       print(e);
       ToastMessage(message: "Une erreur s'est produite.");
     }
  }

  @override
  void initState() {
    super.initState();
    //set value of controllers if is update 
    if(justview){
      nameController.text = user!.name;
      firstController.text = user!.firstname;
      emailController.text = user!.email;
      telController.text = user!.phonenumber;
      adressController.text = user!.address;
      passwordController.text = user!.password;
    }
    if(user is Owner){
      boutiqueController.text = user!.boutique;
    }else{
     if(!iscreate){
       role = user!.role;
     }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkConnectedUserIsOwner();
     if(mounted){
        setState(() { });    
     }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size contextSize = MediaQuery.of(context).size;
    List<String> selectItems = user is Owner ? ["Administrateur","Employé","Propriétaire"] : ["Administrateur","Employé"];
    return Scaffold(
      appBar: AppBar(
        title: iscreate ? const Text('Ajout d\'un employé ') : const Text('Profil Assistant'),
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
                ignoring: connectedUSerisOwner && !isconnectedUser && editrole ? false :( isconnectedUser ? true : (justview ? true : (connectedUSerisOwner ? false : true))),
                child:  DropdownButtonFormField(
                    value: user is Owner ? "Propriétaire" :( justview || isconnectedUser ? (user!.role  =="admin" ? "Administrateur" : "Employé") : null),
                    decoration:  InputDecoration(
                      label: user is Owner ? null  : (justview ? null : const Text('Rôle *')),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                items: selectItems.map((e) => DropdownMenuItem(value: e, child: Text(e),)).toList(),

                 onChanged: (String? value) {
                  print("value ---$value");
                   role = value == "Administrateur" ? "admin" : "simple";
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
                  ), const SizedBox(height: 10.0,),
                  
                  user is Owner ? AbsorbPointer(
                    absorbing: justview,
                    child: TextFormField(
                    readOnly: justview,
                    keyboardType: TextInputType.name,
                    controller: boutiqueController,
                    decoration:  InputDecoration(
                      label: const Text('Entreprise *'),
                      border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value){
                      return value!.isNotEmpty ? null : "Saisie invalide";
                    },
                  ),
                  ) : Container(),
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
                      final regexp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+$",caseSensitive: false,multiLine: false);
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

                  const SizedBox(height: 10.0,),
                  isconnectedUser ? TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    readOnly: justview,
                    obscureText: hidepass,
                    decoration:  InputDecoration(
                      suffix:  IconButton(onPressed: (){
                        setState(() {
                          hidepass = !hidepass;
                        });
                      }, icon: hidepass ? const Icon(Icons.visibility): const Icon(Icons.visibility_off)),
                      labelText: "Mot de passe", border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                      ),
                      
                    ),
                    validator: (String? value){
                      return value!.length >= 8 ? null : "Au moins 8 caractères.";
                    },
                  ) : Container(),
                  const SizedBox(height: 15.0,),
                  justview ? Container() : 
                  iscreate ? Container() : isconnectedUser ? TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordVerifyController,
                    obscureText: hidepassconfirm,
                    decoration:  InputDecoration(
                      
                      suffix: IconButton(onPressed: (){
                        setState(() {
                          hidepassconfirm = !hidepassconfirm;
                        });
                      }, icon: hidepassconfirm ? const Icon(Icons.visibility): const Icon(Icons.visibility_off)),
                      labelText: "Confirmez le mot de passe", border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                      ),
                      
                    ),
                    validator: (String? value){
                      return value == passwordController.text ? null : "Les mots de passe ne correspondent pas.";
                    },
                  ) : Container(),
          ],)),
             const SizedBox(height: 15.0,),
             isconnectedUser || iscreate || connectedUSerisOwner ? Align(alignment: Alignment.center,child:  ElevatedButton(onPressed: () async {
                  if(justview){
                   if(connectedUSerisOwner && !isconnectedUser){
                    if(editrole){
                      editrole = false;
                      saveEmployee(context);
                    }else{
                      ToastMessage(message: "Vous pouvez seulement modifier le rôle de l'Assistant.").showToast();
                      setState(() {
                        editrole = true;
                      });
                    }
                   }else{
                      setState(() {
                        justview = false;
                      });
                   }
                  }else{
                     if(formKey.currentState!.validate()){
                      saveEmployee(context);
                   }
                  }
                  }, child: showProgress ?  customCircularProcessIndicator : Text( justview ? (editrole ? 'Enregistrer' :  'Modifier'): 'Enregistrer',style: TextStyle(color: Colors.white),)),
               ) : Container()
          ],
        ),),
      ),
    );
  } 

}