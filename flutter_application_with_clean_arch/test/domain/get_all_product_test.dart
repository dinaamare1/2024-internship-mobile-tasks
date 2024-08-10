import 'package:dartz/dartz.dart';
import 'package:flutter_application_with_clean_arch/features/domain/entities/product.dart';
import 'package:flutter_application_with_clean_arch/features/domain/usecases/get_all_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
// import 'package:mocktail/mocktail.dart';

import '../helpers/test_helper.mocks.dart';

void main(){
  late GetAllProductUseCase getAllProductUseCase;
  late MockProductRepository mockProductRepository;

  setUp((){
    mockProductRepository = MockProductRepository();
    getAllProductUseCase = GetAllProductUseCase(mockProductRepository);
  });

  const products = <Product>[];
  test("should display all products",
   ()async {
    // arrange
    when(mockProductRepository.getAllProduct())
        .thenAnswer((_) async => Right(products));

    //  act

    final result = await getAllProductUseCase.execute();

    // assert 
    expect(result, Right(products));
   });

}