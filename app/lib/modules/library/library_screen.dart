import 'package:app/constants/route_paths/app_route_path.dart';
import 'package:app/core/book/book_query.dart';
import 'package:app/core/services/app_navigator_service.dart';
import 'package:app/modules/library/filter_options_list/filter_options_list.dart';
import 'package:app/modules/library/action_button.dart';
import 'package:app/modules/library/library_screen_controller.dart';
import 'package:app/modules/library/library_screen_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'books_list_item.dart';

class LibraryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BookQuery bookQuery = Provider.of<BookQuery>(context);
    AppNavigatorService appNavigatorService =
        Provider.of<AppNavigatorService>(context);

    return StreamBuilder(
      stream: bookQuery.selectAllIds(),
      builder: (_, AsyncSnapshot<List<String>> snapshot) {
        List<String>? allBooksIds = snapshot.data;
        if (allBooksIds != null) {
          LibraryScreenController controller = LibraryScreenController(
            allBooksIds: allBooksIds,
            bookQuery: bookQuery,
            libraryScreenDialogs: LibraryScreenDialogs(),
          );
          return Stack(
            children: [
              FilterOptionsList(controller: controller),
              _BooksList(
                booksIds$: controller.matchingBooksIds$,
                areFilterOptions$: controller.areFilterOptions$,
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: LibraryScreenActionButton(
                  onTapFilter: () {
                    controller.onClickFilter();
                  },
                  onTapAddBook: () {
                    appNavigatorService.pushNamed(path: AppRoutePath.ADD_BOOK);
                  },
                ),
              ),
              _SearchBar(controller: controller),
            ],
          );
        }
        return Text('No books');
      },
    );
  }
}

class _SearchBar extends StatelessWidget {
  final LibraryScreenController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    FloatingSearchBarController searchBarController =
        FloatingSearchBarController();

    return FloatingSearchBar(
      hint: 'Szukaj...',
      controller: searchBarController,
      onQueryChanged: (String value) {
        controller.onQueryChanged(value);
      },
      onSubmitted: (String value) {
        controller.onQuerySubmitted(value);
        searchBarController.close();
      },
      clearQueryOnClose: false,
      automaticallyImplyBackButton: true,
      margins: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      builder: (BuildContext context, Animation<double> transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            child: _MatchingBooksList(
              booksInfo$: controller.matchingBooksInSearchEngine$,
            ),
          ),
        );
      },
    );
  }
}

class _BooksList extends StatelessWidget {
  final Stream<List<String>> booksIds$;
  final Stream<bool> areFilterOptions$;

  const _BooksList({required this.booksIds$, required this.areFilterOptions$});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: areFilterOptions$,
      builder: (_, AsyncSnapshot<bool> areFilterOptions) {
        bool? areOptions = areFilterOptions.data;
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: areOptions == true ? 115 : 64),
          child: StreamBuilder(
            stream: booksIds$,
            builder: (_, AsyncSnapshot<List<String>> snapshot) {
              List<String>? ids = snapshot.data;
              if (ids != null && ids.length > 0) {
                return SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      ...ids.map((bookId) => BooksListItem(bookId: bookId)),
                    ],
                  ),
                );
              }
              return Text('No data');
            },
          ),
        );
      },
    );
  }
}

class _MatchingBooksList extends StatelessWidget {
  final Stream<List<BookInfo>> booksInfo$;

  const _MatchingBooksList({required this.booksInfo$});

  @override
  Widget build(BuildContext context) {
    AppNavigatorService appNavigatorService =
        Provider.of<AppNavigatorService>(context);

    return StreamBuilder(
      stream: booksInfo$,
      builder: (_, AsyncSnapshot<List<BookInfo>> snapshot) {
        List<BookInfo>? booksData = snapshot.data;
        if (booksData != null) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...booksData.map(
                (data) => InkWell(
                  onTap: () {
                    appNavigatorService.pushNamed(
                      path: AppRoutePath.BOOK_DETAILS,
                      arguments: {'bookId': data.id }
                    );
                  },
                  child: ListTile(
                    title: Text(data.title),
                    subtitle: Text(data.author),
                  ),
                ),
              ),
            ],
          );
        }
        return Text('No books');
      },
    );
  }
}
