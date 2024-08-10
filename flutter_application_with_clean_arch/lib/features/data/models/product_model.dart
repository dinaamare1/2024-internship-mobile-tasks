import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required String name,
    required String description,
    required String? image,
    required int price,
    required String id,
  }) : super(
          name: name,
          description: description,
          image: image,
          price: price,
          id: id,
        );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] as String,
      description: json['description'] as String,
      image: json['image'] as String?,
      price: json['price'] as int,
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      // 'image': image,
      'price': price,
      'id': id,
    };
  }
}
