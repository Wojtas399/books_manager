import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/initialize_user_books_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<int> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final InitializeUserBooksUseCase _initializeUserBooksUseCase;

  HomeCubit({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required InitializeUserBooksUseCase initializeUserBooksUseCase,
  }) : super(0) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _initializeUserBooksUseCase = initializeUserBooksUseCase;
  }

  Future<void> initialize() async {
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId == null) {
      return;
    }
    _initializeUserBooksUseCase.execute(userId: loggedUserId);
  }

  void changePage(int pageIndex) {
    emit(pageIndex);
  }
}
