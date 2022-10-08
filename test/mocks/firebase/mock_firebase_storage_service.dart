import 'dart:typed_data';

import 'package:app/data/data_sources/remote_db/firebase/services/firebase_storage_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseStorageService extends Mock
    implements FirebaseStorageService {
  void mockSaveBookImageData() {
    _mockUint8List();
    when(
      () => saveBookImageData(
        imageData: any(named: 'imageData'),
        userId: any(named: 'userId'),
        bookId: any(named: 'bookId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void mockLoadBookImageData({Uint8List? imageData}) {
    when(
      () => loadBookImageData(
        userId: any(named: 'userId'),
        bookId: any(named: 'bookId'),
      ),
    ).thenAnswer((_) async => imageData);
  }

  void mockDeleteBookImageData() {
    when(
      () => deleteBookImageData(
        userId: any(named: 'userId'),
        bookId: any(named: 'bookId'),
      ),
    ).thenAnswer((_) async => '');
  }

  void _mockUint8List() {
    registerFallbackValue(Uint8List(1));
  }
}
