import 'package:app/core/services/image_service.dart';
import 'package:app/interfaces/avatar_interface.dart';
import 'package:app/models/avatar_model.dart';
import 'package:app/modules/profile/bloc/profile_actions.dart';
import 'package:app/modules/profile/bloc/profile_bloc.dart';
import 'package:app/modules/profile/elements/avatar/avatar_controller.dart';
import 'package:app/modules/profile/profile_screen_dialogs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileBloc extends Mock implements ProfileBloc {}

class MockImageService extends Mock implements ImageService {}

class MockProfileScreenDialogs extends Mock implements ProfileScreenDialogs {}

void main() {
  ProfileBloc profileBloc = MockProfileBloc();
  ImageService imageService = MockImageService();
  ProfileScreenDialogs dialogs = MockProfileScreenDialogs();
  late AvatarController controller;

  setUp(() {
    controller = AvatarController(
      profileBloc: profileBloc,
      imageService: imageService,
      profileScreenDialogs: dialogs,
    );
  });

  tearDown(() {
    reset(profileBloc);
    reset(imageService);
    reset(dialogs);
  });

  group('select avatar choice option, from gallery', () {
    CustomAvatarInterface avatar = new CustomAvatar(
      imgFilePathFromDevice: 'imgPath',
    );

    setUp(() {
      when(() => dialogs.askForAvatarChoiceOption())
          .thenAnswer((_) async => AvatarChoiceOptions.fromGallery);
      when(() => imageService.getImageFromGallery())
          .thenAnswer((_) async => 'imgPath');
    });

    test('confirmed', () async {
      when(() => dialogs.askForNewAvatarConfirmation(avatar))
          .thenAnswer((_) async => true);

      await controller.selectAvatarChoiceOption();

      verify(
        () => profileBloc.add(ProfileActionsChangeAvatar(avatar: avatar)),
      ).called(1);
    });

    test('canceled', () async {
      when(() => dialogs.askForNewAvatarConfirmation(avatar))
          .thenAnswer((_) async => false);

      await controller.selectAvatarChoiceOption();

      verifyNever(
          () => profileBloc.add(ProfileActionsChangeAvatar(avatar: avatar)));
    });
  });

  group('select avatar choice option, basic avatar', () {
    StandardAvatarInterface avatar = StandardAvatarRed();

    setUp(() {
      when(() => dialogs.askForAvatarChoiceOption())
          .thenAnswer((_) async => AvatarChoiceOptions.basicAvatar);
      when(() => dialogs.askForStandardAvatar())
          .thenAnswer((_) async => avatar);
    });

    test('confirmed', () async {
      when(() => dialogs.askForNewAvatarConfirmation(avatar))
          .thenAnswer((_) async => true);

      await controller.selectAvatarChoiceOption();

      verify(
        () => profileBloc.add(ProfileActionsChangeAvatar(avatar: avatar)),
      ).called(1);
    });

    test('canceled', () async {
      when(() => dialogs.askForNewAvatarConfirmation(avatar))
          .thenAnswer((_) async => false);

      await controller.selectAvatarChoiceOption();

      verifyNever(
        () => profileBloc.add(ProfileActionsChangeAvatar(avatar: avatar)),
      );
    });
  });
}
