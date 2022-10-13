import 'package:app/domain/entities/day.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/utils/date_utils.dart';

class GetUserDaysFromMonthUseCase {
  late final DayInterface _dayInterface;

  GetUserDaysFromMonthUseCase({required DayInterface dayInterface}) {
    _dayInterface = dayInterface;
  }

  Stream<List<Day>?> execute({
    required String userId,
    required int month,
    required int year,
  }) {
    return _dayInterface.getUserDays(userId: userId).map(
          (List<Day>? userDays) => userDays
              ?.where(
                (Day day) => DateUtils.isDateFromMonthAndYear(
                  date: day.date,
                  month: month,
                  year: year,
                ),
              )
              .toList(),
        );
  }
}
