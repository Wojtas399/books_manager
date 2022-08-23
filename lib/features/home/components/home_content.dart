import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/navigation.dart';
import '../../../config/themes/app_colors.dart';
import '../../../interfaces/factories/icon_factory.dart';
import '../../../interfaces/factories/widget_factory.dart';
import '../../../models/bottom_nav_bar.dart';
import '../../calendar/calendar_screen.dart';
import '../../library/library_screen.dart';
import '../../reading/reading_screen.dart';
import '../bloc/home_bloc.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetFactory widgetFactory = context.read<WidgetFactory>();
    final IconFactory iconFactory = context.read<IconFactory>();
    final int pageIndex = context.select(
      (HomeBloc bloc) => bloc.state.currentPageIndex,
    );
    const List<String> pagesTitles = [
      'Czytanie',
      'Biblioteka',
      'Kalendarz',
    ];
    const List<Widget> pages = [
      ReadingScreen(),
      LibraryScreen(),
      CalendarScreen(),
    ];

    return widgetFactory.createScaffold(
      automaticallyImplyLeading: false,
      appBarTitle: pagesTitles[pageIndex],
      trailing: GestureDetector(
        onTap: () => _onSettingsPressed(context),
        child: iconFactory.createGearIcon(color: AppColors.black),
      ),
      bottomNavigationBar: BottomNavBar(
        items: [
          BottomNavigationBarItem(
            icon: iconFactory.createBookIcon(),
            label: 'Czytanie',
          ),
          BottomNavigationBarItem(
            icon: iconFactory.createLibraryIcon(),
            label: 'Biblioteka',
          ),
          BottomNavigationBarItem(
            icon: iconFactory.createCalendarIcon(),
            label: 'Kalendarz',
          ),
        ],
        selectedItemIndex: pageIndex,
        onItemPressed: (int pressedItemIndex) =>
            _onBottomNavigationBarItemPressed(pressedItemIndex, context),
      ),
      child: pages[pageIndex],
    );
  }
  
  void _onSettingsPressed(BuildContext context) {
    Navigation.navigateToSettings(context: context);
  }
  
  void _onBottomNavigationBarItemPressed(
    int pressedItemIndex,
    BuildContext context,
  ) {
    context.read<HomeBloc>().add(
          HomeEventChangePage(pageIndex: pressedItemIndex),
        );
  }
}
