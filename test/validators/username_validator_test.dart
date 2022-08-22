import 'package:flutter_test/flutter_test.dart';

import 'package:app/validators/username_validator.dart';

void main() {
  final UsernameValidator validator = UsernameValidator();

  test(
    'should return true if username is longer or equal to 4 characters',
    () {
      const String username = 'user';

      final bool isValid = validator.isValid(username);

      expect(isValid, true);
    },
  );

  test(
    'should return false if username is shorter than 4 characters',
    () {
      const String username = 'jan';

      final bool isValid = validator.isValid(username);

      expect(isValid, false);
    },
  );
}
