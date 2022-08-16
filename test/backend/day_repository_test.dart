import 'package:app/backend/services/day_service.dart';
import 'package:app/backend/repositories/day_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';

class MockDayService extends Mock implements DayService {}

void main() {
  DayService dayService = MockDayService();
  late DayRepository repository;

  setUp(() => repository = DayRepository(dayService: dayService));

  tearDown(() => reset(dayService));

  test('subscribe days', () {
    BehaviorSubject<QuerySnapshot> controller = BehaviorSubject();
    when(
      () => dayService.subscribeDays(),
    ).thenAnswer((_) => controller.stream);

    Stream<QuerySnapshot>? snapshot = repository.subscribeDays();

    expect(snapshot, controller.stream);
    controller.close();
  });

  test('add pages, success', () async {
    when(
      () => dayService.addPages(
        dayId: '05.10.2021',
        bookId: 'b1',
        pagesToAdd: 50,
      ),
    ).thenAnswer((_) async => 'success');

    await repository.addPages(
      dayId: '05.10.2021',
      bookId: 'b1',
      pagesToAdd: 50,
    );

    verify(
      () => dayService.addPages(
        dayId: '05.10.2021',
        bookId: 'b1',
        pagesToAdd: 50,
      ),
    ).called(1);
  });

  test('add pages, failure', () async {
    when(
      () => dayService.addPages(
        dayId: '05.10.2021',
        bookId: 'b1',
        pagesToAdd: 50,
      ),
    ).thenThrow('Error...');

    try {
      await repository.addPages(
        dayId: '05.10.2021',
        bookId: 'b1',
        pagesToAdd: 50,
      );
    } catch (error) {
      expect(error, 'Error...');
    }
  });

  test('delete pages, success', () async {
    when(() => dayService.deletePages(bookId: 'b1', pagesToDelete: 50))
        .thenAnswer((_) async => 'success');

    await repository.deletePages(bookId: 'b1', pagesToDelete: 50);

    verify(() => dayService.deletePages(bookId: 'b1', pagesToDelete: 50))
        .called(1);
  });

  test('delete pages, failure', () async {
    when(() => dayService.deletePages(bookId: 'b1', pagesToDelete: 50))
        .thenAnswer((_) async => 'success');

    await repository.deletePages(bookId: 'b1', pagesToDelete: 50);

    verify(() => dayService.deletePages(bookId: 'b1', pagesToDelete: 50))
        .called(1);
  });
}
