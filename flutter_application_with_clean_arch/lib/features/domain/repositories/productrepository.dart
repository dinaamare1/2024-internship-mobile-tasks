import 'package:flutter_application_with_clean_arch/core/error/failure.dart';
import 'package:flutter_application_with_clean_arch/features/domain/entities/product.dart';
import 'package:dartz/dartz.dart';

abstract class ProductRepository {
  Future<Either<Failure, Product>> addProduct(Product product);
  Future<Either<Failure, Product>> deleteProduct(String id);
  Future<Either<Failure, Product>> updateProduct(String id,Product product);
  Future<Either<Failure, List<Product>>> getAllProduct();
  Future<Either<Failure,Product>> getSingleProduct(String id);
}
