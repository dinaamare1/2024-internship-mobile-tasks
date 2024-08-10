import 'package:equatable/equatable.dart';
class Product extends Equatable {
  final String name;
  final String description;
  final String? image;
  final int price;
  final String id;
  const Product(
    {
      required this.name, 
      required this.description,
      required this.image, 
      required this.price,
      required this.id
    }
    );
  @override
  List<Object?> get props => [name, description, image, price,id];
  }