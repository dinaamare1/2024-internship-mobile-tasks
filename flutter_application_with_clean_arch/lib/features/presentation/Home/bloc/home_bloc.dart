import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../LoginFeatures/domain/use_cases/logout_usecase.dart';
import '../../../domain/usecases/get_all_product.dart';
import 'home_state.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomePageState> {
  final GetAllProductUseCase getAllProductUseCase;
  final LogoutUsecase logoutUsecase;
  HomeBloc({required this.logoutUsecase,required this.getAllProductUseCase}) : super(const HomePageState(status: HomePageStatusEnum.homeInitial)){
     on<FetchProductsEvent>(_fetch);
     on<RefreshProductEvent>(_fetch);
     on<LogoutUserEvent>(_logout);
     on<GetName>(_getname);
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
  Future<void> _logout(LogoutUserEvent event, Emitter<HomePageState> emit) async {
    emit(state.copyWith(status: HomePageStatusEnum.homeLoading));
    final result = await logoutUsecase.execute();
    result.fold(
      (failure) => emit(state.copyWith(status: HomePageStatusEnum.homeError)),
      (_) => emit(state.copyWith(status: HomePageStatusEnum.homeInitial)),
    );
  }
  FutureOr<void> _getname(GetName event, Emitter<HomePageState> emit) {
    emit(state.copyWith(name: event.name));
  }
}
