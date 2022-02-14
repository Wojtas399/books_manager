import 'dart:async';
import 'package:app/core/services/avatar_service.dart';
import 'package:app/core/user/user_model.dart';
import 'package:app/interfaces/avatars/avatar_interface.dart';
import 'package:app/interfaces/user_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc {
  late final UserInterface _userInterface;

  StreamSubscription? _userSubscription;
  BehaviorSubject<LoggedUser?> _loggedUser =
      new BehaviorSubject<LoggedUser?>.seeded(null);

  UserBloc({required UserInterface userInterface}) {
    _userInterface = userInterface;
  }

  Stream<LoggedUser?> get loggedUser$ => _loggedUser.stream;

  subscribeUserData() {
    Stream<DocumentSnapshot>? snapshot = _userInterface.subscribeUserData();
    if (snapshot != null) {
      _userSubscription = snapshot.listen((event) async {
        Map<String, dynamic>? data = event.data() as Map<String, dynamic>?;
        String? email = _userInterface.getEmail();
        if (data != null && email != null) {
          String avatarUrl =
              await _userInterface.getAvatarUrl(avatarPath: data['avatarPath']);
          this.setUserData(
            username: data['userName'],
            email: email,
            avatar: AvatarService.getViewAvatar(
              data['avatarPath'].split('/')[1],
              avatarUrl,
            ),
          );
        }
      });
    }
  }

  setUserData({
    required String username,
    required String email,
    required AvatarInterface avatar,
  }) {
    LoggedUser loggedUser = new LoggedUser(
      username: username,
      email: email,
      avatar: avatar,
    );
    _loggedUser.add(loggedUser);
  }

  updateAvatar(AvatarInterface avatar) async {
    await _userInterface.changeAvatar(
      avatar: AvatarService.getBackendAvatar(avatar),
    );
  }

  updateUsername(String newUsername) async {
    await _userInterface.changeUsername(newUsername: newUsername);
  }

  updateEmail(String newEmail, String password) async {
    await _userInterface.changeEmail(newEmail: newEmail, password: password);
    _updateEmail(newEmail);
  }

  updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _userInterface.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  dispose() {
    _userSubscription?.cancel();
    _loggedUser.close();
  }

  _updateEmail(String newEmail) {
    LoggedUser? userData = _loggedUser.value;
    if (userData != null) {
      LoggedUser loggedUser = new LoggedUser(
        username: userData.username,
        email: newEmail,
        avatar: userData.avatar,
      );
      _loggedUser.add(loggedUser);
    }
  }
}
