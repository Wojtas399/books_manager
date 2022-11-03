import 'dart:typed_data';

import 'package:app/data/data_sources/shared_preferences/shared_preferences_image_service.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferencesImageService extends Mock
    implements SharedPreferencesImageService {
  void mockSaveImage() {
    when(
      () => saveImage(
        imageFileName: any(named: 'imageFileName'),
        imageData: any(named: 'imageData'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockLoadImage({Uint8List? imageData}) {
    when(
      () => loadImage(
        imageFileName: any(named: 'imageFileName'),
      ),
    ).thenAnswer((_) async => imageData);
  }

  void mockDeleteImage() {
    when(
      () => deleteImage(
        imageFileName: any(named: 'imageFileName'),
      ),
    ).thenAnswer((_) async => '');
  }
}
