import 'package:equatable/equatable.dart';

import '../../../domain/entities/product.dart';

enum HomePageStatusEnum { homeInitial, homeLoading, homeLoaded, homeError,homeLoggedOut }

class HomePageState extends Equatable {
  final HomePageStatusEnum status;
  final List<Product>? products;
  final String? name;

  const HomePageState({
    this.status = HomePageStatusEnum.homeInitial,
    this.products,
    this.name,
  });
  HomePageState copyWith(
   { HomePageStatusEnum? status,
    List<Product>? products,
    String? name,}
  ) {
    return HomePageState(
      status: status ?? this.status,
      products: products ?? this.products,
      name: name ?? this.name,

    );
  }
  
  @override
  List<Object?> get props => [status, products,name];
}
