import 'package:app/components/book_image_picker_component.dart';
import 'package:app/features/book_creator/bloc/book_creator_bloc.dart';
import 'package:app/models/image.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_bloc/flutter_bloc.dart';

class BookCreatorImage extends widgets.StatelessWidget {
  const BookCreatorImage({super.key});

  @override
  widgets.Widget build(widgets.BuildContext context) {
    final Image? image = context.select(
      (BookCreatorBloc bloc) => bloc.state.image,
    );

    return BookImagePickerComponent(
      image: image,
      onImageChanged: (Image? image) => _onImageChanged(image, context),
    );
  }

  void _onImageChanged(Image? image, widgets.BuildContext context) {
    context.read<BookCreatorBloc>().add(
          BookCreatorEventChangeImage(image: image),
        );
  }
}
