import 'package:flutter_test/flutter_test.dart';

import 'package:app/validators/email_validator.dart';

void main() {
  final EmailValidator validator = EmailValidator();

  test(
    'should return true if email is correct',
    () {
      const String email = 'email@example.com';

      final bool isValid = validator.isValid(email);

      expect(isValid, true);
    },
  );

  test(
    'should return false if email does not contain domain name',
    () {
      const String email = 'email@example.';

      final bool isValid = validator.isValid(email);

      expect(isValid, false);
    },
  );

  test(
    'should return false if email does not contain monkey mark',
    () {
      const String email = 'emailexample.com';

      final bool isValid = validator.isValid(email);

      expect(isValid, false);
    },
  );

  test(
    'should return false if email does not contain characters after monkey mark',
    () {
      const String email = 'email@.com';

      final bool isValid = validator.isValid(email);

      expect(isValid, false);
    },
  );
}
