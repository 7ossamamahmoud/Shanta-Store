part of 'login_cubit.dart';

@immutable
abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class ChangePasswordVisibilityState extends LoginStates {}

class LoginSuccessfulState extends LoginStates {
  final UserAuthModel loginModel;

  LoginSuccessfulState({required this.loginModel});
}

class LoginErrorState extends LoginStates {
  final String error;

  LoginErrorState({required this.error});
}
