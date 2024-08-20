part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchProducts extends SearchEvent {
  final String query;

  const SearchProducts({required this.query});

  @override
  List<Object> get props => [query];
}

class InitializeSearch extends SearchEvent {
  final List<Product> products;

  const InitializeSearch({required this.products});

  @override
  List<Object> get props => [products];
}

class UpdatePriceFilter extends SearchEvent {
  final RangeValues priceRange;

  const UpdatePriceFilter({required this.priceRange});

  @override
  List<Object> get props => [priceRange];
}
