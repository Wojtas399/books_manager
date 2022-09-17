import 'dart:typed_data';

class BookPreviewArguments {
  final String bookId;
  final Uint8List? imageData;

  const BookPreviewArguments({
    required this.bookId,
    required this.imageData,
  });
}
