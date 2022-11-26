import 'package:app/domain/use_cases/auth/get_logged_user_id_use_case.dart';
import 'package:app/domain/use_cases/book/initialize_books_of_user_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<int> {
  late final GetLoggedUserIdUseCase _getLoggedUserIdUseCase;
  late final InitializeBooksOfUserUseCase _initializeBooksOfUserUseCase;

  HomeCubit({
    required GetLoggedUserIdUseCase getLoggedUserIdUseCase,
    required InitializeBooksOfUserUseCase initializeBooksOfUserUseCase,
  }) : super(0) {
    _getLoggedUserIdUseCase = getLoggedUserIdUseCase;
    _initializeBooksOfUserUseCase = initializeBooksOfUserUseCase;
  }

  Future<void> initialize() async {
    final String? loggedUserId = await _getLoggedUserIdUseCase.execute().first;
    if (loggedUserId == null) {
      return;
    }
    _initializeBooksOfUserUseCase.execute(userId: loggedUserId);
  }

  void changePage(int pageIndex) {
    emit(pageIndex);
  }
}
