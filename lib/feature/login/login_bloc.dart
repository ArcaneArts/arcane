import 'package:arcane/arcane.dart';
import 'package:arcane/feature/login/login_service.dart';
import 'package:arcane/feature/service/user_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginEvent {}

class LoginAppleEvent extends LoginEvent {}

class LoginGoogleEvent extends LoginEvent {}

enum LoginState { normal, loading, success, error }

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final bool logErrors;

  LoginBloc({this.logErrors = true}) : super(LoginState.normal) {
    on<LoginAppleEvent>(loginWithApple);
    on<LoginGoogleEvent>(loginWithGoogle);
  }

  Future<void> loginWithApple(LoginAppleEvent event, Emitter<LoginState> emit) {
    emit(LoginState.loading);
    return svc<LoginService>()
        .signInWithApple()
        .then((value) => loginSuccess(emit))
        .catchError((e, es) => loginError(emit, e, es));
  }

  Future<void> loginWithGoogle(
      LoginGoogleEvent event, Emitter<LoginState> emit) {
    emit(LoginState.loading);
    return svc<LoginService>()
        .signInWithGoogle()
        .then((value) => loginSuccess(emit))
        .catchError((e, es) => loginError(emit, e, es));
  }

  void loginError(Emitter<LoginState> emit, dynamic e, dynamic es) {
    if (logErrors) {
      Arcane.logger.handle(e, es, "Login Failure");
    }

    emit(LoginState.error);
    emit(LoginState.normal);
  }

  Future<void> loginSuccess(Emitter<LoginState> emit) {
    return svc<UserService>()
        .bind(svc<UserService>().uid())
        .then((value) => emit(LoginState.success))
        .then((value) => emit(LoginState.normal));
  }
}
