part of 'calendar_bloc.dart';

abstract class CalendarEvent {
  const CalendarEvent();
}

class CalendarEventInitialize extends CalendarEvent {
  const CalendarEventInitialize();
}

class CalendarEventPreviousMonth extends CalendarEvent {
  const CalendarEventPreviousMonth();
}

class CalendarEventNextMonth extends CalendarEvent {
  const CalendarEventNextMonth();
}
