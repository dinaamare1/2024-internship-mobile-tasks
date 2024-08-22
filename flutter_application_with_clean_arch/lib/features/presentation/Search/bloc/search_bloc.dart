import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/product.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<Product> allProducts;

  SearchBloc({required this.allProducts}) : super(SearchInitial()) {
    on<SearchProducts>((event, emit) => _handleSearchProducts(event.query, emit));
    on<UpdatePriceFilter>((event, emit) => _handleUpdatePriceFilter(event.priceRange, emit));
  }

  void _handleSearchProducts(String query, Emitter<SearchState> emit) {
    emit(SearchLoading());
    final filteredProducts = _filterProducts(query: query);
    emit(SearchLoaded(products: filteredProducts));
  }

  void _handleUpdatePriceFilter(RangeValues priceRange, Emitter<SearchState> emit) {
    emit(SearchLoading());
    final filteredProducts = _filterProducts(priceRange: priceRange);
    emit(SearchLoaded(products: filteredProducts));
  }

  List<Product> _filterProducts({String? query, RangeValues? priceRange}) {
    final lowerCaseQuery = query?.toLowerCase();
    return allProducts.where((product) {
      final matchesQuery = lowerCaseQuery == null || product.name.toLowerCase().contains(lowerCaseQuery);
      final matchesPriceRange = priceRange == null || (product.price >= priceRange.start && product.price <= priceRange.end);
      return matchesQuery && matchesPriceRange;
    }).toList();
  }
}
