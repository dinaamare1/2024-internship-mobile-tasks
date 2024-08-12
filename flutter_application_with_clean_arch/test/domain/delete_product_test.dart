import 'package:dartz/dartz.dart';
import 'package:flutter_application_with_clean_arch/features/domain/usecases/delete_product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/test_helper.mocks.dart';

void main() {
  late DeleteProductUseCase deleteProductUseCase;
  late MockProductRepository mockProductRepository;

  setUp(() {
    mockProductRepository = MockProductRepository();
    deleteProductUseCase = DeleteProductUseCase(mockProductRepository);
  });

  const String id = '1';
  // const product = Product(
  //   name: 'Test Product',
  //   description: 'This is a test product',
  //   image: 'test_image.png',
  //   price: 100,
  //   id: id,
  // );

  test('should delete the element', () async {
    // arrange
    when(mockProductRepository.deleteProduct(id)).thenAnswer((_) async => const Right(true));

    // act
    final result = await deleteProductUseCase.execute(id);

    // assert
    expect(result, const Right(true));
  });
}
