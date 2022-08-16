import 'package:app/core/day/day_bloc.dart';
import 'package:app/interfaces/day_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDayInterface extends Mock implements DayInterface {}

void main() {
  DayInterface dayInterface = MockDayInterface();
  late DayBloc dayBloc;

  setUp(() => dayBloc = DayBloc(dayInterface: dayInterface));

  tearDown(() => reset(dayInterface));

  test('add pages', () async {
    await dayBloc.addPages(dayId: 'd1', bookId: 'b1', pagesToAdd: 30);

    verify(
      () => dayInterface.addPages(dayId: 'd1', bookId: 'b1', pagesToAdd: 30),
    ).called(1);
  });

  test('delete pages', () async {
    await dayBloc.deletePages(bookId: 'b1', pagesToDelete: 30);

    verify(
      () => dayInterface.deletePages(
        bookId: 'b1',
        pagesToDelete: 30,
      ),
    ).called(1);
  });
}
