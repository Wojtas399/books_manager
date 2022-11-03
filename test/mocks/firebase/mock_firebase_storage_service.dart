import 'dart:typed_data';

import 'package:app/data/data_sources/firebase/services/firebase_storage_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseStorageService extends Mock
    implements FirebaseStorageService {
  void mockSaveBookImageData() {
    _mockUint8List();
    when(
      () => saveBookImageData(
        imageData: any(named: 'imageData'),
        fileName: any(named: 'fileName'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockLoadBookImageData({Uint8List? imageData}) {
    when(
      () => loadBookImageData(
        fileName: any(named: 'fileName'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => imageData);
  }

  void mockDeleteBookImageData() {
    when(
      () => deleteBookImageData(
        fileName: any(named: 'fileName'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockUint8List() {
    registerFallbackValue(Uint8List(1));
  }
}
