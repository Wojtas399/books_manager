extension StringExtensions on String {
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
}
