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

  group('subscribe days', () {
    BehaviorSubject<QuerySnapshot> controller = BehaviorSubject();
    setUp(() {
      when(() => dayService.subscribeDays())
          .thenAnswer((_) => controller.stream);
    });
    tearDown(() => controller.close());

    test('Should return snapshot', () {
      Stream<QuerySnapshot>? snapshot = repository.subscribeDays();
      expect(snapshot, controller.stream);
    });
  });

  group('add pages', () {
    group('success', () {
      setUp(() async {
        when(() => dayService.addPages(
              dayId: '05.10.2021',
              bookId: 'b1',
              pagesToAdd: 50,
            )).thenAnswer((_) async => 'success');
        await repository.addPages(
          dayId: '05.10.2021',
          bookId: 'b1',
          pagesToAdd: 50,
        );
      });

      test('should call add pages method', () {
        verify(() => dayService.addPages(
              dayId: '05.10.2021',
              bookId: 'b1',
              pagesToAdd: 50,
            )).called(1);
      });
    });

    group('failure', () {
      setUp(() {
        when(() => dayService.addPages(
              dayId: '05.10.2021',
              bookId: 'b1',
              pagesToAdd: 50,
            )).thenThrow('Error...');
      });

      test('should throw error', () async {
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
    });
  });

  group('delete pages', () {
    group('success', () {
      setUp(() async {
        when(() => dayService.deletePages(
              bookId: 'b1',
              pagesToDelete: 50,
            )).thenAnswer((_) async => 'success');
        await repository.deletePages(bookId: 'b1', pagesToDelete: 50);
      });

      test('should call delete pages method', () {
        verify(() => dayService.deletePages(
              bookId: 'b1',
              pagesToDelete: 50,
            )).called(1);
      });
    });

    group('failure', () {
      setUp(() {
        when(() => dayService.deletePages(
              bookId: 'b1',
              pagesToDelete: 50,
            )).thenThrow('Error...');
      });

      test('should throw error', () async {
        try {
          await repository.deletePages(bookId: 'b1', pagesToDelete: 50);
        } catch (error) {
          expect(error, 'Error...');
        }
      });
    });
  });
}
