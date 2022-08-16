import 'package:app/core/services/date_service.dart';
import 'package:rxdart/rxdart.dart';

class CalendarScreenController {
  BehaviorSubject<String> _selectedDayId =
      new BehaviorSubject<String>.seeded(DateService.getCurrentDate());

  Stream<String> get selectedDayId$ => _selectedDayId.stream;

  void onTapDay(String dayId) {
    _selectedDayId.add(dayId);
  }
}
