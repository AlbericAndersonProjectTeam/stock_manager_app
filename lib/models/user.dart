class User {
  
  String? id;
  String name;
  String firstname;
  String address;
  String phonenumber;
  String email;
  String password;

  User({ this.id,
  required this.name,
  required this.firstname,
  required this.address,
  required this.phonenumber,
  required this.email,
  required this.password,
  });
  
}

class Owner extends User{
  String boutique;
  Owner({super.id,required this.boutique, required super.name, required super.firstname, required super.address, required super.phonenumber, required super.email, required super.password});

  factory Owner.fromMap(Map<dynamic, dynamic> owner) {
    return Owner(id: owner['id'].toString(),boutique: owner['boutique'], name : owner["name"], firstname : owner["firstname"],address: owner['address'],phonenumber: owner['phonenumber'], email: owner["email"], password: owner['password']);
  }

    factory Owner.simple() {
    return Owner(boutique: "boutique", name : "name", firstname : "firstname",address: 'address',phonenumber: 'phonenumber', email: "email", password:'password');
  }


  factory Owner.fromJson(String id,Map<String,dynamic> data){

    return Owner(
    id: id,
    boutique: data['boutique'],
    name: data['name'],
    firstname: data['firstname'],
    address: data['address'],
    phonenumber: data['phonenumber'],
    email: data['email'],
    password: data['password'],
    );

  }
   Owner copyWith({
    String? id,
    String? boutique,
    String? name,
    String? firstname,
    String? address,
    String? phonenumber,
    String? email,
    String? password}){
      return Owner(
        id: id?? this.id,
        boutique: boutique?? this.boutique,
        name: name?? this.name,
        firstname: firstname?? this.firstname,
        address: address?? this.address,
        phonenumber: phonenumber?? this.phonenumber,
        email: email?? this.email,
        password: password?? this.password,
      );
  }

  toJson(){
    return {
      "name" : name,
      "boutique" : boutique,
      "firstname" : firstname,
      "address" : address,
      "phonenumber" : phonenumber,
      "email" : email,
      "password" : password
    };
  }
  
}


class Employee extends User{
  String ownerId;
  String role;
  Employee({super.id,required this.ownerId,required this.role, required super.name, required super.firstname, required super.address, required super.phonenumber, required super.email, required super.password});

  factory Employee.fromMap(Map<dynamic, dynamic> employee) {
    return Employee(id: employee['id'].toString(),ownerId: employee['ownerId'].toString(),role: employee['role'], name : employee["name"], firstname : employee["firstname"],address: employee['address'],phonenumber: employee['phonenumber'], email: employee["email"], password: employee['password']);
  }


  factory Employee.fromJson(String id,Map<String,dynamic> data){

    return Employee(
    id: id,
    ownerId: data['ownerId'].toString(),
    role: data['role'],
    name: data['name'],
    firstname: data['firstname'],
    address: data['address'],
    phonenumber: data['phonenumber'],
    email: data['email'],
    password: data['password'],
    );

  }

   Employee copyWith({
    String? id,
    String? ownerId,
    String? role,
    String? name,
    String? firstname,
    String? address,
    String? phonenumber,
    String? email,
    String? password}){
      return Employee(
        id: id?? this.id,
        ownerId: ownerId?? this.ownerId,
        role: role?? this.role,
        name: name?? this.name,
        firstname: firstname?? this.firstname,
        address: address?? this.address,
        phonenumber: phonenumber?? this.phonenumber,
        email: email?? this.email,
        password: password?? this.password,
      );
  }

  toJson(){
    return {
      "name" : name,
      "ownerId" : ownerId,
      "role" : role,
      "firstname" : firstname,
      "address" : address,
      "phonenumber" : phonenumber,
      "email" : email,
      "password" : password
    };
  }
  
}