import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/get_all_product.dart';
import 'home_state.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomePageState> {
  final GetAllProductUseCase getAllProductUseCase;
  HomeBloc({required this.getAllProductUseCase}) : super(const HomePageState(status: HomePageStatusEnum.homeInitial)){
     on<FetchProductsEvent>(_fetch);
     on<RefreshProductEvent>(_fetch);
  }
  
  Future<void> _fetch(HomeEvent event, Emitter<HomePageState> emit) async {
  emit(state.copyWith(status: HomePageStatusEnum.homeLoading));

  final result = await getAllProductUseCase.execute();
  print(result);
   
  result.fold(
    (failure) => emit(state.copyWith(status: HomePageStatusEnum.homeError)),
    (products) => emit(state.copyWith(status: HomePageStatusEnum.homeLoaded, products: products)),
  );
  }
}
