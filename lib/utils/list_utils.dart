import 'package:app/extensions/list_extensions.dart';

class ListUtils {
  static List<T> getUniqueElementsFromLists<T>(List<T> list1, List<T> list2) {
    return [...list1, ...list2].getUniqueElements();
  }
}
