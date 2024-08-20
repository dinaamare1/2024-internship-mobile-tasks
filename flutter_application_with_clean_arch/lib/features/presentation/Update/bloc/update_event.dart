part of 'update_bloc.dart';

sealed class UpdateEvent extends Equatable {
  const UpdateEvent();

  @override
  List<Object> get props => [];
}

class ProductNameChanged extends UpdateEvent {
  final String name;

  ProductNameChanged(this.name);

  @override
  List<Object> get props => [name];
  
}
class ProductPriceChanged extends UpdateEvent {
  final String price;

  ProductPriceChanged(this.price);

  @override
  List<Object> get props => [price];
}

class ProductImageChanged extends UpdateEvent {
  final String? imagePath;
  ProductImageChanged({required this.imagePath});
}

class ProductDescriptionChanged extends UpdateEvent {
  final String description;

  ProductDescriptionChanged(this.description);

  @override
  List<Object> get props => [description];
  
}

class UpdateProductSubmitted extends UpdateEvent {
  final String id;
  final Product product;
  final String name;
  final double price;
  final String description;
  

  UpdateProductSubmitted({
    required this.id,
    required this.product,
    required this.name,
    required this.price,
    required this.description,
  });

  @override
  List<Object> get props => [id, product, name, price, description];
}
class populateEvent  extends UpdateEvent{
 final String name;
 final  Price;
 final String description;

  populateEvent({required this.name, required this.Price, required this.description});
}