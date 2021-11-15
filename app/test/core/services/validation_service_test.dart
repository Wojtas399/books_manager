import 'package:app/core/services/validation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('checkValue', () {
    ValidationService service = new ValidationService();
    group('username', () {
      group('username is correct', () {
        test('Should return true', () {
          bool result = service.checkValue(ValidationKey.username, 'username');
          expect(result, true);
        });
      });

      group('username is incorrect', () {
        test('Should return false', () {
          bool result = service.checkValue(ValidationKey.username, 'us');
          expect(result, false);
        });
      });
    });

    group('email', () {
      group('email is correct', () {
        test('Should return true', () {
          bool result = service.checkValue(
            ValidationKey.email,
            'jannowak@example.com',
          );
          expect(result, true);
        });
      });

      group('email is incorrect', () {
        test('Should return false', () {
          bool result = service.checkValue(
            ValidationKey.email,
            'jannowakexample.com',
          );
          expect(result, false);
        });
      });
    });
  });
}
