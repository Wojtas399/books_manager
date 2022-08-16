import 'package:app/core/services/date_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DayService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot>? subscribeDays() {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return _firestore
          .collection('Users')
          .doc(user.uid)
          .collection('Days')
          .snapshots();
    }
    return null;
  }

  Future<String> addPages({
    required String dayId,
    required String bookId,
    required int pagesToAdd,
  }) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        DocumentReference<Map<String, dynamic>> dayRef = _firestore
            .collection('Users')
            .doc(user.uid)
            .collection('Days')
            .doc(dayId);
        DocumentSnapshot<Map<String, dynamic>> doc = await dayRef.get();
        Map<String, dynamic>? docData = doc.data();
        await _addPages(bookId, pagesToAdd, docData, dayRef);
        return 'Successfully added pages';
      } catch (error) {
        throw error;
      }
    } else {
      throw 'User does not exist';
    }
  }

  Future<String> deletePages({
    required String bookId,
    required int pagesToDelete,
  }) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        CollectionReference<Map<String, dynamic>> daysRef =
            _firestore.collection('Users').doc(user.uid).collection('Days');
        QuerySnapshot<Map<String, dynamic>> allDays = await daysRef.get();
        List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = allDays.docs;
        List<String> dates = _getSortedDaysFromDocs(docs);
        int counter = 0;
        while (pagesToDelete > 0 && counter < dates.length) {
          int idx = docs.indexWhere((element) => element.id == dates[counter]);
          DocumentReference<Map<String, dynamic>> docRef = daysRef.doc(
            docs[idx].id,
          );
          Map<String, dynamic> dayData = docs[idx].data();
          List<String> booksIdsInTheDay = dayData.keys.toList();
          if (booksIdsInTheDay.contains(bookId)) {
            int pages = dayData[bookId];
            pagesToDelete = await _deletePages(
              bookId,
              booksIdsInTheDay,
              pages,
              pagesToDelete,
              docRef,
            );
          }
          counter++;
        }
        return 'Successfully deleted pages';
      } catch (error) {
        throw error;
      }
    } else {
      throw 'User does not exist';
    }
  }

  List<String> _getSortedDaysFromDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) {
    List<String> dates = [];
    docs.forEach((doc) {
      dates.add(doc.id);
    });
    dates.sort(DateService.compareDatesDescending);
    return dates;
  }

  _addPages(
    String bookId,
    int pagesToAdd,
    Map<String, dynamic>? docData,
    DocumentReference<Map<String, dynamic>> dayRef,
  ) async {
    if (docData != null) {
      List<String> booksIds = docData.keys.toList();
      if (booksIds.contains(bookId)) {
        int bookPages = docData[bookId];
        await dayRef.update({'$bookId': bookPages + pagesToAdd});
      } else {
        await dayRef.update({'$bookId': pagesToAdd});
      }
    } else {
      await dayRef.set({'$bookId': pagesToAdd});
    }
  }

  Future<int> _deletePages(
    String bookId,
    List<String> booksIdsInTheDay,
    int pages,
    int pagesToDelete,
    DocumentReference<Map<String, dynamic>> docRef,
  ) async {
    if (pages <= pagesToDelete) {
      if (booksIdsInTheDay.length == 1) {
        await docRef.delete();
      } else {
        await docRef.update({'$bookId': FieldValue.delete()});
      }
      pagesToDelete -= pages;
    } else {
      await docRef.update({'$bookId': pages - pagesToDelete});
      pagesToDelete = 0;
    }
    return pagesToDelete;
  }
}
