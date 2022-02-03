import 'package:app/backend/services/user_service.dart';
import 'package:app/repositories/auth_interface.dart';
import 'package:app/backend/services/auth_service.dart';
import 'package:app/backend/repositories/auth_repository.dart';
import 'package:app/repositories/book_interface.dart';
import 'package:app/backend/services/book_service.dart';
import 'package:app/repositories/day_interface.dart';
import 'package:app/backend/services/day_service.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/core/services/book_status_service.dart';
import 'package:app/backend/repositories/book_repository.dart';
import 'package:app/backend/repositories/day_repository.dart';
import 'package:app/repositories/user/user_interface.dart';
import 'package:app/repositories/user/user_repository.dart';

class BackendProvider {
  static AuthInterface provideAuthInterface() {
    return AuthRepository(authService: AuthService());
  }

  static UserInterface provideUserInterface() {
    return UserRepository(userService: UserService());
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
