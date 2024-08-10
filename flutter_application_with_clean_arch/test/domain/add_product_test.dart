import 'package:dartz/dartz.dart';
import 'package:flutter_application_with_clean_arch/features/domain/entities/product.dart';
import 'package:flutter_application_with_clean_arch/features/domain/usecases/add_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.mocks.dart';


void main(){
  late AddProductUseCase addProductUseCase;
  late MockProductRepository mockProductRepository;

  setUp((){
    mockProductRepository = MockProductRepository();
    addProductUseCase = AddProductUseCase(mockProductRepository);
  });
  const product = Product(
    name: "jsdjfsf",
    description: "jkshdjhkjf", 
    image: "jshdjhkjf", 
    price: 00, 
    id: "id");

  test("should add elememts", 
  ()async{

    //arrange
    when(mockProductRepository.addProduct(product)).thenAnswer((_)async=>Right(product)
    );

  //  act 
   final result = await addProductUseCase.execute(product);

  //  assert
   expect(result, Right(product));


  });

}