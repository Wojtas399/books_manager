import '../../entities/db_book.dart';
import '../fire_references.dart';

class FirebaseBookService {
  Future<void> addNewBook(DbBook databaseBook) async {
    await FireReferences.getBooksRefWithConverter(userId: databaseBook.userId)
        .doc('${databaseBook.id}')
        .set(databaseBook);
  }
}
