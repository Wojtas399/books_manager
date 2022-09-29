import 'package:app/domain/interfaces/day_interface.dart';

class LoadUserDaysUseCase {
  late final DayInterface _dayInterface;

  LoadUserDaysUseCase({required DayInterface dayInterface}) {
    _dayInterface = dayInterface;
  }

  Future<void> execute({required String userId}) async {
    await _dayInterface.loadUserDays(userId: userId);
  }
}
