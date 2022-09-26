import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:equatable/equatable.dart';

class SqliteReadBook extends Equatable {
  final String userId;
  final String date;
  final String bookId;
  final int readPagesAmount;
  final SyncState syncState;

  const SqliteReadBook({
    required this.userId,
    required this.date,
    required this.bookId,
    required this.readPagesAmount,
    required this.syncState,
  });

  SqliteReadBook.fromJson(Map<String, Object?> json)
      : this(
          userId: json[SqliteReadBookFields.userId] as String,
          date: json[SqliteReadBookFields.date] as String,
          bookId: json[SqliteReadBookFields.bookId] as String,
          readPagesAmount: json[SqliteReadBookFields.readPagesAmount] as int,
          syncState:
              (json[SqliteReadBookFields.syncState] as String).toSyncState(),
        );

  @override
  List<Object> get props => [
        userId,
        date,
        bookId,
        readPagesAmount,
      ];

  Map<String, Object?> toJson() => {
        SqliteReadBookFields.userId: userId,
        SqliteReadBookFields.date: date,
        SqliteReadBookFields.bookId: bookId,
        SqliteReadBookFields.readPagesAmount: readPagesAmount,
        SqliteReadBookFields.syncState: syncState.name,
      };

  SqliteReadBook copyWith({
    int? readPagesAmount,
    SyncState? syncState,
  }) {
    return SqliteReadBook(
      userId: userId,
      date: date,
      bookId: bookId,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
      syncState: syncState ?? this.syncState,
    );
  }
}

class SqliteReadBookFields {
  static const String userId = 'userId';
  static const String date = 'date';
  static const String bookId = 'bookId';
  static const String readPagesAmount = 'readPagesAmount';
  static const String syncState = 'syncState';
}

SqliteReadBook createSqliteReadBook({
  String userId = '',
  String date = '',
  String bookId = '',
  int readPagesAmount = 0,
  SyncState syncState = SyncState.none,
}) {
  return SqliteReadBook(
    userId: userId,
    date: date,
    bookId: bookId,
    readPagesAmount: readPagesAmount,
    syncState: syncState,
  );
}
