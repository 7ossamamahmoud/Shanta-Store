part of 'register_cubit.dart';

@immutable
abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterSuccessfulState extends RegisterStates {
  final UserAuthModel userModel;

  RegisterSuccessfulState({required this.userModel});
}

class ChangePasswordVisibilityState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  final String errMessage;

  RegisterErrorState({required this.errMessage});
}
