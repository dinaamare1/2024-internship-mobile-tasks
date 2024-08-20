import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
      required String name,
      required String description,
      String? image, 
      required double price,
      String? id,
    }) : super(
            name: name,
            description: description,
            image: image,
            price: price,
            id: id ?? 'unknown', 
          );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      name: json['name'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? 'No description',
      image: json['imageUrl'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 45.0,
      id: json['id'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': image,
      'price': price,
      'id': id,
    };
  }

  static ProductModel fromEntity(Product product) {
    return ProductModel(
      name: product.name,
      description: product.description,
      image: product.image,
      price: product.price,
      id: product.id,
    );
  }
}
