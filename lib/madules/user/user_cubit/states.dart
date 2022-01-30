import 'package:social_app/model/user_model.dart';

abstract class UserStates {}

class UserInitialState extends UserStates {}

class RegisterChangeVisibilityPassword extends UserStates {}

class RegisterLoadingState extends UserStates {}

class RegisterSuccessState extends UserStates {}

class RegisterErrorState extends UserStates {
  String error;

  RegisterErrorState(this.error);
}

class LoginChangeVisibilityPassword extends UserStates {}

class LoginLoadingState extends UserStates {}

class LoginSuccessState extends UserStates {
  final String id;

  LoginSuccessState(this.id);
}

class LoginErrorState extends UserStates {
  String error;

  LoginErrorState(this.error);
}

class CreateUserLoadingState extends UserStates {}

class CreateUserSuccessState extends UserStates {}

class CreateUserErrorState extends UserStates {
  String error;

  CreateUserErrorState(this.error);
}

class ResetPasswordLoadingState extends UserStates {}

class ResetPasswordSuccessState extends UserStates {}

class ResetPasswordErrorState extends UserStates {}
