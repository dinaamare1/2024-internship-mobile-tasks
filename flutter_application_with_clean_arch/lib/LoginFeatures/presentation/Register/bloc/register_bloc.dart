import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entities.dart';
import '../../../domain/use_cases/register_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUsecase registerUsecase;
  RegisterBloc({required this.registerUsecase}) : super(RegisterInitial()){
    on<RegisterUser>(_register);
  }
  
  FutureOr<void> _register(RegisterUser event, Emitter<RegisterState> emit) async {
    emit(RegisterLoading());
    final result = await registerUsecase.execute(event.email, event.password, event.name);
    result.fold(
      (failure) => emit(RegisterFailure(message: failure.message)),
      (user) => emit(RegisterSuccess(user: user)),
    ); 
  }
}
