import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../models/product_model.dart';
import 'remote_contracts.dart';



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
    final uri = Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v1/products');

    final request = http.MultipartRequest('POST',uri);
    request.fields['name'] = product.name;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toString();
    var imageFile = File(product.image!);
    final mimeType = lookupMimeType(imageFile.path);
    
    request.files.add(
      await http.MultipartFile.fromPath(
        'image', 
        imageFile.path,
        contentType: MediaType.parse(mimeType ?? 'application/octet-stream')
      )
  );
    final streamedResponse = await client.send(request);
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode==201){
        final responseData = json.decode(response.body);
        return ProductModel.fromJson(responseData);
      }else{
        throw Exception('server Error');
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
      print(response.body); 
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

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete product');
    }
  }
  
  @override
  Future<ProductModel> getSingleProduct(String id) async {
    final response = await client.get(
      Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v1/products/$id'),
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
