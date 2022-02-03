import 'package:app/core/day/day_bloc.dart';
import 'package:app/repositories/day_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDayInterface extends Mock implements DayInterface {}

void main() {
  DayInterface dayInterface = MockDayInterface();
  late DayBloc dayBloc;

  setUp(() => dayBloc = DayBloc(dayInterface: dayInterface));

  tearDown(() => reset(dayInterface));

  group('addPages', () {
    setUp(() async {
      await dayBloc.addPages(dayId: 'd1', bookId: 'b1', pagesToAdd: 30);
    });

    test('should call add pages method from day repo', () {
      verify(() => dayInterface.addPages(
            dayId: 'd1',
            bookId: 'b1',
            pagesToAdd: 30,
          )).called(1);
    });
  });

  group('deletePages', () {
    setUp(() async {
      await dayBloc.deletePages(bookId: 'b1', pagesToDelete: 30);
    });

    test('should call delete pages method from day repo', () {
      verify(() => dayInterface.deletePages(
            bookId: 'b1',
            pagesToDelete: 30,
          )).called(1);
    });
  });
}
