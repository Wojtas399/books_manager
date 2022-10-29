import 'package:app/components/book_image_picker_component.dart';
import 'package:app/features/book_creator/bloc/book_creator_bloc.dart';
import 'package:app/models/image_file.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookCreatorImage extends StatelessWidget {
  const BookCreatorImage({super.key});

  @override
  Widget build(BuildContext context) {
    final ImageFile? imageFile = context.select(
      (BookCreatorBloc bloc) => bloc.state.imageFile,
    );

    return BookImagePickerComponent(
      imageFile: imageFile,
      onImageChanged: (ImageFile? imageFile) => _onImageChanged(
        imageFile,
        context,
      ),
    );
  }

  void _onImageChanged(ImageFile? imageFile, BuildContext context) {
    context.read<BookCreatorBloc>().add(
          BookCreatorEventChangeImage(imageFile: imageFile),
        );
  }
}
