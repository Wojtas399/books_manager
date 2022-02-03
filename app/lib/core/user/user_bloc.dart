import 'dart:async';
import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/services/avatar_book_service.dart';
import 'package:app/core/user/user_model.dart';
import 'package:app/repositories/user/user_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

class AvatarInfo extends Equatable {
  final String avatarUrl;
  final AvatarType avatarType;

  AvatarInfo({required this.avatarUrl, required this.avatarType});

  @override
  List<Object> get props => [avatarUrl, avatarType];
}

class UserBloc {
  UserInterface _userInterface;
  AvatarBookService avatarBookService = AvatarBookService();

  StreamSubscription? _userSubscription;
  BehaviorSubject<LoggedUser?> _loggedUser =
      new BehaviorSubject<LoggedUser?>.seeded(null);

  UserBloc({required UserInterface userInterface})
      : _userInterface = userInterface;

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
            avatarUrl: avatarUrl,
            avatarType: avatarBookService.getBookType(
              data['avatarPath'].split('/')[1],
            ),
          );
        }
      });
    }
  }

  setUserData({
    required String username,
    required String email,
    required String avatarUrl,
    required AvatarType avatarType,
  }) {
    LoggedUser loggedUser = new LoggedUser(
      username: username,
      email: email,
      avatarType: avatarType,
      avatarUrl: avatarUrl,
    );
    _loggedUser.add(loggedUser);
  }

  updateAvatar(String avatar) async {
    await _userInterface.changeAvatar(avatar: avatar);
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
        avatarType: userData.avatarType,
        avatarUrl: userData.avatarUrl,
      );
      _loggedUser.add(loggedUser);
    }
  }
}
