import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProduct();
  Future<ProductModel> addProduct(ProductModel product);
  Future<ProductModel> updateProduct(String id, ProductModel product);
  Future<bool> deleteProduct(String id);
  Future<ProductModel> getSingleProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getAllProduct() async {
    final response = await client.get(
      Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v1/products'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> productJsonList = json.decode(response.body)['data'];
      return productJsonList.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await client.post(
      Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v1/products'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 201) {
      final productJson = json.decode(response.body)['data'].first;
      return ProductModel.fromJson(productJson);
    } else {
      throw Exception('Failed to add product');
    }
  }

  @override
  Future<ProductModel> updateProduct(String id, ProductModel product) async {
    final response = await client.put(
      Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v1/products/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(product.toJson()),
    );

    if (response.statusCode == 200) {
      final productJson = json.decode(response.body)['data'];
      return ProductModel.fromJson(productJson);
    } else {
      throw Exception('Failed to update product');
    }
  }

  @override
  Future<bool> deleteProduct(String id) async {
    final response = await client.delete(
      Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v1/products/$id'),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete product');
    }
  }
  
  @override
  Future<ProductModel> getSingleProduct(String id) async {
    final response = await client.get(
      Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v1/product/$id'),
    );
    if (response.statusCode == 200){
      final productJson = json.decode(response.body)['data'];
      return ProductModel.fromJson(productJson);
    }
    else {
      throw Exception('failed to get the product');
    }
  }
}
