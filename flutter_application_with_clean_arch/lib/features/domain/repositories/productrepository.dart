import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, Product>> addProduct(Product product);
  Future<Either<Failure, bool>> deleteProduct(String id);
  Future<Either<Failure, Product>> updateProduct(String id,Product product);
  Future<Either<Failure, List<Product>>> getAllProduct();
  Future<Either<Failure,Product>> getSingleProduct(String id);
}
