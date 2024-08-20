part of 'details_bloc.dart';

enum DetailsPageStatusEnum { initial, loading, loaded, error,deleted }

class DetailsPageState {
  final DetailsPageStatusEnum status;
  final Product? product;
  const DetailsPageState({
    this.status = DetailsPageStatusEnum.initial,
    this.product,
  });
  DetailsPageState copyWith({
    DetailsPageStatusEnum? status,
    Product? product,
  }) {
    return DetailsPageState(
      status: status ?? this.status,
      product: product ?? this.product,
    );
  }
}