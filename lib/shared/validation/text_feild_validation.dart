import 'package:form_field_validator/form_field_validator.dart';

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'password is required'),
  MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-])',
      errorText: 'passwords must have at least one special character')
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'email is required'),
  EmailValidator(errorText: 'enter a valid email'),
]);

final nameValidator = MultiValidator([
  RequiredValidator(errorText: 'username is required'),
  MinLengthValidator(2, errorText: 'username must be at least 2 digits'),
  MaxLengthValidator(24, errorText: 'username must be at more 24 digits'),
]);

final confirmPasswordValidator = MultiValidator([
  RequiredValidator(errorText: 'password is required'),
]);

final none = MultiValidator([
]);