import 'dart:convert';

import 'package:flutter_application_with_clean_arch/features/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/dummy_data/json_reader.dart';

void main() {
  var testProductModel = ProductModel(
    name: 'Product 1',
    description: 'Description of Product 1',
    image: 'https://example.com/images/product1.png',
    price: 50.0,
    id: '1',
  );

  test("this should test the model is the same as the entity", () async {
    // assert
    expect(testProductModel, isA<ProductModel>());
  });

  test("should have a valid model from the json", () async {
    // arrange
    final List<dynamic> jsonList = json.decode(readJson("helpers/dummy_data/dummy_product.json"));

    // Assume you are only interested in the first product in the list
    final Map<String, dynamic> jsonMap = jsonList[0];

    // act
    final result = ProductModel.fromJson(jsonMap);

    // assert
    expect(result, equals(testProductModel));
  });

  test("should return a json mao with vaild data", 
  ()async
   {
    // act
    final result = testProductModel.toJson();

    final expectedJsonMap = {
      'name': 'Product 1',
      'description': 'Description of Product 1',
      'image': 'https://example.com/images/product1.png',
      'price': 50,
      'id': '1',
    };
    expect(result, equals(expectedJsonMap));
   });
}
