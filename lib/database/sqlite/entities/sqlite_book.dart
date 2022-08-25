class SqliteBook {
  final int? id;
  final String userId;
  final String title;
  final String author;
  final int allPagesAmount;
  final int readPagesAmount;

  const SqliteBook({
    this.id,
    required this.userId,
    required this.title,
    required this.author,
    required this.allPagesAmount,
    required this.readPagesAmount,
  });

  SqliteBook copyWith({
    int? id,
    String? userId,
    String? title,
    String? author,
    int? allPagesAmount,
    int? readPagesAmount,
  }) {
    return SqliteBook(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      author: author ?? this.author,
      allPagesAmount: allPagesAmount ?? this.allPagesAmount,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
    );
  }

  Map<String, Object?> toJson() => {
        SqliteBookFields.id: id,
        SqliteBookFields.userId: userId,
        SqliteBookFields.title: title,
        SqliteBookFields.author: author,
        SqliteBookFields.allPagesAmount: allPagesAmount,
        SqliteBookFields.readPagesAmount: readPagesAmount,
      };
}

class SqliteBookFields {
  static const String id = '_id';
  static const String userId = 'userId';
  static const String title = 'title';
  static const String author = 'author';
  static const String allPagesAmount = 'allPagesAmount';
  static const String readPagesAmount = 'readPagesAmount';
}
