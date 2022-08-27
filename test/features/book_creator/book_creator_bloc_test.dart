import 'package:app/features/book_creator/bloc/book_creator_bloc.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  BookCreatorBloc createBloc({
    String? imagePath,
  }) {
    return BookCreatorBloc(
      imagePath: imagePath,
    );
  }

  BookCreatorState createState({
    String? imagePath,
    String title = '',
    String author = '',
    int allPagesAmount = 0,
    int readPagesAmount = 0,
  }) {
    return BookCreatorState(
      imagePath: imagePath,
      title: title,
      author: author,
      allPagesAmount: allPagesAmount,
      readPagesAmount: readPagesAmount,
    );
  }

  blocTest(
    'change image path, should update image path',
    build: () => createBloc(),
    act: (BookCreatorBloc bloc) {
      bloc.add(
        const BookCreatorEventChangeImagePath(imagePath: 'imagePath'),
      );
    },
    expect: () => [
      createState(imagePath: 'imagePath'),
    ],
  );

  blocTest(
    'remove image, should set image path as null',
    build: () => createBloc(imagePath: 'imagePath'),
    act: (BookCreatorBloc bloc) {
      bloc.add(
        const BookCreatorEventRemoveImage(),
      );
    },
    expect: () => [
      createState(imagePath: null),
    ],
  );

  blocTest(
    'title changed, should update title',
    build: () => createBloc(),
    act: (BookCreatorBloc bloc) {
      bloc.add(
        const BookCreatorEventTitleChanged(title: 'title'),
      );
    },
    expect: () => [
      createState(title: 'title'),
    ],
  );

  blocTest(
    'author changed, should update author',
    build: () => createBloc(),
    act: (BookCreatorBloc bloc) {
      bloc.add(
        const BookCreatorEventAuthorChanged(author: 'author'),
      );
    },
    expect: () => [
      createState(author: 'author'),
    ],
  );

  blocTest(
    'read pages amount changed, should update read pages',
    build: () => createBloc(),
    act: (BookCreatorBloc bloc) {
      bloc.add(
        const BookCreatorEventReadPagesAmountChanged(readPagesAmount: 10),
      );
    },
    expect: () => [
      createState(readPagesAmount: 10),
    ],
  );

  blocTest(
    'all pages amount changed, should update all pages amount',
    build: () => createBloc(),
    act: (BookCreatorBloc bloc) {
      bloc.add(
        const BookCreatorEventAllPagesAmountChanged(allPagesAmount: 20),
      );
    },
    expect: () => [
      createState(allPagesAmount: 20),
    ],
  );
}
