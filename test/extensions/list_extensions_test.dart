import 'package:app/extensions/list_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'does not contain, should return true if list does not contain given element',
    () {
      const String element = 's1';
      const List<String> elements = ['s2', 's3', 's0'];
      const bool expectedValue = true;

      final bool doesListNotContainElement = elements.doesNotContain(element);

      expect(doesListNotContainElement, expectedValue);
    },
  );

  test(
    'does not contain, should return false if list contains given element',
    () {
      const String element = 's2';
      const List<String> elements = ['s2', 's3', 's0'];
      const bool expectedValue = false;

      final bool doesListNotContainElement = elements.doesNotContain(element);

      expect(doesListNotContainElement, expectedValue);
    },
  );

  test(
    'remove repetitions, should return list without repetitions',
    () {
      const List<String> allElements = ['s1', 's1', 's2', 's1', 's2'];
      const List<String> expectedElements = ['s1', 's2'];

      final List<String> elements = allElements.removeRepetitions();

      expect(elements, expectedElements);
    },
  );
}
