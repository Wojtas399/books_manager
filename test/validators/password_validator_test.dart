import 'package:flutter_test/flutter_test.dart';

import 'package:app/validators/password_validator.dart';

void main() {
  final PasswordValidator validator = PasswordValidator();

  test(
    'should return true if password is longer or equal to 6 characters',
    () {
      const String password = 'password';

      final bool isValid = validator.isValid(password);

      expect(isValid, true);
    },
  );

  test(
    'should return false if password is shorter than 6 characters',
    () {
      const String password = 'passw';

      final bool isValid = validator.isValid(password);

      expect(isValid, false);
    },
  );
}
