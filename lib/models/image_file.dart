import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ImageFile extends Equatable {
  final String name;
  final Uint8List data;

  const ImageFile({
    required this.name,
    required this.data,
  });

  @override
  List<Object> get props => [name, data];
}

ImageFile createImageFile({
  String name = '',
  Uint8List? data,
}) {
  return ImageFile(
    name: name,
    data: data ?? Uint8List(10),
  );
}
