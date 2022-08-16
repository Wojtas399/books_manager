import 'package:app/core/book/book_model.dart';
import 'package:app/core/services/book_status_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  BookStatusService service = BookStatusService();

  group('changeStringToBookStatus', () {
    group('free', () {
      BookStatus expectedStatus = BookStatus.pending;
      test('Should return $expectedStatus', () {
        BookStatus status = service.convertStringToBookStatus('free');
        expect(status, expectedStatus);
      });
    });

    group('read', () {
      BookStatus expectedStatus = BookStatus.read;
      test('Should return $expectedStatus', () {
        BookStatus status = service.convertStringToBookStatus('read');
        expect(status, expectedStatus);
      });
    });

    group('endRead', () {
      BookStatus expectedStatus = BookStatus.end;
      test('Should return $expectedStatus', () {
        BookStatus status = service.convertStringToBookStatus('endRead');
        expect(status, expectedStatus);
      });
    });

    group('paused', () {
      BookStatus expectedStatus = BookStatus.paused;
      test('Should return $expectedStatus', () {
        BookStatus status = service.convertStringToBookStatus('paused');
        expect(status, expectedStatus);
      });
    });

    group('default', () {
      BookStatus expectedStatus = BookStatus.pending;
      test('Should return $expectedStatus', () {
        BookStatus status = service.convertStringToBookStatus('wow');
        expect(status, expectedStatus);
      });
    });
  });

  group('changeBookStatusToString', () {
    group('BookStatus.read', () {
      String expectedStatus = 'read';
      test('Should return $expectedStatus', () {
        String status = service.convertBookStatusToString(BookStatus.read);
        expect(status, expectedStatus);
      });
    });

    group('BookStatus.pending', () {
      String expectedStatus = 'free';
      test('Should return $expectedStatus', () {
        String status = service.convertBookStatusToString(BookStatus.pending);
        expect(status, expectedStatus);
      });
    });

    group('BookStatus.end', () {
      String expectedStatus = 'endRead';
      test('Should return $expectedStatus', () {
        String status = service.convertBookStatusToString(BookStatus.end);
        expect(status, expectedStatus);
      });
    });

    group('BookStatus.paused', () {
      String expectedStatus = 'paused';
      test('Should return $expectedStatus', () {
        String status = service.convertBookStatusToString(BookStatus.paused);
        expect(status, expectedStatus);
      });
    });
  });
}