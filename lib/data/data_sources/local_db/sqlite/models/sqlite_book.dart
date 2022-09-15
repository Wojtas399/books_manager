import 'package:app/data/data_sources/local_db/sqlite/sqlite_sync_state.dart';
import 'package:equatable/equatable.dart';

class SqliteBook extends Equatable {
  final String id;
  final String userId;
  final String status;
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;
  final SyncState syncState;

  const SqliteBook({
    required this.id,
    required this.userId,
    required this.status,
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
    required this.syncState,
  });

  SqliteBook.fromJson(Map<String, Object?> json)
      : this(
          id: json[SqliteBookFields.id] as String,
          userId: json[SqliteBookFields.userId] as String,
          status: json[SqliteBookFields.status] as String,
          title: json[SqliteBookFields.title] as String,
          author: json[SqliteBookFields.author] as String,
          readPagesAmount: json[SqliteBookFields.readPagesAmount] as int,
          allPagesAmount: json[SqliteBookFields.allPagesAmount] as int,
          syncState: (json[SqliteBookFields.syncState] as String).toSyncState(),
        );

  @override
  List<Object> get props => [
        id,
        userId,
        status,
        title,
        author,
        readPagesAmount,
        allPagesAmount,
        syncState,
      ];

  Map<String, Object?> toJson() => {
        SqliteBookFields.id: id,
        SqliteBookFields.userId: userId,
        SqliteBookFields.status: status,
        SqliteBookFields.title: title,
        SqliteBookFields.author: author,
        SqliteBookFields.readPagesAmount: readPagesAmount,
        SqliteBookFields.allPagesAmount: allPagesAmount,
        SqliteBookFields.syncState: syncState.name,
      };

  SqliteBook copyWith({
    String? status,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
    SyncState? syncState,
  }) {
    return SqliteBook(
      id: id,
      userId: userId,
      status: status ?? this.status,
      title: title ?? this.title,
      author: author ?? this.author,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
      allPagesAmount: allPagesAmount ?? this.allPagesAmount,
      syncState: syncState ?? this.syncState,
    );
  }
}

class SqliteBookFields {
  static const String id = 'id';
  static const String userId = 'userId';
  static const String status = 'status';
  static const String title = 'title';
  static const String author = 'author';
  static const String readPagesAmount = 'readPagesAmount';
  static const String allPagesAmount = 'allPagesAmount';
  static const String syncState = 'syncState';
}

SqliteBook createSqliteBook({
  String id = '',
  String userId = '',
  String status = 'unread',
  String title = '',
  String author = '',
  int readPagesAmount = 0,
  int allPagesAmount = 0,
  SyncState syncState = SyncState.none,
}) {
  return SqliteBook(
    id: id,
    userId: userId,
    status: status,
    title: title,
    author: author,
    readPagesAmount: readPagesAmount,
    allPagesAmount: allPagesAmount,
    syncState: syncState,
  );
}
