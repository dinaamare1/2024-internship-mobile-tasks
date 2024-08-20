import 'package:dartz/dartz.dart';
import 'package:flutter_application_with_clean_arch/features/domain/entities/product.dart';
import 'package:flutter_application_with_clean_arch/features/domain/usecases/update_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_helper.mocks.dart';

void main(){

  late MockProductRepository mockProductRepository;
  late UpdateProductUseCase updateProductUseCase;

  setUp((){
    mockProductRepository = MockProductRepository();
    updateProductUseCase = UpdateProductUseCase(productRepository:mockProductRepository);
  });

  const id = "1";
  const product = Product(name: "jhsdnfjdf", description: "jnsdnfksmndfj", image: "jhasdjhfjs", price: 10, id: "1");


  test("should update and return the product",
   ()async{
    // arrange
    when(mockProductRepository.updateProduct(id, product)).thenAnswer((_)async=>Right(product));

    // act
    final result = await updateProductUseCase.execute(id, product);

    // assert
    expect(result, Right(product));

  });

}