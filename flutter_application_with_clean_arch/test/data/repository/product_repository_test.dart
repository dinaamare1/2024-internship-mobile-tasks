import 'package:dartz/dartz.dart';
import 'package:flutter_application_with_clean_arch/core/error/failure.dart';
import 'package:flutter_application_with_clean_arch/core/network/network_info.dart';
import 'package:flutter_application_with_clean_arch/features/data/data_sources/local_contracts.dart';
import 'package:flutter_application_with_clean_arch/features/data/data_sources/remote_contracts.dart';
import 'package:flutter_application_with_clean_arch/features/data/models/product_model.dart';
import 'package:flutter_application_with_clean_arch/features/data/repositories/data_repository.dart';
import 'package:flutter_application_with_clean_arch/features/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_repository_test.mocks.dart';

@GenerateMocks([ProductRemoteDataSource, ProductLocalDataSource, NetworkInfo])

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockRemoteDataSource;
  late MockProductLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockProductRemoteDataSource();
    mockLocalDataSource = MockProductLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  // Test data
  const tProductId = '1';
  const tProduct = Product(
    name: 'Product Name',
    description: 'Product Description',
    image: 'product_image.png',
    price: 100,
    id: tProductId,
  );
  final tProductModel = ProductModel.fromEntity(tProduct);
  List<ProductModel> tProductList = [tProductModel];

  group('addProduct', () {
    test('should return added product when there is internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      when(mockRemoteDataSource.addProduct(tProductModel)).thenAnswer((_) async => tProductModel);
      when(mockLocalDataSource.getAllProdcuts()).thenAnswer((_) async => tProductList);
      when(mockLocalDataSource.cachedProducts(any)).thenAnswer((_) async => true);

      // Act
      final result = await repository.addProduct(tProduct);

      // Assert
      expect(result, Right(tProductModel));
    });

    test('should return ServerFailure when there is no internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => false);

      // Act
      final result = await repository.addProduct(tProduct);

      // Assert
      expect(result, Left(ServerFailure('No internet connection')));
    });

    test('should return ServerFailure when adding product fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      when(mockRemoteDataSource.addProduct(tProductModel)).thenThrow(Exception('Server error'));

      // Act
      final result = await repository.addProduct(tProduct);

      // Assert
      expect(result, Left(ServerFailure('Server failure: Exception: Server error')));
    });
  });

  group('deleteProduct', () {
    test('should return true when deletion is successful and update cache', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      when(mockRemoteDataSource.deleteProduct(tProductId)).thenAnswer((_) async => true);
      when(mockLocalDataSource.getAllProdcuts()).thenAnswer((_) async => [tProductModel]);
      when(mockLocalDataSource.cachedProducts(any)).thenAnswer((_) async => true);

      // Act
      final result = await repository.deleteProduct(tProductId);

      // Assert
      expect(result, const Right(true));
    });

    test('should return ServerFailure when deletion fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      when(mockRemoteDataSource.deleteProduct(tProductId)).thenThrow(Exception('Server error'));

      // Act
      final result = await repository.deleteProduct(tProductId);

      // Assert
      expect(result, Left(ServerFailure('Server failure: Exception: Server error')));
    });

    test('should return ServerFailure when there is no internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => false);

      // Act
      final result = await repository.deleteProduct(tProductId);

      // Assert
      expect(result, Left(ServerFailure('No internet connection')));
    });
  });

  group('getSingleProduct', () {
    test('should return remote product when there is internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getSingleProduct(tProductId)).thenAnswer((_) async => tProductModel);

      // Act
      final result = await repository.getSingleProduct(tProductId);

      // Assert
      expect(result, Right(tProductModel));
    });

    test('should return product from cache when there is no internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => false);
      when(mockLocalDataSource.getSingleProduct(tProductId)).thenReturn(tProductModel);

      // Act
      final result = await repository.getSingleProduct(tProductId);

      // Assert
      expect(result, Right(tProductModel));
    });

    test('should return CacheFailure when remote product fails and no cache available', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getSingleProduct(tProductId)).thenThrow(Exception('Server error'));
      when(mockLocalDataSource.getSingleProduct(tProductId)).thenThrow(Exception('Cache error'));

      // Act
      final result = await repository.getSingleProduct(tProductId);

      // Assert
      expect(result, Left(CacheFailure('Cache failure: Exception: Cache error')));
    });
  });

  group('updateProduct', () {
    test('should return updated product when there is internet connection and remote update succeeds', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      when(mockRemoteDataSource.updateProduct(tProductId, tProductModel)).thenAnswer((_) async => tProductModel);
      when(mockLocalDataSource.getAllProdcuts()).thenAnswer((_) async => [tProductModel]);
      when(mockLocalDataSource.cachedProducts(any)).thenAnswer((_) async => true);

      // Act
      final result = await repository.updateProduct(tProductId, tProduct);

      // Assert
      expect(result, Right(tProductModel));
    });

    test('should return ServerFailure when there is internet connection and remote update fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      when(mockRemoteDataSource.updateProduct(tProductId, tProductModel)).thenThrow(Exception('Server error'));

      // Act
      final result = await repository.updateProduct(tProductId, tProduct);

      // Assert
      expect(result, Left(ServerFailure('Server failure: Exception: Server error')));
    });

    test('should return updated product when there is no internet connection and local update succeeds', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => false);
      when(mockLocalDataSource.updateProduct(tProductId, tProductModel)).thenAnswer((_) async => tProductModel);

      // Act
      final result = await repository.updateProduct(tProductId, tProduct);

      // Assert
      expect(result, Right(tProductModel));
    });

    test('should return CacheFailure when there is no internet connection and local update fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => false);
      when(mockLocalDataSource.updateProduct(tProductId, tProductModel)).thenThrow(Exception('Cache error'));

      // Act
      final result = await repository.updateProduct(tProductId, tProduct);

      // Assert
      expect(result, Left(CacheFailure('Cache failure: Exception: Cache error')));
    });
  });

  group('getAllProduct', () {
    test('should return all products from remote source when there is internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllProduct()).thenAnswer((_) async => tProductList);
      when(mockLocalDataSource.cachedProducts(any)).thenAnswer((_) async => true);

      // Act
      final result = await repository.getAllProduct();

      // Assert
      expect(result, Right(tProductList));
    });

    test('should return all products from cache when there is no internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => false);
      when(mockLocalDataSource.getAllProdcuts()).thenAnswer((_) async => tProductList);

      // Act
      final result = await repository.getAllProduct();

      // Assert
      expect(result, Right(tProductList));
    });

    test('should return ServerFailure when there is internet connection and remote source fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllProduct()).thenThrow(Exception('Server error'));

      // Act
      final result = await repository.getAllProduct();

      // Assert
      expect(result, Left(ServerFailure('Server failure: Exception: Server error')));
    });

    test('should return CacheFailure when there is no internet connection and cache fails', () async {
      // Arrange
      when(mockNetworkInfo.isConnected()).thenAnswer((_) async => false);
      when(mockLocalDataSource.getAllProdcuts()).thenThrow(Exception('Cache error'));

      // Act
      final result = await repository.getAllProduct();

      // Assert
      expect(result, Left(CacheFailure('Cache failure: Exception: Cache error')));
    });
  });
}
