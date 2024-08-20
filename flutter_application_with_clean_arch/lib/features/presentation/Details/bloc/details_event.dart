part of 'details_bloc.dart';

sealed class DetailsEvent extends Equatable {
  const DetailsEvent();

  @override
  List<Object> get props => [];
}

class FetchProductEvent extends DetailsEvent {
  final String id;
  const FetchProductEvent({required this.id});
}

class DeleteProductEvent extends DetailsEvent {
  final String id;
  const DeleteProductEvent({required this.id});
}

class UpdateProductEvent extends DetailsEvent {
  final Product product;
  final String id;
  const UpdateProductEvent({required this.product,required this.id});
}