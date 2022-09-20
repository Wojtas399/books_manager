import 'package:app/domain/interfaces/user_interface.dart';

class LoadUserUseCase {
  late final UserInterface _userInterface;

  LoadUserUseCase({required UserInterface userInterface}) {
    _userInterface = userInterface;
  }

  Future<void> execute({required String userId}) async {
    await _userInterface.loadUser(userId: userId);
  }
}
