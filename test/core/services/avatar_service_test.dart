import 'package:app/core/services/avatar_service.dart';
import 'package:app/interfaces/avatar_interface.dart';
import 'package:app/models/avatar_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('get avatar model, red', () {
    AvatarInterface avatar = AvatarService.getAvatarModel('RedBook.png', '');

    expect(avatar, StandardAvatarRed());
  });

  test('get avatar model, green', () {
    AvatarInterface avatar = AvatarService.getAvatarModel('GreenBook.png', '');

    expect(avatar, StandardAvatarGreen());
  });

  test('get avatar model, blue', () {
    AvatarInterface avatar = AvatarService.getAvatarModel('BlueBook.png', '');

    expect(avatar, StandardAvatarBlue());
  });

  test('get avatar model, custom', () {
    AvatarInterface avatar = AvatarService.getAvatarModel('', 'url/path');

    expect(avatar, CustomAvatar(avatarImgUrl: 'url/path'));
  });
}
