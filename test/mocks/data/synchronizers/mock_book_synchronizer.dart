import 'package:app/data/synchronizers/book_synchronizer.dart';
import 'package:mocktail/mocktail.dart';

class MockBookSynchronizer extends Mock implements BookSynchronizer {
  void mockSynchronizeUnmodifiedUserBooks() {
    when(
      () => synchronizeUnmodifiedUserBooks(userId: any(named: 'userId')),
    ).thenAnswer((_) async => '');
  }

  void mockSynchronizeUserBooksMarkedAsAdded() {
    when(
      () => synchronizeUserBooksMarkedAsAdded(userId: any(named: 'userId')),
    ).thenAnswer((_) async => '');
  }

  void mockSynchronizeUserBooksMarkedAsUpdated() {
    when(
      () => synchronizeUserBooksMarkedAsUpdated(userId: any(named: 'userId')),
    ).thenAnswer((_) async => '');
  }

  void mockSynchronizeUserBooksMarkedAsDeleted() {
    when(
      () => synchronizeUserBooksMarkedAsDeleted(userId: any(named: 'userId')),
    ).thenAnswer((_) async => '');
  }
}
