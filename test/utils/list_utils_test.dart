import 'package:app/utils/list_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'get unique elements from lists',
    () {
      final List<String> list1 = ['s1', 's2', 's3', 's5'];
      final List<String> list2 = ['s1', 's4'];
      final List<String> expectedUniqueElements = [
        's1',
        's2',
        's3',
        's5',
        's4',
      ];

      final List<String> uniqueElements = ListUtils.getUniqueElementsFromLists(
        list1,
        list2,
      );

      expect(uniqueElements, expectedUniqueElements);
    },
  );
}
