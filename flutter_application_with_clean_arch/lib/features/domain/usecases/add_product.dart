import 'package:dartz/dartz.dart';
import 'package:flutter_application_with_clean_arch/core/error/failure.dart';
import 'package:flutter_application_with_clean_arch/features/domain/entities/product.dart';
import 'package:flutter_application_with_clean_arch/features/domain/repositories/productrepository.dart';

class AddProductUseCase{

  final ProductRepository productRepository;

  AddProductUseCase({ required this.productRepository});

  Future<Either<Failure,Product>> execute(Product product){
      return productRepository.addProduct(product);
  }
}