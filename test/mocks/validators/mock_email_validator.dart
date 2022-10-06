import 'package:app/validators/email_validator.dart';
import 'package:mocktail/mocktail.dart';

class MockEmailValidator extends Mock implements EmailValidator {
  void mockIsValid({required bool isValid}) {
    when(
      () => this.isValid(any()),
    ).thenReturn(isValid);
  }
}
