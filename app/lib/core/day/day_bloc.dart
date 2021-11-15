import 'package:app/repositories/day_repository/day_interface.dart';
import 'package:rxdart/rxdart.dart';
import 'day_model.dart';
import 'day_subscriber.dart';

class DayBloc {
  late DayInterface _dayInterface;
  late DaySubscriber _daySubscriber;
  BehaviorSubject<List<Day>> _days = new BehaviorSubject<List<Day>>.seeded([]);

  DayBloc({required DayInterface dayInterface}) {
    _dayInterface = dayInterface;
    _daySubscriber = DaySubscriber(
      days: _days,
      dayInterface: _dayInterface,
    );
  }

  Stream<List<Day>> get allDays$ => _days.stream;

  subscribe() {
    _daySubscriber.subscribeDays();
  }

  dispose() {
    print('Called DISPOSE DAY BLOC');
    _days.close();
    _daySubscriber.dispose();
  }

  addPages({
    required String dayId,
    required String bookId,
    required int pagesToAdd,
  }) async {
    await _dayInterface.addPages(
      dayId: dayId,
      bookId: bookId,
      pagesToAdd: pagesToAdd,
    );
  }

  deletePages({required String bookId, required int pagesToDelete}) async {
    await _dayInterface.deletePages(
      bookId: bookId,
      pagesToDelete: pagesToDelete,
    );
  }
}
