import 'package:equatable/equatable.dart';

import '../../../domain/entities/product.dart';

enum HomePageStatusEnum { homeInitial, homeLoading, homeLoaded, homeError }

class HomePageState extends Equatable {
  final HomePageStatusEnum status;
  final List<Product>? products;

  const HomePageState({
    this.status = HomePageStatusEnum.homeInitial,
    this.products,
  });
  HomePageState copyWith(
   { HomePageStatusEnum? status,
    List<Product>? products,}
  ) {
    return HomePageState(
      status: status ?? this.status,
      products: products ?? this.products,
    );
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [status, products];
}
