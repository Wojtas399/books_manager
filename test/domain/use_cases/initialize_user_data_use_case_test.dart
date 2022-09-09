import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/use_cases/initialize_user_data_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBookInterface extends Mock implements BookInterface {}

void main() {
  final bookInterface = MockBookInterface();
  final useCase = InitializeUserDataUseCase(bookInterface: bookInterface);

  test(
    'should call method responsible for refreshing user books',
    () async {
      const String userId = 'u1';
      when(
        () => bookInterface.refreshUserBooks(userId: userId),
      ).thenAnswer((_) async => '');

      await useCase.execute(userId: userId);

      verify(
        () => bookInterface.refreshUserBooks(userId: userId),
      ).called(1);
    },
  );
}
