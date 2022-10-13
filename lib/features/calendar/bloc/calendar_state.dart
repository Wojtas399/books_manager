part of 'calendar_bloc.dart';

class CalendarState extends BlocState {
  final DateTime? todayDate;
  final List<Day> daysOfReading;

  const CalendarState({
    required super.status,
    required this.todayDate,
    required this.daysOfReading,
  });

  @override
  List<Object> get props => [
        status,
        todayDate ?? '',
        daysOfReading,
      ];

  @override
  CalendarState copyWith({
    BlocStatus? status,
    DateTime? todayDate,
    List<Day>? daysOfReading,
  }) {
    return CalendarState(
      status: status ?? const BlocStatusComplete(),
      todayDate: todayDate ?? this.todayDate,
      daysOfReading: daysOfReading ?? this.daysOfReading,
    );
  }

  List<DateTime> get datesOfDaysOfReading =>
      daysOfReading.map((Day day) => day.date).toList();

  List<ReadBook> getReadBooksFromDay(DateTime date) {
    final List<Day?> days = [...daysOfReading];
    final Day? day = days.firstWhere(
      (Day? day) => day?.date == date,
      orElse: () => null,
    );
    if (day == null) {
      return [];
    }
    return day.readBooks;
  }
}
