import 'package:app/domain/interfaces/day_interface.dart';

class InitializeUserDataUseCase {
  late final DayInterface _dayInterface;

  InitializeUserDataUseCase({
    required DayInterface dayInterface,
  }) {
    _dayInterface = dayInterface;
  }

  Future<void> execute({required String userId}) async {
    await _dayInterface.initializeForUser(userId: userId);
  }
}
