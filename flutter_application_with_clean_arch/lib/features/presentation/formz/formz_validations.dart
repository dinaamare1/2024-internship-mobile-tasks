import 'dart:io';

import 'package:formz/formz.dart';

enum NameValidationError { empty }
enum PriceValidationError { invalid }
enum DescriptionValidationError { empty }
enum ImageValidationError { empty }

class ProductName extends FormzInput<String, NameValidationError> {
  const ProductName.pure() : super.pure('');
  const ProductName.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String value) {
    return value.isNotEmpty ? null : NameValidationError.empty;
  }
}

class ProductPrice extends FormzInput<String, PriceValidationError> {
  const ProductPrice.pure() : super.pure('');
  const ProductPrice.dirty([String value = '']) : super.dirty(value);

  @override
  PriceValidationError? validator(String value) {
    return double.tryParse(value) != null ? null : PriceValidationError.invalid;
  }
}

class ProductDescription extends FormzInput<String, DescriptionValidationError> {
  const ProductDescription.pure() : super.pure('');
  const ProductDescription.dirty([String value = '']) : super.dirty(value);

  @override
  DescriptionValidationError? validator(String value) {
    return value.isNotEmpty ? null : DescriptionValidationError.empty;
  }
}

class ProductImage extends FormzInput<File?, ImageValidationError> {
  const ProductImage.pure() : super.pure(null);
  const ProductImage.dirty([File? value]) : super.dirty(value);

  @override
  ImageValidationError? validator(File? value) {
    return value != null ? null : ImageValidationError.empty;
  }
}