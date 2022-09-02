import 'package:app/data/mappers/book_status_mapper.dart';
import 'package:app/data/models/db_book.dart';
import 'package:app/domain/entities/book.dart';

class BookMapper {
  static DbBook mapFromEntityToDbModel(Book book) {
    return DbBook(
      id: book.id,
      imageData: book.imageData,
      userId: book.userId,
      status: BookStatusMapper.mapFromEnumToString(book.status),
      title: book.title,
      author: book.author,
      readPagesAmount: book.readPagesAmount,
      allPagesAmount: book.allPagesAmount,
    );
  }

  static Book mapFromDbModelToEntity(DbBook dbBook) {
    return Book(
      id: dbBook.id,
      userId: dbBook.userId,
      status: BookStatusMapper.mapFromStringToEnum(dbBook.status),
      imageData: dbBook.imageData,
      title: dbBook.title,
      author: dbBook.author,
      readPagesAmount: dbBook.readPagesAmount,
      allPagesAmount: dbBook.allPagesAmount,
    );
  }
}
