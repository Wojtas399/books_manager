import 'package:app/extensions/navigator_build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../components/custom_scaffold_component.dart';
import '../../calendar/calendar_screen.dart';
import '../../library/library_screen.dart';
import '../../reading/reading_screen.dart';
import '../home_cubit.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final int pageIndex = context.select(
      (HomeCubit cubit) => cubit.state,
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

    return CustomScaffold(
      automaticallyImplyLeading: false,
      appBarTitle: pagesTitles[pageIndex],
      trailing: IconButton(
        splashRadius: 24,
        onPressed: () => _onSettingsPressed(context),
        icon: const Icon(MdiIcons.cog),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.bookOpen),
            label: 'Czytanie',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.bookshelf),
            label: 'Biblioteka',
          ),
          BottomNavigationBarItem(
            icon: Icon(MdiIcons.calendarMonth),
            label: 'Kalendarz',
          ),
        ],
        currentIndex: pageIndex,
        onTap: (int pressedItemIndex) =>
            _onBottomNavigationBarItemPressed(pressedItemIndex, context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onFloatingActionButtonPressed(context),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
      ),
      body: pages[pageIndex],
    );
  }

  void _onSettingsPressed(BuildContext context) {
    context.navigateToSettings();
  }

  void _onBottomNavigationBarItemPressed(
    int pressedItemIndex,
    BuildContext context,
  ) {
    context.read<HomeCubit>().changePage(pressedItemIndex);
  }

  void _onFloatingActionButtonPressed(BuildContext context) {
    context.navigateToBookCreator();
  }
}
