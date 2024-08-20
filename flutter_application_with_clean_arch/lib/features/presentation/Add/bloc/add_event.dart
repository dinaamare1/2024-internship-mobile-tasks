import 'package:equatable/equatable.dart';

abstract class AddEvent extends Equatable {
  const AddEvent();

  @override
  List<Object?> get props => [];
}

class ProductNameChanged extends AddEvent {
  final String name;

  const ProductNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

class ProductPriceChanged extends AddEvent {
  final String price;

  const ProductPriceChanged(this.price);

  @override
  List<Object?> get props => [price];
}

class ProductDescriptionChanged extends AddEvent {
  final String description;

  const ProductDescriptionChanged(this.description);

  @override
  List<Object?> get props => [description];
}

class ProductImageChanged extends AddEvent {
  final String imagePath;

  const ProductImageChanged(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class AddProductSubmitted extends AddEvent {
  const AddProductSubmitted();
}
