import 'package:app/extensions/string_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'remove all spaces',
    () {
      const String primaryString = ' w o w  ';
      const String expectedString = 'wow';

      final String str = primaryString.removeAllSpaces();

      expect(str, expectedString);
    },
  );

  test(
    'remove all commas',
    () {
      const String primaryString = ',w,o,w,,';
      const String expectedString = 'wow';

      final String str = primaryString.removeAllCommas();

      expect(str, expectedString);
    },
  );

  test(
    'remove all dots',
    () {
      const String primaryString = '.w.o.w..';
      const String expectedString = 'wow';

      final String str = primaryString.removeAllDots();

      expect(str, expectedString);
    },
  );

  test(
    'remove all dashes',
    () {
      const String primaryString = '-w-o-w--';
      const String expectedString = 'wow';

      final String str = primaryString.removeAllDashes();

      expect(str, expectedString);
    },
  );

  test(
    'to int',
    () {
      const String numberAsString = ' 0,2,0.1-0,';
      const int expectedNumber = 2010;

      final int number = numberAsString.toInt();

      expect(number, expectedNumber);
    },
  );
}
