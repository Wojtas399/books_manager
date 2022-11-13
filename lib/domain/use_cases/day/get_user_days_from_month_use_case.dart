import 'package:app/domain/entities/day.dart';
import 'package:app/domain/interfaces/day_interface.dart';

class GetUserDaysFromMonthUseCase {
  late final DayInterface _dayInterface;

  GetUserDaysFromMonthUseCase({required DayInterface dayInterface}) {
    _dayInterface = dayInterface;
  }

  Stream<List<Day>> execute({
    required String userId,
    required int month,
    required int year,
  }) {
    return _dayInterface.getUserDaysFromMonth(
      userId: userId,
      month: month,
      year: year,
    );
  }
}
