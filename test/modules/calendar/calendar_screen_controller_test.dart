import 'package:app/modules/calendar/calendar_screen_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CalendarScreenController controller;

  setUp(() {
    controller = new CalendarScreenController();
    controller.onTapDay('05.12.2021');
  });

  test('selected day id', () async {
    String selectedDayId = await controller.selectedDayId$.first;

    expect(selectedDayId, '05.12.2021');
  });
}
