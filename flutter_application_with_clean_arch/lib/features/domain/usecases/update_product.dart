import 'package:dartz/dartz.dart';
import 'package:flutter_application_with_clean_arch/core/error/failure.dart';
import 'package:flutter_application_with_clean_arch/features/domain/entities/product.dart';
import 'package:flutter_application_with_clean_arch/features/domain/repositories/productrepository.dart';

class UpdateProductUseCase{

  final ProductRepository productRepository;

  UpdateProductUseCase({ required this.productRepository});

  Future<Either<Failure,Product>> execute(String id,Product product){
    return productRepository.updateProduct(id,product);
  }
}