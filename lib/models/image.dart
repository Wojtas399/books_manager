import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class Image extends Equatable {
  final String fileName;
  final Uint8List data;

  const Image({
    required this.fileName,
    required this.data,
  });

  @override
  List<Object> get props => [fileName, data];
}

Image createImage({
  String fileName = '',
  Uint8List? data,
}) {
  return Image(
    fileName: fileName,
    data: data ?? Uint8List(10),
  );
}
