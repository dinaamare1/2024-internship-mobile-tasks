import 'package:dartz/dartz.dart';
import 'package:flutter_application_with_clean_arch/core/error/failure.dart';
import 'package:flutter_application_with_clean_arch/core/network/network_info.dart';
import 'package:flutter_application_with_clean_arch/features/data/data_sources/local_contracts.dart';
import 'package:flutter_application_with_clean_arch/features/data/data_sources/remote_contracts.dart';
import 'package:flutter_application_with_clean_arch/features/data/models/product_model.dart';
import 'package:flutter_application_with_clean_arch/features/data/repositories/data_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockProductRemoteDataSource extends Mock implements ProductRemoteDataSource {}
class MockProductLocalDataSource extends Mock implements ProductLocalDataSource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

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

  final tProduct = ProductModel(id: '1', name: 'Product 1', description: 'Description 1', price: 10, image: 'image.png');
  final tProductList = [tProduct];
  
  group('getAllProduct', () {
    test('should return remote products when there is internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllProduct()).thenAnswer((_) async => tProductList);
      when(mockLocalDataSource.getAllProdcuts()).thenAnswer((_) async => []);

      // Act
      final result = await repository.getAllProduct();

      // Assert
      expect(result, Right(tProductList));
      verify(mockRemoteDataSource.getAllProduct());
      verify(mockLocalDataSource.cachedProducts(tProductList));
    });

    test('should return cached products when there is no internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getAllProdcuts()).thenAnswer((_) async => tProductList);

      // Act
      final result = await repository.getAllProduct();

      // Assert
      expect(result, Right(tProductList));
      verify(mockLocalDataSource.getAllProdcuts());
    });

    test('should return failure when both remote and local data sources fail', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAllProduct()).thenThrow(Exception());
      when(mockLocalDataSource.getAllProdcuts()).thenThrow(Exception());

      // Act
      final result = await repository.getAllProduct();

      // Assert
      expect(result, Left(ServerFailure('Server failure: Exception')));
    });
  });

  group('addProduct', () {
    test('should return added product when there is internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.addProduct(tProduct)).thenAnswer((_) async => tProduct);
      when(mockLocalDataSource.getAllProdcuts()).thenAnswer((_) async => tProductList);
      when(mockLocalDataSource.cachedProducts(tProductList)).thenAnswer((_) async => true);

      // Act
      final result = await repository.addProduct(tProduct);

      // Assert
      expect(result, Right(tProduct));
      verify(mockRemoteDataSource.addProduct(tProduct));
      verify(mockLocalDataSource.cachedProducts(tProductList..add(tProduct)));
    });

    test('should return failure when there is no internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.addProduct(tProduct);

      // Assert
      expect(result, Left(ServerFailure('No internet connection')));
    });
  });

  group('deleteProduct', () {
    test('should return true when product is deleted successfully', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.deleteProduct('1')).thenAnswer((_) async => true);
      when(mockLocalDataSource.getAllProdcuts()).thenAnswer((_) async => tProductList);
      when(mockLocalDataSource.cachedProducts([])).thenAnswer((_) async => true);

      // Act
      final result = await repository.deleteProduct('1');

      // Assert
      expect(result, const Right(true));
      verify(mockRemoteDataSource.deleteProduct('1'));
      verify(mockLocalDataSource.cachedProducts([]));
    });

    test('should return failure when there is no internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.deleteProduct('1');

      // Assert
      expect(result, Left(ServerFailure('No internet connection')));
    });
  });

  group('getSingleProduct', () {
    test('should return remote product when there is internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getSingleProduct('1')).thenAnswer((_) async => tProduct);

      // Act
      final result = await repository.getSingleProduct('1');

      // Assert
      expect(result, Right(tProduct));
      verify(mockRemoteDataSource.getSingleProduct('1'));
    });

    test('should return local product when there is no internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.getSingleProduct('1')).thenReturn(tProduct);

      // Act
      final result = await repository.getSingleProduct('1');

      // Assert
      expect(result, Right(tProduct));
      verify(mockLocalDataSource.getSingleProduct('1'));
    });

    test('should return failure when product cannot be found', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getSingleProduct('1')).thenThrow(Exception());
      when(mockLocalDataSource.getSingleProduct('1')).thenThrow(Exception());

      // Act
      final result = await repository.getSingleProduct('1');

      // Assert
      expect(result, Left(CacheFailure('Cache failure: Exception')));
    });
  });

  group('updateProduct', () {
    test('should return updated product when there is internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.updateProduct('1', tProduct)).thenAnswer((_) async => tProduct);
      when(mockLocalDataSource.getAllProdcuts()).thenAnswer((_) async => tProductList);
      when(mockLocalDataSource.cachedProducts(tProductList)).thenAnswer((_) async => true);

      // Act
      final result = await repository.updateProduct('1', tProduct);

      // Assert
      expect(result, Right(tProduct));
      verify(mockRemoteDataSource.updateProduct('1', tProduct));
      verify(mockLocalDataSource.cachedProducts([tProduct]));
    });

    test('should return failure when there is no internet connection', () async {
      // Arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.updateProduct('1', tProduct);

      // Assert
      expect(result, Left(ServerFailure('No internet connection')));
    });
  });
}
