import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FirebaseDocChange<Object> extends Equatable {
  final DocumentChangeType docChangeType;
  final Object? doc;

  const FirebaseDocChange({
    required this.docChangeType,
    required this.doc,
  });

  @override
  List<dynamic> get props => [
        docChangeType,
        doc,
      ];
}

FirebaseDocChange<Object> createFirebaseDocChange<Object>({
  DocumentChangeType docChangeType = DocumentChangeType.added,
  Object? doc,
}) {
  return FirebaseDocChange<Object>(
    docChangeType: docChangeType,
    doc: doc,
  );
}
