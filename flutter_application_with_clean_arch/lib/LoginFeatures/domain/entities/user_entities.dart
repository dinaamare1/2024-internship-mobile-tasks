import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String email;
  final String name;
  final String? password;

  User({
    this.id, 
    required this.email,
    required this.name,
    this.password,
  });

  @override
  List<Object?> get props => [id, name, email, password];
}
