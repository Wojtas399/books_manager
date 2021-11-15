import 'package:app/repositories/auth/auth_interface.dart';
import 'package:app/backend/auth_service.dart';
import 'package:app/repositories/auth/auth_repository.dart';
import 'package:app/repositories/book_repository/book_interface.dart';
import 'package:app/backend/book_service.dart';
import 'package:app/repositories/day_repository/day_interface.dart';
import 'package:app/backend/day_service.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/core/services/book_status_service.dart';
import 'package:app/repositories/book_repository/book_repository.dart';
import 'package:app/repositories/day_repository/day_repository.dart';

class BackendProvider {
  static AuthInterface provideAuthInterface() {
    return AuthRepository(authService: AuthService());
  }

  static BookInterface provideBookInterface() {
    return BookRepository(
      bookService: BookService(),
      bookCategoryService: BookCategoryService(),
      bookStatusService: BookStatusService(),
    );
  }

  static DayInterface provideDayInterface() {
    return DayRepository(dayService: DayService());
  }
}
