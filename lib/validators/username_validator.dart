import '../models/validator.dart';

class UsernameValidator extends Validator {
  @override
  bool isValid(String value) {
    return value.length >= 4;
  }
}
