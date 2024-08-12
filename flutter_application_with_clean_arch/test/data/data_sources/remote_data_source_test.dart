import 'dart:convert';
import 'package:flutter_application_with_clean_arch/features/data/data_sources/remote_data_source.dart';
import 'package:flutter_application_with_clean_arch/features/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../helpers/dummy_data/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late ProductRemoteDataSourceImpl productRemoteDataSourceImp;

  setUp(() {
    mockHttpClient = MockHttpClient();
    productRemoteDataSourceImp = ProductRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get a single element', 
  (){
    const obj = {
      'name': 'Product 1',
      'description': 'Product Description',
      'image': 'https://example.com/images/updated_product.png',
      'price': 50,
      'id': '1'
    };
    const testProductModel = ProductModel(
      name: 'Product 1',
      description: 'Product Description',
      image: 'https://example.com/images/updated_product.png',
      price: 50,
      id: '1'
    );
    test('should return a single element with a status code 200',
     ()async{
      // arrange
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode({
            'statusCode': 200,
            'message': '',
            'data': obj,
          }), 200),
      );
      // act 
      final result = await productRemoteDataSourceImp.getSingleProduct('1');

      expect(result, equals(testProductModel));


     });
  });
  group('get all product', () {
    test('should return a list of product models when the response code is 200', () async {
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(
          json.encode({
            'statusCode': 200,
            'message': '',
            'data': json.decode(readJson('helpers/dummy_data/dummy_product.json'))
          }), 200),
      );

      final result = await productRemoteDataSourceImp.getAllProduct();

      expect(result, isA<List<ProductModel>>());
    });

    test('should throw an exception when the response code is not 200 (404)', () async {
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response('Something went wrong', 404),
      );

      final call = productRemoteDataSourceImp.getAllProduct;

      expect(() => call(), throwsException);
    });
  });

  group('should add elements', () {
    const testProductModel =ProductModel(
      name: 'Product 1',
      description: 'Description of Product 1',
      image: 'assets/shoes.png', 
      price: 50, 
      id: '1'
    );

    const testProductjson ={
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'image': 'assets/shoes.png', 
      'price': '50', 
      'id': '1'
    };

    test('should return the created product when response code is 201', () async {
      final byteStream = Stream.fromIterable([utf8.encode(json.encode(testProductjson))]);

      final streamResponse = http.StreamedResponse(byteStream, 201);
      when(mockHttpClient.send(any)
      ).thenAnswer((_)async=>streamResponse);
      final result = await productRemoteDataSourceImp.addProduct(testProductModel);

      expect(result, equals(testProductModel));
    });

    test('should throw an exception when the response is not 201', () async {
      when(mockHttpClient.post(any,
        headers: anyNamed('headers'),
        body: anyNamed('data')
      )).thenAnswer((_) async => http.Response('something went wrong', 404));

      expect(() => productRemoteDataSourceImp.addProduct(testProductModel), throwsException);
    });
  });

  group('should update elements', () {
    const testProductModel = ProductModel(
      name: 'Updated Product',
      description: 'Updated Description',
      image: 'https://example.com/images/updated_product.png',
      price: 60,
      id: '1',
    );

    const obj = {
      'name': 'Updated Product',
      'description': 'Updated Description',
      'image': 'https://example.com/images/updated_product.png',
      'price': 60,
      'id': '1'
    };

    test('should update the product', () async {
      when(mockHttpClient.put(any,
        headers: anyNamed('headers'),
        body: anyNamed('body')
      )).thenAnswer((_) async => http.Response(json.encode({
        'statusCode': 200,
        'message': '',
        'data': obj
      }), 200));

      final result = await productRemoteDataSourceImp.updateProduct(testProductModel.id, testProductModel);

      expect(result, equals(testProductModel));
    });

    test('should throw an exception if the product is not updated', () async {
      when(mockHttpClient.put(any,
        headers: anyNamed('headers'),
        body: anyNamed('body')
      )).thenAnswer((_) async => http.Response('something went wrong', 404));

      expect(() => productRemoteDataSourceImp.updateProduct(testProductModel.id, testProductModel), throwsException);
    });
  });

  group('should delete element successfully', () {
    const id = '1';

    test('should return true when the response code is 204', () async {
      when(mockHttpClient.delete(any)).thenAnswer(
        (_) async => http.Response('', 204),
      );

      final result = await productRemoteDataSourceImp.deleteProduct(id);

      expect(result, isTrue);
    });

    test('should throw an exception when the response code is not 204', () async {
      when(mockHttpClient.delete(any)).thenAnswer(
        (_) async => http.Response('Not Found', 404),
      );

      expect(() => productRemoteDataSourceImp.deleteProduct(id), throwsException);
    });
  });
}
