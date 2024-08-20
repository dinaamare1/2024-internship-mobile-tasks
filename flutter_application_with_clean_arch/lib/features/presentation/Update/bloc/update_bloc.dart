import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/usecases/update_product.dart';
import '../../formz/formz_validations.dart';
import 'update_state.dart';

part 'update_event.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  final UpdateProductUseCase updateProductUseCase;

  UpdateBloc({required this.updateProductUseCase}) : super(const UpdateState()) {
    on<UpdateProductSubmitted>(_update);
    on<ProductNameChanged>(_nameChanged);
    on<ProductPriceChanged>(_priceChanged);
    on<ProductDescriptionChanged>(_descriptionChanged);
    on<ProductImageChanged>(_imageChanged);
    on<populateEvent>(_populate);
  }

  FutureOr<void> _nameChanged(ProductNameChanged event, Emitter<UpdateState> emit) {
    final name = ProductName.dirty(event.name);
    emit(state.copyWith(name: name, pageStatus: UpdateStateeEnum.loading));
  }

  FutureOr<void> _priceChanged(ProductPriceChanged event, Emitter<UpdateState> emit) {
    final price = ProductPrice.dirty(event.price);
    emit(state.copyWith(price: price, pageStatus: UpdateStateeEnum.loading));
  
  }

  FutureOr<void> _descriptionChanged(ProductDescriptionChanged event, Emitter<UpdateState> emit) {
    final description = ProductDescription.dirty(event.description);
    emit(state.copyWith(description: description, pageStatus: UpdateStateeEnum.loading));
  }
  
  FutureOr<void> _update(UpdateProductSubmitted event, Emitter<UpdateState> emit) async { 
    final name = ProductName.dirty(event.name);
    final price = ProductPrice.dirty(event.price.toString());
    final description = ProductDescription.dirty(event.description);
    final isValid = Formz.validate([name, price, description]);
    if (!isValid) {
      emit(state.copyWith(name: name, price: price, description: description, status: FormzSubmissionStatus.failure));
      return;
    }
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));

    final priceValue = double.tryParse(price.value) ?? 0;

    final result = await updateProductUseCase.execute(
      event.id,
      Product(
        name: name.value,
        price: priceValue,
        description: description.value,
        image: event.product.image,
      ),
    );
    result.fold(
      (failure) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      },
      (isUpdated) {
        
        emit(state.copyWith(status: FormzSubmissionStatus.success, pageStatus: UpdateStateeEnum.updated));
      },
    );
  }

  FutureOr<void> _imageChanged(ProductImageChanged event, Emitter<UpdateState> emit) {
    final image = event.imagePath;
    emit(state.copyWith(imagePath: image));
  }

  FutureOr<void> _populate(populateEvent event, Emitter<UpdateState> emit) {
    final name = ProductName.dirty(event.name);
    final price = ProductPrice.dirty(event.Price.toString());
    final description = ProductDescription.dirty(event.description);
    emit(UpdateState(name: name,price: price,description: description));

  }
  // @override
  // void onChange(Change<UpdateState> change) {
  //   super.onChange(change);
  //   print(change.currentState);
  //   print(change.nextState);
  // }
}
