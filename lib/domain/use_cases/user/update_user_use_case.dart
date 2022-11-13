import 'package:app/domain/interfaces/user_interface.dart';

class UpdateUserUseCase {
  late final UserInterface _userInterface;

  UpdateUserUseCase({required UserInterface userInterface}) {
    _userInterface = userInterface;
  }

  Future<void> execute({
    required String userId,
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
  }) async {
    await _userInterface.updateUser(
      userId: userId,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
    );
  }
}
