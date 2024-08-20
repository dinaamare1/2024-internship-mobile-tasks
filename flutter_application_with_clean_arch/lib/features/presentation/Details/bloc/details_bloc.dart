import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/usecases/delete_product.dart';
import '../../../domain/usecases/get_single_product.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsPageState> {
  final GetSingleProductUseCase getSingleProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  DetailsBloc({ 
    required this.getSingleProductUseCase,
    required this.deleteProductUseCase,

  }) : super(const DetailsPageState()) {
    on<FetchProductEvent>(_fetch);
    on<DeleteProductEvent>(_delete);
  }
  FutureOr<void> _fetch(FetchProductEvent event, Emitter<DetailsPageState> emit) async {
    emit(state.copyWith(status: DetailsPageStatusEnum.loading));
    final result = await getSingleProductUseCase.execute(event.id);
    result.fold(
      (failure) => emit(state.copyWith(status: DetailsPageStatusEnum.error)),
      (product) => emit(state.copyWith(status: DetailsPageStatusEnum.loaded, product: product)),
    );
  }

  FutureOr<void> _delete(DeleteProductEvent event, Emitter<DetailsPageState> emit) async {
    emit(state.copyWith(status: DetailsPageStatusEnum.loading));
    final result = await deleteProductUseCase.execute(event.id);
    print(result);
      result.fold(
        (failure) => emit(state.copyWith(status: DetailsPageStatusEnum.error)),
        (isDeleted) {
        if (isDeleted) {
          emit(state.copyWith(status: DetailsPageStatusEnum.deleted));
        } else {
          emit(state.copyWith(status: DetailsPageStatusEnum.error));
        }
        }
      );
  }

}