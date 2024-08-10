


import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../entities/product.dart';
import '../repositories/productrepository.dart';

class GetSingleProductUseCase {
    
    final ProductRepository productRepository;

    GetSingleProductUseCase(this.productRepository);

    Future<Either<Failure,Product>> execute(String id){
      return productRepository.getSingleProduct(id);
    }
}