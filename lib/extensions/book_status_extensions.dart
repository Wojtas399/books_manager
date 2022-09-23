import 'package:app/domain/entities/book.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

extension BookStatusExtensions on BookStatus {
  Color toColor() {
    switch (this) {
      case BookStatus.unread:
        return Colors.red;
      case BookStatus.inProgress:
        return Colors.deepOrangeAccent;
      case BookStatus.finished:
        return Colors.green;
    }
  }

  IconData toIconData() {
    switch (this) {
      case BookStatus.unread:
        return MdiIcons.progressClose;
      case BookStatus.inProgress:
        return MdiIcons.progressClock;
      case BookStatus.finished:
        return MdiIcons.progressCheck;
    }
  }

  String toUIText() {
    switch (this) {
      case BookStatus.unread:
        return 'Nieprzeczytana';
      case BookStatus.inProgress:
        return 'W trakcie czytania';
      case BookStatus.finished:
        return 'Przeczytana';
    }
  }
}
