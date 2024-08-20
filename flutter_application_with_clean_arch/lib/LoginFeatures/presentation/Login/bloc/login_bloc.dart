import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../domain/entities/user_entities.dart';
import '../../../domain/use_cases/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;
  LoginBloc({required this.loginUsecase}) : super(LoginInitial()) {
    on<LoginEvent>(_logIn);
  }

  void _logIn(LoginEvent event, Emitter<LoginState> emit) async {
    if (event is LoginUser) {
      emit(LoginLoading());
      final result = await loginUsecase.execute(event.email, event.password);
      result.fold(
        (failure) => emit(LoginFailure(failure)),
        (user) => emit(LoginSuccess(user)),
      );
    }
  }
}
