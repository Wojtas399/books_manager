import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/services/avatar_book_service.dart';
import 'package:app/core/services/image_service.dart';
import 'package:app/core/user/user_bloc.dart';
import 'package:app/modules/profile/bloc/profile_actions.dart';
import 'package:app/modules/profile/bloc/profile_bloc.dart';
import 'package:app/modules/profile/elements/avatar/avatar_controller.dart';
import 'package:app/modules/profile/profile_screen_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileBloc extends Mock implements ProfileBloc {}

class MockAvatarBookService extends Mock implements AvatarBookService {}

class MockImageService extends Mock implements ImageService {}

class MockProfileScreenDialogs extends Mock implements ProfileScreenDialogs {}

void main() {
  ProfileBloc profileBloc = MockProfileBloc();
  AvatarBookService avatarBookService = MockAvatarBookService();
  ImageService imageService = MockImageService();
  ProfileScreenDialogs dialogs = MockProfileScreenDialogs();
  late AvatarController controller;

  setUp(() {
    controller = AvatarController(
      profileBloc: profileBloc,
      avatarBookService: avatarBookService,
      imageService: imageService,
      profileScreenDialogs: dialogs,
    );
  });

  tearDown(() {
    reset(profileBloc);
    reset(avatarBookService);
    reset(imageService);
    reset(dialogs);
  });

  group('open avatar action sheet, from gallery', () {
    AvatarInfo avatarInfo = new AvatarInfo(
      avatarUrl: 'imgPath',
      avatarType: AvatarType.custom,
    );

    setUp(() {
      when(() => dialogs.askForAvatarOperation())
          .thenAnswer((_) async => AvatarActionSheetResult.fromGallery);
      when(() => imageService.getImageFromGallery())
          .thenAnswer((_) async => 'imgPath');
    });

    test('confirmed', () async {
      when(() => dialogs.askForNewAvatarConfirmation(avatarInfo))
          .thenAnswer((_) async => true);

      await controller.openAvatarActionSheet();

      verify(
        () => profileBloc.add(ProfileActionsChangeAvatar(avatar: 'imgPath')),
      ).called(1);
    });

    test('canceled', () async {
      when(() => dialogs.askForNewAvatarConfirmation(avatarInfo))
          .thenAnswer((_) async => false);

      await controller.openAvatarActionSheet();

      verifyNever(
          () => profileBloc.add(ProfileActionsChangeAvatar(avatar: 'imgPath')));
    });
  });

  group('open avatar action sheet, basic avatar', () {
    AvatarType selectedAvatar = AvatarType.green;
    AvatarInfo avatarInfo = AvatarInfo(
      avatarUrl: '',
      avatarType: selectedAvatar,
    );

    setUp(() {
      when(() => dialogs.askForAvatarOperation())
          .thenAnswer((_) async => AvatarActionSheetResult.basicAvatar);
      when(() => dialogs.askForBasicAvatar())
          .thenAnswer((_) async => selectedAvatar);
      when(() => avatarBookService.getBookFileName(selectedAvatar))
          .thenReturn('fileName');
    });

    test('confirmed', () async {
      when(() => dialogs.askForNewAvatarConfirmation(avatarInfo))
          .thenAnswer((_) async => true);

      await controller.openAvatarActionSheet();

      verify(
        () => profileBloc.add(ProfileActionsChangeAvatar(avatar: 'fileName')),
      ).called(1);
    });

    test('canceled', () async {
      when(() => dialogs.askForNewAvatarConfirmation(avatarInfo))
          .thenAnswer((_) async => false);

      await controller.openAvatarActionSheet();

      verifyNever(() =>
          profileBloc.add(ProfileActionsChangeAvatar(avatar: 'fileName')));
    });
  });
}
