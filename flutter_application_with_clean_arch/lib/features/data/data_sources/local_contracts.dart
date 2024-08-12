import '../models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getAllProdcuts();
  ProductModel getSingleProduct(String id);
  Future<ProductModel>updateProduct(String id,ProductModel product);
  Future<bool>deleteProduct(String id);
  Future<bool>cachedProducts(List<ProductModel> products);

}