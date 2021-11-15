import 'package:app/core/user/user_bloc.dart';
import 'package:app/modules/profile/elements/user_info/user_info_controller.dart';
import 'package:app/modules/profile/profile_screen_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'profile_mocks.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  UserBloc userBloc = MockUserBloc();
  ProfileScreenDialogs dialogs = MockProfileScreenDialogs();
  late UserInfoController controller;

  setUp(() {
    controller = UserInfoController(
      userBloc: userBloc,
      profileScreenDialogs: dialogs,
    );
  });

  tearDown(() {
    reset(userBloc);
    reset(dialogs);
  });

  group('username', () {
    setUp(() {
      when(() => userBloc.username$).thenAnswer(
          (_) => new BehaviorSubject<String>.seeded('username').stream);
    });

    test('should be the username of the user', () async {
      String? username = await controller.username$.first;
      expect(username, 'username');
    });
  });

  group('email', () {
    setUp(() {
      when(() => userBloc.email$).thenAnswer(
          (_) => new BehaviorSubject<String>.seeded('jan@example.com').stream);
    });

    test('should be the email of the user', () async {
      String? email = await controller.email$.first;
      expect(email, 'jan@example.com');
    });
  });

  group('on click username', () {
    setUp(() {
      when(() => userBloc.username$)
          .thenAnswer((_) => new BehaviorSubject<String>.seeded('username'));
    });

    group('changed', () {
      setUp(() async {
        when(() => dialogs.askForNewUsername('username'))
            .thenAnswer((_) async => 'new username');
        await controller.onClickUsername();
      });

      test('should call update username method with new username', () {
        verify(() => userBloc.updateUsername('new username')).called(1);
      });
    });

    group('not changed', () {
      setUp(() async {
        when(() => dialogs.askForNewUsername('username'))
            .thenAnswer((_) async => null);
        await controller.onClickUsername();
      });

      test('should not call update username method', () {
        verifyNever(() => userBloc.updateUsername('new username'));
      });
    });
  });

  group('on click email dialog', () {
    setUp(() async {
      await controller.onClickEmail('jan@example.com');
    });

    test('should call open email dialog method', () {
      verify(() => dialogs.openEmailDialog(userBloc, 'jan@example.com'))
          .called(1);
    });
  });

  group('on click password', () {
    setUp(() async {
      await controller.onClickPassword();
    });

    test('should call open password method', () {
      verify(() => dialogs.openPasswordDialog(userBloc)).called(1);
    });
  });
}
