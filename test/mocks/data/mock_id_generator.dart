import 'package:app/data/id_generator.dart';
import 'package:mocktail/mocktail.dart';

class MockIdGenerator extends Mock implements IdGenerator {
  void mockGenerateRandomId({required String id}) {
    when(() => generateRandomId()).thenReturn(id);
  }
}
