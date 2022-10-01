import 'package:app/domain/entities/day.dart';
import 'package:app/domain/interfaces/day_interface.dart';

class GetUserDaysUseCase {
  late final DayInterface _dayInterface;

  GetUserDaysUseCase({required DayInterface dayInterface}) {
    _dayInterface = dayInterface;
  }

  Stream<List<Day>> execute({required String userId}) {
    return _dayInterface.getUserDays(userId: userId);
  }
}
