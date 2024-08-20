import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getAllProduct();
  Future<ProductModel> addProduct(ProductModel product);
  Future<ProductModel> updateProduct(String id, ProductModel product);
  Future<bool> deleteProduct(String id);
  Future<ProductModel> getSingleProduct(String id);
}
