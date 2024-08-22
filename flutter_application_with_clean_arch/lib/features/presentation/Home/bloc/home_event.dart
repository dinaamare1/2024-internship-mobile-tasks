part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class FetchProductsEvent extends HomeEvent {
  const FetchProductsEvent();
}
final class RefreshProductEvent extends HomeEvent {
  const RefreshProductEvent();
}
final class LogoutUserEvent extends HomeEvent {
  const LogoutUserEvent();
}
final class GetName extends HomeEvent {
  final String name;
  const GetName({required this.name});
}