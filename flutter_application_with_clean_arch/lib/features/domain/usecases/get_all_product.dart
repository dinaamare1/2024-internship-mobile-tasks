import 'package:dartz/dartz.dart';
import 'package:flutter_application_with_clean_arch/core/error/failure.dart';
import 'package:flutter_application_with_clean_arch/features/domain/entities/product.dart';
import 'package:flutter_application_with_clean_arch/features/domain/repositories/productrepository.dart';

class GetAllProductUseCase{

  final ProductRepository productRepository;

  GetAllProductUseCase(this.productRepository);

  Future<Either<Failure,List<Product>>> execute()
  {
    return productRepository.getAllProduct();
  }
}