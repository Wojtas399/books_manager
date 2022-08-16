import 'dart:async';
import 'package:app/core/app_core.dart';
import 'package:app/core/services/error_handler_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      ErrorHandlerService.displayFlutterError(details.toString());
    };
    runApp(MyApp());
  }, (Object error, StackTrace stack) {
    ErrorHandlerService.displayError(error.toString());
  });
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fbApp,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('You have an error! ${snapshot.error.toString()}');
        } else if (snapshot.hasData) {
          return AppCore();
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
