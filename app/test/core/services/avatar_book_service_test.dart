import 'package:app/common/enum/avatar_type.dart';
import 'package:app/core/services/avatar_book_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AvatarBookService avatarBookService = AvatarBookService();
  group('getBookFileName', () {
    group('AvatarType.red', () {
      String expectedFileName = 'RedBook.png';
      test('Should return $expectedFileName', () {
        String fileName = avatarBookService.getBookFileName(AvatarType.red);
        expect(fileName, expectedFileName);
      });
    });

    group('AvatarType.green', () {
      String expectedFileName = 'GreenBook.png';
      test('Should return $expectedFileName', () {
        String fileName = avatarBookService.getBookFileName(AvatarType.green);
        expect(fileName, expectedFileName);
      });
    });

    group('AvatarType.blue', () {
      String expectedFileName = 'BlueBook.png';
      test('Should return $expectedFileName', () {
        String fileName = avatarBookService.getBookFileName(AvatarType.blue);
        expect(fileName, expectedFileName);
      });
    });

    group('AvatarType.custom', () {
      String expectedFileName = '';
      test('Should return empty string', () {
        String fileName = avatarBookService.getBookFileName(AvatarType.custom);
        expect(fileName, expectedFileName);
      });
    });
  });

  group('getBookType', () {
    group('RedBook.png', () {
      AvatarType expectedAvatarType = AvatarType.red;
      test('Should return AvatarType.red', () {
        AvatarType avatarType = avatarBookService.getBookType('RedBook.png');
        expect(avatarType, expectedAvatarType);
      });
    });

    group('GreenBook.png', () {
      AvatarType expectedAvatarType = AvatarType.green;
      test('Should return AvatarType.green', () {
        AvatarType avatarType = avatarBookService.getBookType('GreenBook.png');
        expect(avatarType, expectedAvatarType);
      });
    });

    group('BlueBook.png', () {
      AvatarType expectedAvatarType = AvatarType.green;
      test('Should return AvatarType.green', () {
        AvatarType avatarType = avatarBookService.getBookType('GreenBook.png');
        expect(avatarType, expectedAvatarType);
      });
    });

    group('Any other string', () {
      AvatarType expectedAvatarType = AvatarType.custom;
      test('Should return AvatarType.custom', () {
        AvatarType avatarType = avatarBookService.getBookType('');
        expect(avatarType, expectedAvatarType);
      });
    });
  });
}
