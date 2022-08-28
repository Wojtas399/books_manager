class SqliteBook {
  final int? id;
  final String userId;
  final String status;
  final String? image;
  final String title;
  final String author;
  final int readPagesAmount;
  final int allPagesAmount;

  const SqliteBook({
    this.id,
    required this.userId,
    required this.status,
    required this.image,
    required this.title,
    required this.author,
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  static SqliteBook fromJson(Map<String, Object?> json) => SqliteBook(
        id: json[SqliteBookFields.id] as int?,
        userId: json[SqliteBookFields.userId] as String,
        status: json[SqliteBookFields.status] as String,
        image: json[SqliteBookFields.image] as String?,
        title: json[SqliteBookFields.title] as String,
        author: json[SqliteBookFields.author] as String,
        readPagesAmount: json[SqliteBookFields.readPagesAmount] as int,
        allPagesAmount: json[SqliteBookFields.allPagesAmount] as int,
      );

  Map<String, Object?> toJson() => {
        SqliteBookFields.id: id,
        SqliteBookFields.userId: userId,
        SqliteBookFields.status: status,
        SqliteBookFields.image: image,
        SqliteBookFields.title: title,
        SqliteBookFields.author: author,
        SqliteBookFields.readPagesAmount: readPagesAmount,
        SqliteBookFields.allPagesAmount: allPagesAmount,
      };

  SqliteBook copyWith({
    int? id,
    String? status,
    String? image,
    String? userId,
    String? title,
    String? author,
    int? readPagesAmount,
    int? allPagesAmount,
  }) {
    return SqliteBook(
      id: id ?? this.id,
      status: status ?? this.status,
      image: image ?? this.image,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      author: author ?? this.author,
      readPagesAmount: readPagesAmount ?? this.readPagesAmount,
      allPagesAmount: allPagesAmount ?? this.allPagesAmount,
    );
  }
}

class SqliteBookFields {
  static const String id = '_id';
  static const String userId = 'userId';
  static const String status = 'status';
  static const String image = 'image';
  static const String title = 'title';
  static const String author = 'author';
  static const String readPagesAmount = 'readPagesAmount';
  static const String allPagesAmount = 'allPagesAmount';
}
