import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/product.dart';
import 'search_state.dart';

part 'search_event.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<Product> initialProducts;
  String _query = '';
  RangeValues _currentPriceRange = RangeValues(0, 100);

  SearchBloc({required this.initialProducts}) : super(SearchInitial()) {
    add(SearchProducts(query: _query));
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchProducts || event is UpdatePriceFilter) {
      yield SearchLoading();
      try {
        if (event is SearchProducts) {
          _query = event.query;
        }
        if (event is UpdatePriceFilter) {
          _currentPriceRange = event.priceRange;
        }
        final filteredProducts = _filterProducts(initialProducts);
        yield SearchLoaded(products: filteredProducts);
      } catch (e) {
        yield SearchError(message: e.toString());
      }
    }
  }

  List<Product> _filterProducts(List<Product> products) {
    return products.where((product) {
      final matchesName = product.name.toLowerCase().contains(_query.toLowerCase());
      final matchesPrice = product.price >= _currentPriceRange.start && product.price <= _currentPriceRange.end;
      return matchesName && matchesPrice;
    }).toList();
  }
}
