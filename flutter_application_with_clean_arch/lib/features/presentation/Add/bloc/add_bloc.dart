import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:formz/formz.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/usecases/add_product.dart';
import '../../formz/formz_validations.dart';
import 'add_event.dart';
import 'add_state.dart';

class AddBloc extends Bloc<AddEvent, AddState> {
  final AddProductUseCase addProductUseCase;

  AddBloc({required this.addProductUseCase}) : super(const AddState()) {
    on<ProductNameChanged>(_onNameChanged);
    on<ProductPriceChanged>(_onPriceChanged);
    on<ProductDescriptionChanged>(_onDescriptionChanged);
    on<ProductImageChanged>(_onImageChanged);
    on<AddProductSubmitted>(_onProductSubmitted);
  }

  void _onNameChanged(ProductNameChanged event, Emitter<AddState> emit) {
    final name = ProductName.dirty(event.name);
    emit(state.copyWith(name: name));
  }

  void _onPriceChanged(ProductPriceChanged event, Emitter<AddState> emit) {
    final price = ProductPrice.dirty(event.price);
    emit(state.copyWith(price: price));
  }

  void _onDescriptionChanged(ProductDescriptionChanged event, Emitter<AddState> emit) {
    final description = ProductDescription.dirty(event.description);
    emit(state.copyWith(description: description));
  }

  void _onImageChanged(ProductImageChanged event, Emitter<AddState> emit) {
    emit(state.copyWith(imagePath: event.imagePath));
  }

  Future<void> _onProductSubmitted(AddProductSubmitted event, Emitter<AddState> emit) async {
    final name = ProductName.dirty(state.name.value);
    final price = ProductPrice.dirty(state.price.value);
    final description = ProductDescription.dirty(state.description.value);

    final isValid = Formz.validate([name, price, description]);

    if (!isValid) {
      emit(state.copyWith(name: name, price: price, description: description, status: FormzSubmissionStatus.failure));
      return;
    }

    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final result = await addProductUseCase.execute(Product(
      name: name.value,
      price: double.parse(price.value),
      description: description.value,
      image: state.imagePath,
    ));

    result.fold(
      (failure) => emit(state.copyWith(status: FormzSubmissionStatus.failure)),
      (product) => emit(state.copyWith(status: FormzSubmissionStatus.success)),
    );
  }
}
