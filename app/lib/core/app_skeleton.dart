import 'package:app/common/ui/dialogs.dart';
import 'package:app/config/themes/gradients.dart';
import 'package:app/constants/route_paths/app_route_path.dart';
import 'package:app/core/book/book_bloc.dart';
import 'package:app/core/day/day_bloc.dart';
import 'package:app/core/services/app_navigator_service.dart';
import 'package:app/core/user/user_bloc.dart';
import 'package:app/modules/calendar/calendar_screen.dart';
import 'package:app/modules/library/library_screen.dart';
import 'package:app/modules/home/home_screen.dart';
import 'package:app/modules/start/start_screen.dart';
import 'package:app/modules/statistics/statistics_screen.dart';
import 'package:app/widgets/buttons/raw_material_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppSkeleton extends StatelessWidget {
  const AppSkeleton();

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: 0);
    UserBloc userBloc = Provider.of<UserBloc>(context);
    BookBloc bookBloc = Provider.of<BookBloc>(context);
    DayBloc dayBloc = Provider.of<DayBloc>(context);
    AppNavigatorService appNavigatorService =
        Provider.of<AppNavigatorService>(context);
    ValueNotifier<int> currentIndex = ValueNotifier<int>(0);
    List<String> titles = [
      'Strona główna',
      'Biblioteka',
      'Statystyki',
      'Kalendarz',
    ];

    return ValueListenableBuilder(
      valueListenable: currentIndex,
      builder: (_, int pageIndex, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              titles[pageIndex],
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            actions: [
              RawMaterialIconButton(
                onClick: () {
                  appNavigatorService.pushNamed(path: AppRoutePath.PROFILE);
                },
                icon: Icons.manage_accounts_rounded,
              ),
              RawMaterialIconButton(
                onClick: () {
                  _signOut(bookBloc, dayBloc, userBloc, context);
                },
                icon: Icons.logout_rounded,
              ),
            ],
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: Gradients.greenBlueGradient(),
              ),
            ),
          ),
          body: PageView(
            controller: pageController,
            onPageChanged: (int index) {
              currentIndex.value = index;
            },
            children: [
              HomeScreen(),
              LibraryScreen(),
              StatisticsScreen(),
              CalendarScreen(),
            ],
          ),
          bottomNavigationBar: _BottomNavigator(
            currentIndex: pageIndex,
            onTap: (int index) {
              currentIndex.value = index;
              pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOutSine,
              );
            },
          ),
        );
      },
    );
  }

  _signOut(
    BookBloc bookBloc,
    DayBloc dayBloc,
    UserBloc userBloc,
    BuildContext context,
  ) async {
    bool? confirmation = await Dialogs.showConfirmationDialog(
      title: 'Wylogowywanie',
      message: 'Czy na pewno chcesz się wylogować?',
    );
    if (confirmation == true) {
      bookBloc.dispose();
      dayBloc.dispose();
      await userBloc.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => StartScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }
}

class _BottomNavigator extends StatelessWidget {
  final int currentIndex;
  final Function(int index) onTap;

  const _BottomNavigator({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: Gradients.greenBlueGradient()),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: 'Główna',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 1
                  ? Icons.library_books
                  : Icons.library_books_outlined,
            ),
            label: 'Biblioteka',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 2
                  ? Icons.insert_chart_rounded
                  : Icons.insert_chart_outlined_rounded,
            ),
            label: 'Statystyki',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              currentIndex == 3
                  ? Icons.calendar_today
                  : Icons.calendar_today_outlined,
            ),
            label: 'Kalendarz',
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.black87,
      ),
    );
  }
}
