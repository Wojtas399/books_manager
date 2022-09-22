import 'package:app/domain/entities/user.dart';
import 'package:app/domain/interfaces/user_interface.dart';
import 'package:rxdart/rxdart.dart';

class GetUserUseCase {
  late final UserInterface _userInterface;

  GetUserUseCase({required UserInterface userInterface}) {
    _userInterface = userInterface;
  }

  Stream<User> execute({required String userId}) {
    return _userInterface.getUser(userId: userId).whereType<User>();
  }
}
