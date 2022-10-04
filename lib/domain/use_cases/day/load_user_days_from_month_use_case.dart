import 'package:app/domain/interfaces/day_interface.dart';

class LoadUserDaysFromMonthUseCase {
  late final DayInterface _dayInterface;

  LoadUserDaysFromMonthUseCase({required DayInterface dayInterface}) {
    _dayInterface = dayInterface;
  }

  Future<void> execute({
    required String userId,
    required int month,
    required int year,
  }) async {
    await _dayInterface.loadUserDaysFromMonth(
      userId: userId,
      month: month,
      year: year,
    );
  }
}
