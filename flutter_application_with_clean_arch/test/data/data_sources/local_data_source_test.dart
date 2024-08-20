import 'dart:convert';

import 'package:flutter_application_with_clean_arch/features/data/data_sources/local_data_source.dart';
import 'package:flutter_application_with_clean_arch/features/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_helper.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {

  late LocalDataSourceImp localDataSourceImp;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSourceImp = LocalDataSourceImp(sharedPreferences: mockSharedPreferences);
  });

  group('local data source implmentations', (){
    final testProductModel = ProductModel(
      name: 'Product 1',
      description: 'Product Description',
      image: 'assets/image.png',
      price: 50,
      id: '1',
    );
    final updatedProduct = ProductModel(
        name: 'Updated Product',
        description: 'Updated Description',
        image: 'assets/updated_image.png',
        price: 60,
        id: '1',
      );
    var products = [testProductModel];
    test('should cache products succesfully',
     ()async {
      var products = [testProductModel];
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_)async => true);

      // act
      final result =  await localDataSourceImp.cachedProducts(products);

      // assert
      expect(result, isTrue);
    });
    test('should show if it didnt cache products',
     ()async {
      
      // arrange
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_)async => false);

      // assert
      expect(localDataSourceImp.cachedProducts(products), throwsException);
    });

    test('should get all the products',
     ()async{
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(json.encode([testProductModel.toJson()]));

      final result = localDataSourceImp.getAllProdcuts();

      expect(result, equals(products));
    });
    test('should throw the execption when their is no products', 
    ()async{
      when(mockSharedPreferences.getString(any)).thenThrow(throwsException);
    });
    test('should update the product', 
    ()async {
      
      when(mockSharedPreferences.getString(any)).thenReturn(json.encode([testProductModel.toJson()]));
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

      final result = await localDataSourceImp.updateProduct('1', updatedProduct);

      expect(result, equals(updatedProduct));
    });
    test('should throw the execption', 
    ()async {
      when(mockSharedPreferences.getString(any)).thenReturn(json.encode([testProductModel.toJson()]));
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => false);
      expect(localDataSourceImp.updateProduct('4', updatedProduct), throwsException);
    });

    test('should delete the product',
     ()async{
      when(mockSharedPreferences.getString(any)).thenReturn(json.encode([testProductModel.toJson()]));
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);

      final result = await localDataSourceImp.deleteProduct('1');

      expect(result, isTrue);

     });
     test('should throw exception if the product doesnt exist',
     ()async{
      when(mockSharedPreferences.getString(any)).thenReturn(json.encode([testProductModel.toJson()]));
      expect(()=> localDataSourceImp.deleteProduct('5'), throwsException);
     });

     test('should get a single product', 
     ()async{
      when(mockSharedPreferences.getString(any)).thenReturn(json.encode([testProductModel.toJson()]));

      final result = localDataSourceImp.getSingleProduct('1');

      expect(result, equals(testProductModel));
     });
    test('should throw an exception if product is not found', () async {
      when(mockSharedPreferences.getString(any)).thenReturn(json.encode([testProductModel.toJson()]));

      expect(() => localDataSourceImp.getSingleProduct('3'), throwsException);
    });
  });


}
