extension StringExtension on String {
  String removeAllSpaces() {
    return replaceAll(' ', '');
  }

  String removeAllCommas() {
    return replaceAll(',', '');
  }

  String removeAllDots() {
    return replaceAll('.', '');
  }

  String removeAllDashes() {
    return replaceAll('-', '');
  }

  int toInt() {
    final String numberAsString =
        removeAllSpaces().removeAllCommas().removeAllDots().removeAllDashes();
    if (numberAsString.isNotEmpty) {
      return int.parse(numberAsString);
    }
    return 0;
  }
}
