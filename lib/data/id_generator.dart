import 'package:uuid/uuid.dart';

class IdGenerator {
  final Uuid _uuid = const Uuid();

  String generateRandomId() {
    return _uuid.v4();
  }
}
