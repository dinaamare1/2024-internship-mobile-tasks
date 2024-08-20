import '../../domain/entities/user_entities.dart';

class UserModel extends User {
  final String? _password;
  UserModel({
    super.id,          
    required super.email,
    required super.name,
    super.password,
  })  : _password = password;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],      
      email: json['email'],
      name: json['name'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,     
      'email': email,
      'name': name,
    };
  }
  @override
  String? get password => _password;
}
