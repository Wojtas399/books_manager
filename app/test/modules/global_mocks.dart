import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/day/day_bloc.dart';
import 'package:app/core/day/day_query.dart';
import 'package:app/core/services/app_navigator_service.dart';
import 'package:app/core/services/book_category_service.dart';
import 'package:app/core/user/user_query.dart';
import 'package:mocktail/mocktail.dart';

class MockAppNavigatorService extends Mock implements AppNavigatorService {}

class MockUserQuery extends Mock implements UserQuery {}

class MockBookBloc extends Mock implements BookBloc {}

class MockBookCategoryService extends Mock implements BookCategoryService {}

class MockBookQuery extends Mock implements BookQuery {}

class MockDayBloc extends Mock implements DayBloc {}

class MockDayQuery extends Mock implements DayQuery {}
