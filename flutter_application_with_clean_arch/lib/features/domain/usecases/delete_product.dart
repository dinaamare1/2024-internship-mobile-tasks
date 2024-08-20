import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../repositories/productrepository.dart';

class DeleteProductUseCase{

  final ProductRepository productRepository;

  DeleteProductUseCase({ required this.productRepository});

  Future<Either<Failure,bool>> execute(String id){
    return productRepository.deleteProduct(id);
  }
}