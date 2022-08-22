import '../models/validator.dart';

class PasswordValidator extends Validator {
  @override
  bool isValid(String value) {
    return value.length >= 6;
  }
}