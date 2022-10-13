part of 'calendar_bloc.dart';

abstract class CalendarEvent {
  const CalendarEvent();
}

class CalendarEventInitialize extends CalendarEvent {
  const CalendarEventInitialize();
}

class CalendarEventDaysOfReadingUpdated extends CalendarEvent {
  final List<Day> daysOfReading;

  const CalendarEventDaysOfReadingUpdated({required this.daysOfReading});
}

class CalendarEventMonthChanged extends CalendarEvent {
  final int month;
  final int year;

  const CalendarEventMonthChanged({required this.month, required this.year});
}
