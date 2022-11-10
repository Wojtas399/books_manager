import 'dart:typed_data';

import 'package:app/data/data_sources/firebase/services/firebase_storage_image_service.dart';
import 'package:app/models/image.dart';
import 'package:mocktail/mocktail.dart';

class FakeImage extends Fake implements Image {}

class MockFirebaseStorageImageService extends Mock
    implements FirebaseStorageImageService {
  void mockSaveImage() {
    _mockImage();
    when(
      () => saveImage(
        image: any(named: 'image'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockLoadImage({Uint8List? imageData}) {
    when(
      () => loadImage(
        fileName: any(named: 'fileName'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => imageData);
  }

  void mockDeleteImage() {
    when(
      () => deleteImage(
        fileName: any(named: 'fileName'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockImage() {
    registerFallbackValue(FakeImage());
  }
}
