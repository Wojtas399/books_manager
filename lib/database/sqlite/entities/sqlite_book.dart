class SqliteBook {
  final int? id;
  final String userId;
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const SqliteBook({
    this.id,
    required this.userId,
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  SqliteBook copyWith({
    int? id,
    String? userId,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  }) {
    return SqliteBook(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      author: author ?? this.author,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
      allPagesAmount: allPagesAmount ?? this.allPagesAmount,
    );
  }

  Map<String, Object?> toJson() => {
        SqliteBookFields.id: id,
        SqliteBookFields.userId: userId,
        SqliteBookFields.title: title,
        SqliteBookFields.author: author,
        SqliteBookFields.readPagesAmount: readPagesAmount,
        SqliteBookFields.allPagesAmount: allPagesAmount,
      };
}

class SqliteBookFields {
  static const String id = '_id';
  static const String userId = 'userId';
  static const String title = 'title';
  static const String author = 'author';
  static const String readPagesAmount = 'readPagesAmount';
  static const String allPagesAmount = 'allPagesAmount';
}
