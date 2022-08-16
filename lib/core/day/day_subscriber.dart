import 'dart:async';
import 'package:app/interfaces/day_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'day_model.dart';

class DaySubscriber {
  late BehaviorSubject<List<Day>> _days;
  late DayInterface _dayInterface;
  StreamSubscription? _daysSubscription;

  DaySubscriber({
    required BehaviorSubject<List<Day>> days,
    required DayInterface dayInterface,
  }) {
    _days = days;
    _dayInterface = dayInterface;
  }

  subscribeDays() {
    Stream<QuerySnapshot>? snapshot = _dayInterface.subscribeDays();
    if (snapshot != null) {
      _daysSubscription = snapshot.listen((event) {
        event.docChanges.forEach((change) {
          if (change.type == DocumentChangeType.added) {
            print('added day');
            _addNewDay(change.doc);
          }
          if (change.type == DocumentChangeType.modified) {
            print('modified day');
            _updateModifiedDay(change.doc);
          }
          if (change.type == DocumentChangeType.removed) {
            print('removed');
            _deleteDay(change.doc);
          }
        });
      });
    }
  }

  dispose() {
    _days.close();
    _daysSubscription?.cancel();
  }

  _addNewDay(DocumentSnapshot day) {
    Map<String, dynamic> dayData = day.data() as Map<String, dynamic>;
    Map<String, int> convertedDayData = Map<String, int>.from(dayData);
    List<Day> allDays = _days.value;
    allDays.add(Day(id: day.id, booksReadPages: convertedDayData));
    _days.add(allDays);
  }

  _updateModifiedDay(DocumentSnapshot day) {
    Map<String, dynamic> dayData = day.data() as Map<String, dynamic>;
    Map<String, int> convertedDayData = Map<String, int>.from(dayData);
    List<Day> allDays = _days.value;
    int index = allDays.indexWhere((elem) => elem.id == day.id);
    Day currentDay = allDays[index];
    allDays[index] = Day(id: currentDay.id, booksReadPages: convertedDayData);
    _days.add(allDays);
  }

  _deleteDay(DocumentSnapshot day) {
    List<Day> allDays = _days.value;
    allDays.removeWhere((element) => element.id == day.id);
    _days.add(allDays);
  }
}
