import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/services/avatar_book_service.dart';
import 'package:app/core/services/image_service.dart';
import 'package:app/core/user/user_bloc.dart';
import 'package:app/modules/profile/elements/avatar/avatar_controller.dart';
import 'package:app/modules/profile/profile_screen_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'profile_mocks.dart';

class MockAvatarBookService extends Mock implements AvatarBookService {}

class MockImageService extends Mock implements ImageService {}

void main() {
  UserBloc userBloc = MockUserBloc();
  AvatarBookService avatarBookService = MockAvatarBookService();
  ImageService imageService = MockImageService();
  ProfileScreenDialogs dialogs = MockProfileScreenDialogs();
  late AvatarController controller;

  setUp(() {
    controller = AvatarController(
      userBloc: userBloc,
      avatarBookService: avatarBookService,
      imageService: imageService,
      profileScreenDialogs: dialogs,
    );
  });

  tearDown(() {
    reset(userBloc);
    reset(avatarBookService);
    reset(imageService);
    reset(dialogs);
  });

  group('avatar info', () {
    setUp(() {
      when(() => userBloc.avatarInfo$).thenAnswer(
        (_) => new BehaviorSubject<AvatarInfo>.seeded(AvatarInfo(
          avatarUrl: 'avatarUrl',
          avatarType: AvatarType.custom,
        )).stream,
      );
    });

    test('should contain avatar info', () async {
      AvatarInfo? avatarInfo = await controller.avatarInfo$.first;
      expect(avatarInfo?.avatarUrl, 'avatarUrl');
      expect(avatarInfo?.avatarType, AvatarType.custom);
    });
  });

  group('open avatar action sheet', () {
    group('from gallery', () {
      setUp(() {
        when(() => dialogs.askForAvatarOperation())
            .thenAnswer((_) async => AvatarActionSheetResult.fromGallery);
      });

      group('new image selected', () {
        setUp(() {
          when(() => imageService.getImageFromGallery())
              .thenAnswer((_) async => 'new/image/path');
        });

        group('confirmed', () {
          setUp(() async {
            when(
              () => dialogs.askForNewAvatarConfirmation(AvatarInfo(
                avatarUrl: 'new/image/path',
                avatarType: AvatarType.custom,
              )),
            ).thenAnswer((_) async => true);
            await controller.openAvatarActionSheet();
          });

          test('should call update avatar method with the avatar url', () {
            verify(() => userBloc.updateAvatar('new/image/path')).called(1);
          });
        });

        group('cancelled', () {
          setUp(() async {
            when(
              () => dialogs.askForNewAvatarConfirmation(AvatarInfo(
                avatarUrl: 'new/image/path',
                avatarType: AvatarType.custom,
              )),
            ).thenAnswer((_) async => false);
            await controller.openAvatarActionSheet();
          });

          test('should not call update avatar method', () {
            verifyNever(() => userBloc.updateAvatar('new/image/path'));
          });
        });
      });

      group('new image not selected', () {
        setUp(() async {
          when(() => imageService.getImageFromGallery())
              .thenAnswer((_) async => null);
          await controller.openAvatarActionSheet();
        });

        test('should not ask for confirmation', () {
          verifyNever(() => dialogs.askForNewAvatarConfirmation(AvatarInfo(
                avatarUrl: 'avatarUrl',
                avatarType: AvatarType.custom,
              )));
        });

        test('should not call update avatar method', () {
          verifyNever(() => userBloc.updateAvatar('avatarUrl'));
        });
      });
    });

    group('basic avatar', () {
      setUp(() {
        when(() => dialogs.askForAvatarOperation())
            .thenAnswer((_) async => AvatarActionSheetResult.basicAvatar);
      });

      group('new basic avatar selected', () {
        AvatarInfo avatarInfo = AvatarInfo(
          avatarUrl: '',
          avatarType: AvatarType.blue,
        );
        setUp(() {
          when(() => dialogs.askForBasicAvatar())
              .thenAnswer((_) async => AvatarType.blue);
        });

        group('confirmed', () {
          setUp(() async {
            when(() => dialogs.askForNewAvatarConfirmation(avatarInfo))
                .thenAnswer((_) async => true);
            when(() => avatarBookService.getBookFileName(AvatarType.blue))
                .thenReturn('Blue.png');
            await controller.openAvatarActionSheet();
          });

          test('should call update avatar method with the book file name', () {
            verify(() => userBloc.updateAvatar('Blue.png')).called(1);
          });
        });

        group('canceled', () {
          setUp(() async {
            when(() => dialogs.askForNewAvatarConfirmation(avatarInfo))
                .thenAnswer((_) async => false);
            await controller.openAvatarActionSheet();
          });

          test('should not call update avatar method', () {
            verifyNever(() => userBloc.updateAvatar('Blue.png'));
          });
        });
      });

      group('new basic avatar not selected', () {
        setUp(() async {
          when(() => dialogs.askForBasicAvatar()).thenAnswer((_) async => null);
          await controller.openAvatarActionSheet();
        });

        test('should not ask for confirmation', () {
          verifyNever(() => dialogs.askForNewAvatarConfirmation(AvatarInfo(
                avatarUrl: '',
                avatarType: AvatarType.blue,
              )));
        });

        test('should not call update method', () {
          verifyNever(() => userBloc.updateAvatar('Blue.png'));
        });
      });
    });
  });
}
