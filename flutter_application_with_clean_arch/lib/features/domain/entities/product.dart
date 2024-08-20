import 'package:equatable/equatable.dart';
class Product extends Equatable {
  final String name;
  final String description;
  final String? image;
  final double price;
  final String id;
  const Product(
    {
      required this.name, 
      required this.description,
      this.image, 
      required this.price,
      this.id = ''
    }
    );
  @override
  List<Object?> get props => [name, description, image, price,id];
  }