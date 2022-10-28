import '../../mocks/domain/use_cases/auth/mock_get_logged_user_id_use_case.dart';
import '../../mocks/domain/use_cases/book/mock_add_book_use_case.dart';

void main() {
  final getLoggedUserIdUseCase = MockGetLoggedUserIdUseCase();
  final addBookUseCase = MockAddBookUseCase();

  // BookCreatorBloc createBloc({
  //   ImageFile? image,
  //   String title = '',
  //   String author = '',
  //   int readPagesAmount = 0,
  //   int allPagesAmount = 0,
  // }) {
  //   return BookCreatorBloc(
  //     getLoggedUserIdUseCase: getLoggedUserIdUseCase,
  //     addBookUseCase: addBookUseCase,
  //     image: image,
  //     title: title,
  //     author: author,
  //     readPagesAmount: readPagesAmount,
  //     allPagesAmount: allPagesAmount,
  //   );
  // }
  //
  // BookCreatorState createState({
  //   BlocStatus status = const BlocStatusInProgress(),
  //   ImageFile? image,
  //   String title = '',
  //   String author = '',
  //   int allPagesAmount = 0,
  //   int readPagesAmount = 0,
  // }) {
  //   return BookCreatorState(
  //     status: status,
  //     image: image,
  //     title: title,
  //     author: author,
  //     allPagesAmount: allPagesAmount,
  //     readPagesAmount: readPagesAmount,
  //   );
  // }
  //
  // tearDown(() {
  //   reset(getLoggedUserIdUseCase);
  //   reset(addBookUseCase);
  // });
  //
  // group(
  //   'change image',
  //   () {
  //     void eventCall(BookCreatorBloc bloc, ImageFile? image) => bloc.add(
  //           BookCreatorEventChangeImage(image: image),
  //         );
  //
  //     blocTest(
  //       'should update image',
  //       build: () => createBloc(),
  //       act: (BookCreatorBloc bloc) => eventCall(bloc, createImageFile()),
  //       expect: () => [
  //         createState(
  //           image: createImageFile(),
  //         ),
  //       ],
  //     );
  //
  //     blocTest(
  //       'should set image data as null if given image data is null',
  //       build: () => createBloc(
  //         image: createImageFile(),
  //       ),
  //       act: (BookCreatorBloc bloc) => eventCall(bloc, null),
  //       expect: () => [
  //         createState(
  //           image: null,
  //         ),
  //       ],
  //     );
  //   },
  // );
  //
  // blocTest(
  //   'title changed, should update title',
  //   build: () => createBloc(),
  //   act: (BookCreatorBloc bloc) {
  //     bloc.add(
  //       const BookCreatorEventTitleChanged(title: 'title'),
  //     );
  //   },
  //   expect: () => [
  //     createState(title: 'title'),
  //   ],
  // );
  //
  // blocTest(
  //   'author changed, should update author',
  //   build: () => createBloc(),
  //   act: (BookCreatorBloc bloc) {
  //     bloc.add(
  //       const BookCreatorEventAuthorChanged(author: 'author'),
  //     );
  //   },
  //   expect: () => [
  //     createState(author: 'author'),
  //   ],
  // );
  //
  // blocTest(
  //   'read pages amount changed, should update read pages',
  //   build: () => createBloc(),
  //   act: (BookCreatorBloc bloc) {
  //     bloc.add(
  //       const BookCreatorEventReadPagesAmountChanged(readPagesAmount: 10),
  //     );
  //   },
  //   expect: () => [
  //     createState(readPagesAmount: 10),
  //   ],
  // );
  //
  // blocTest(
  //   'all pages amount changed, should update all pages amount',
  //   build: () => createBloc(),
  //   act: (BookCreatorBloc bloc) {
  //     bloc.add(
  //       const BookCreatorEventAllPagesAmountChanged(allPagesAmount: 20),
  //     );
  //   },
  //   expect: () => [
  //     createState(allPagesAmount: 20),
  //   ],
  // );
  //
  // group(
  //   'submit',
  //   () {
  //     const String loggedUserId = 'loggedUserId';
  //     final ImageFile image = createImageFile(name: 'i1', data: Uint8List(1));
  //     const String title = 'title';
  //     const String author = 'author';
  //     const int readPagesAmount = 20;
  //     const int allPagesAmount = 200;
  //     final BookCreatorState state = createState(
  //       image: image,
  //       title: title,
  //       author: author,
  //       readPagesAmount: readPagesAmount,
  //       allPagesAmount: allPagesAmount,
  //     );
  //
  //     void eventCall(BookCreatorBloc bloc) => bloc.add(
  //           const BookCreatorEventSubmit(),
  //         );
  //
  //     setUp(() {
  //       addBookUseCase.mock();
  //     });
  //
  //     blocTest(
  //       'should call use case responsible for adding new book',
  //       build: () => createBloc(
  //         image: image,
  //         title: title,
  //         author: author,
  //         readPagesAmount: readPagesAmount,
  //         allPagesAmount: allPagesAmount,
  //       ),
  //       setUp: () {
  //         getLoggedUserIdUseCase.mock(loggedUserId: loggedUserId);
  //       },
  //       act: (BookCreatorBloc bloc) => eventCall(bloc),
  //       expect: () => [
  //         state.copyWith(
  //           status: const BlocStatusLoading(),
  //         ),
  //         state.copyWith(
  //           status: const BlocStatusComplete<BookCreatorBlocInfo>(
  //             info: BookCreatorBlocInfo.bookHasBeenAdded,
  //           ),
  //         ),
  //       ],
  //       verify: (_) {
  //         verify(
  //           () => addBookUseCase.execute(
  //             userId: loggedUserId,
  //             status: BookStatus.unread,
  //             image: image,
  //             title: title,
  //             author: author,
  //             readPagesAmount: readPagesAmount,
  //             allPagesAmount: allPagesAmount,
  //           ),
  //         ).called(1);
  //       },
  //     );
  //
  //     blocTest(
  //       'should not call use case responsible for adding new book if logged user id is null',
  //       build: () => createBloc(),
  //       setUp: () {
  //         getLoggedUserIdUseCase.mock();
  //       },
  //       act: (BookCreatorBloc bloc) => eventCall(bloc),
  //       expect: () => [
  //         createState(
  //           status: const BlocStatusLoading(),
  //         ),
  //         createState(
  //           status: const BlocStatusLoggedUserNotFound(),
  //         ),
  //       ],
  //       verify: (_) {
  //         verifyNever(
  //           () => addBookUseCase.execute(
  //             userId: loggedUserId,
  //             status: BookStatus.unread,
  //             image: image,
  //             title: title,
  //             author: author,
  //             readPagesAmount: readPagesAmount,
  //             allPagesAmount: allPagesAmount,
  //           ),
  //         );
  //       },
  //     );
  //   },
  // );
}
