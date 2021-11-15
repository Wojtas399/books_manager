import 'package:app/constants/route_paths/app_route_path.dart';
import 'package:app/core/app_skeleton.dart';
import 'package:app/modules/add_book/add_book_screen.dart';
import 'package:app/modules/book_details/book_details_screen.dart';
import 'package:app/modules/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutePath.APP:
        return MaterialPageRoute(builder: (_) => AppSkeleton());
      case AppRoutePath.PROFILE:
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case AppRoutePath.BOOK_DETAILS:
        {
          Map<String, String>? arguments =
              settings.arguments as Map<String, String>?;
          if (arguments != null) {
            String? bookId = arguments['bookId'];
            if (bookId != null) {
              return MaterialPageRoute(
                builder: (_) => BookDetailsScreen(
                  bookId: bookId,
                ),
              );
            }
          }
          return MaterialPageRoute(
            builder: (_) => BookDetailsScreen(
              bookId: '',
            ),
          );
        }
      case AppRoutePath.ADD_BOOK:
        return MaterialPageRoute(builder: (_) => AddBookScreen());
      default:
        return MaterialPageRoute(builder: (_) => AppSkeleton());
    }
  }
}
