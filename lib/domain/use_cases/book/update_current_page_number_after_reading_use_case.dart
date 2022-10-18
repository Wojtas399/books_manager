import 'package:app/domain/interfaces/book_interface.dart';
import 'package:app/domain/interfaces/day_interface.dart';
import 'package:app/providers/date_provider.dart';

class UpdateCurrentPageNumberAfterReadingUseCase {
  late final BookInterface _bookInterface;
  late final DayInterface _dayInterface;
  late final DateProvider _dateProvider;

  UpdateCurrentPageNumberAfterReadingUseCase({
    required BookInterface bookInterface,
    required DayInterface dayInterface,
    required DateProvider dateProvider,
  }) {
    _bookInterface = bookInterface;
    _dayInterface = dayInterface;
    _dateProvider = dateProvider;
  }

  Future<void> execute({
    required String bookId,
    required int newCurrentPageNumber,
  }) async {
    //TODO
  }
}
