// lib/features/search/bloc/search_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

class UpdatePriceFilter extends SearchEvent {
  final RangeValues priceRange;

  const UpdatePriceFilter({required this.priceRange});

  @override
  List<Object> get props => [priceRange];
}

class RefreshSearchEvent extends SearchEvent {}
