
import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../core/network/network_info.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/productrepository.dart';
import '../data_sources/local_contracts.dart';
import '../data_sources/remote_contracts.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
    final ProductRemoteDataSource remoteDataSource;
    final ProductLocalDataSource localDataSource;
    final NetworkInfo networkInfo;

    ProductRepositoryImpl({
      required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo,
    });

    @override
    Future<Either<Failure, Product>> addProduct(Product product) async {
      final productModel = ProductModel.fromEntity(product);
      if (await networkInfo.isConnected()) {
        try {
          final addedProduct = await remoteDataSource.addProduct(productModel);
          final cachedProducts = await localDataSource.getAllProdcuts();
          cachedProducts.add(addedProduct);
          localDataSource.cachedProducts(cachedProducts);
          return Right(addedProduct);
        } catch (e) {
          return Left(ServerFailure('Server failure: $e'));
        }
      } else {
        return Left(ServerFailure('No internet connection'));
      }
    }

    @override
    Future<Either<Failure, bool>> deleteProduct(String id) async {
      if (await networkInfo.isConnected()) {
        try {
          final success = await remoteDataSource.deleteProduct(id);
          if (success) {
            final cachedProducts = await localDataSource.getAllProdcuts();
            cachedProducts.removeWhere((product) => product.id == id);
            localDataSource.cachedProducts(cachedProducts);
            return const Right(true);
          } else {
            return Left(ServerFailure('Failed to delete the product on the server'));
          }
        } catch (e) {
          return Left(ServerFailure('Server failure: $e'));
        }
      } else {
        return Left(ServerFailure('No internet connection'));
      }
    }

    @override
    Future<Either<Failure, Product>> getSingleProduct(String id) async {
      if (await networkInfo.isConnected()) {
        try {
          final remoteProduct = await remoteDataSource.getSingleProduct(id);
          return Right(remoteProduct);
        } catch (e) {
          return Left(ServerFailure('Server failure: $e'));
        }
      } else {
        try {
          final localProduct = localDataSource.getSingleProduct(id);
          return Right(localProduct);
        } catch (e) {
          return Left(CacheFailure('Cache failure: $e'));
        }
      }
    }

    @override
    Future<Either<Failure, Product>> updateProduct(String id, Product product) async {
      final productModel = ProductModel.fromEntity(product);
      if (await networkInfo.isConnected()) {
        try {
          final updatedProduct = await remoteDataSource.updateProduct(id, productModel);
          final cachedProducts = await localDataSource.getAllProdcuts();
          final index = cachedProducts.indexWhere((p) => p.id == id);
          if (index != -1) {
            cachedProducts[index] = updatedProduct;
            localDataSource.cachedProducts(cachedProducts);
          }
          return Right(updatedProduct);
        } catch (e) {
          return Left(ServerFailure('Server failure: $e'));
        }
      } else {
        try {
          final updatedProduct = await localDataSource.updateProduct(id, productModel);
          return Right(updatedProduct);
        } catch (e) {
          return Left(CacheFailure('Cache failure: $e'));
        }
      }
    }
    
      @override
      Future<Either<Failure, List<Product>>> getAllProduct() async {
        if (await networkInfo.isConnected()) {
            try {
              final remoteProducts = await remoteDataSource.getAllProduct();
              localDataSource.cachedProducts(remoteProducts);
              return Right(remoteProducts);
            } catch (e) {
              return Left(ServerFailure('Server failure: $e'));
            }
          } else {
            try {
              final localProducts = await localDataSource.getAllProdcuts();
              return Right(localProducts);
            } catch (e) {
              return Left(CacheFailure('Cache failure: $e'));
            }
          }
        }
  }
