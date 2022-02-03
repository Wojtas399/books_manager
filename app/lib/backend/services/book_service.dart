import 'dart:io';
import 'package:app/core/services/date_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BookService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot>? subscribeBooks() {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return _firestore
          .collection('Users')
          .doc(user.uid)
          .collection('Books')
          .snapshots();
    }
    return null;
  }

  Future<String> getImgUrl(String imgPath) async {
    try {
      return await _storage.ref(imgPath).getDownloadURL();
    } catch (error) {
      throw error.toString();
    }
  }

  Future<String> addBook({
    required String title,
    required String author,
    required String category,
    required String imgPath,
    required int readPages,
    required int pages,
    required String status,
  }) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        String currentDate = DateService.getCurrentDate();
        String pathToImageInTheStorage = await _addNewImage(imgPath);
        await _firestore
            .collection('Users')
            .doc(user.uid)
            .collection('Books')
            .add({
          'title': title,
          'author': author,
          'category': category,
          'imgPath': pathToImageInTheStorage,
          'readPages': readPages,
          'pages': pages,
          'status': status,
          'lastActualisation': currentDate,
          'addDate': currentDate,
        });
        return 'Success';
      } catch (error) {
        throw error;
      }
    } else {
      throw 'User does not exist';
    }
  }

  Future<String> updateBookImage({
    required String bookId,
    required String newImgPath,
  }) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        await _deleteCurrentBookImage(bookId);
        String imgPath = await _addNewImage(newImgPath);
        await _firestore
            .collection('Users')
            .doc(user.uid)
            .collection('Books')
            .doc(bookId)
            .update({'imgPath': imgPath});
        return 'Success';
      } catch (error) {
        throw error;
      }
    } else {
      throw 'User does not exist';
    }
  }

  Future<String> updateBook({
    required String bookId,
    String? author,
    String? title,
    String? category,
    int? pages,
    int? readPages,
    String? status,
  }) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      Map<String, dynamic> data = _makeUpdatedData(
        author,
        title,
        category,
        pages,
        readPages,
        status,
      );
      try {
        await _firestore
            .collection('Users')
            .doc(user.uid)
            .collection('Books')
            .doc(bookId)
            .update(data);
        return 'Successfully updated user';
      } catch (error) {
        throw error.toString();
      }
    } else {
      throw 'User does not exist';
    }
  }

  Future<String> deleteBook({required String bookId}) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        await _deleteCurrentBookImage(bookId);
        await _firestore
            .collection('Users')
            .doc(user.uid)
            .collection('Books')
            .doc(bookId)
            .delete();
        return 'Successfully deleted book';
      } catch (error) {
        throw error;
      }
    } else {
      throw 'User does not exist';
    }
  }

  _deleteCurrentBookImage(String bookId) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        final DocumentSnapshot<Map<String, dynamic>> bookDocument =
            await _firestore
                .collection('Users')
                .doc(user.uid)
                .collection('Books')
                .doc(bookId)
                .get();
        if (bookDocument.exists) {
          Map<String, dynamic> bookData =
              bookDocument.data() as Map<String, dynamic>;
          String currentImagePath = bookData['imgPath'];
          await _storage.ref(currentImagePath).delete();
        }
      } catch (error) {
        throw error;
      }
    }
  }

  Future<String> _addNewImage(String newImgPath) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        String path = '';
        List<String> imgFileArr = newImgPath.split('/');
        path = user.uid + '/books/' + imgFileArr[imgFileArr.length - 1];
        File imgFile = File(newImgPath);
        await _storage.ref().child(path).putFile(imgFile);
        return path;
      } catch (error) {
        throw error.toString();
      }
    } else {
      throw 'user does not exist';
    }
  }

  Map<String, dynamic> _makeUpdatedData(
    String? author,
    String? title,
    String? category,
    int? pages,
    int? readPages,
    String? status,
  ) {
    Map<String, dynamic> data = new Map();
    if (author != null) {
      data['author'] = author;
    }
    if (title != null) {
      data['title'] = title;
    }
    if (category != null) {
      data['category'] = category;
    }
    if (pages != null) {
      data['pages'] = pages;
    }
    if (readPages != null) {
      data['readPages'] = readPages;
    }
    if (status != null) {
      data['status'] = status;
    }
    data['lastActualisation'] = DateService.getCurrentDate();
    return data;
  }
}
