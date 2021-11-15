import 'day_model.dart';

class DayQuery {
  Stream<List<Day>> _allDays;

  DayQuery({required Stream<List<Day>> allDays}) : _allDays = allDays;

  Stream<List<String>> selectBooksIds(String dayId) {
    return _allDays.map((allDays) {
      int idx = allDays.indexWhere((day) => day.id == dayId);
      return allDays[idx].booksReadPages.keys.toList();
    });
  }

  Stream<int?> selectReadPages(String dayId, String bookId) {
    return _allDays.map((allDays) {
      int idx = allDays.indexWhere((day) => day.id == dayId);
      return allDays[idx].booksReadPages[bookId];
    });
  }

  Stream<int> selectTheAmountOfReadPagesFromTheDay(String dayId) {
    return _allDays.map((allDays) {
      int idx = allDays.indexWhere((day) => day.id == dayId);
      return idx == -1
          ? 0
          : allDays[idx]
              .booksReadPages
              .values
              .reduce((value, element) => value + element);
    });
  }

  Stream<List<String>> selectBooksIdsFromTheDay(String dayId) {
    return _allDays.map((allDays) {
      int idx = allDays.indexWhere((day) => day.id == dayId);
      return idx == -1 ? [] : allDays[idx].booksReadPages.keys.toList();
    });
  }
}
