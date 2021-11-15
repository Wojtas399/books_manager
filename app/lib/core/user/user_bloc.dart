import 'dart:async';
import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/services/avatar_book_service.dart';
import 'package:app/core/user/user_model.dart';
import 'package:app/repositories/auth/auth_interface.dart';
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
  AuthInterface _authInterface;
  LoggedUser? loggedUser;
  AvatarBookService avatarBookService = AvatarBookService();

  StreamSubscription? _userSubscription;
  BehaviorSubject<LoggedUser?> _loggedUser =
      new BehaviorSubject<LoggedUser?>.seeded(null);

  UserBloc({required AuthInterface authInterface})
      : _authInterface = authInterface;

  Stream<LoggedUser?> get loggedUser$ => _loggedUser.stream;

  Stream<String?> get username$ => loggedUser$.map((event) => event?.username);

  Stream<String?> get email$ => loggedUser$.map((event) => event?.email);

  Stream<AvatarInfo?> get avatarInfo$ => loggedUser$.map(
        (event) {
          LoggedUser? user = event;
          if (user != null) {
            return new AvatarInfo(
              avatarUrl: user.avatarUrl,
              avatarType: user.avatarType,
            );
          }
          return null;
        },
      );

  void subscribeUserData() {
    Stream<DocumentSnapshot>? snapshot = _authInterface.subscribeUserData();
    if (snapshot != null) {
      _userSubscription = snapshot.listen((event) async {
        Map<String, dynamic>? data = event.data() as Map<String, dynamic>?;
        String? email = _authInterface.getEmail();
        if (data != null && email != null) {
          String avatarUrl =
              await _authInterface.getAvatarUrl(avatarPath: data['avatarPath']);
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

  void setUserData({
    required String username,
    required String email,
    required String avatarUrl,
    required AvatarType avatarType,
  }) {
    loggedUser = new LoggedUser(
      username: username,
      email: email,
      avatarType: avatarType,
      avatarUrl: avatarUrl,
    );
    _loggedUser.add(loggedUser);
  }

  updateAvatar(String avatar) async {
    await _authInterface.changeAvatar(avatar: avatar);
  }

  updateUsername(String newUsername) async {
    await _authInterface.changeUsername(newUsername: newUsername);
  }

  updateEmail(String newEmail, String password) async {
    await _authInterface.changeEmail(newEmail: newEmail, password: password);
    _updateEmail(newEmail);
  }

  updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    await _authInterface.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  signOut() async {
    _dispose();
    await _authInterface.logOut();
  }

  void _updateEmail(String newEmail) {
    LoggedUser? userData = loggedUser;
    if (userData != null) {
      loggedUser = new LoggedUser(
        username: userData.username,
        email: newEmail,
        avatarType: userData.avatarType,
        avatarUrl: userData.avatarUrl,
      );
      _loggedUser.add(loggedUser);
    }
  }

  void _dispose() {
    _userSubscription?.cancel();
    _loggedUser.close();
  }
}
