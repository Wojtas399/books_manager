import 'package:flutter/cupertino.dart';

import '../../config/themes/app_colors.dart';
import '../../models/bottom_nav_bar.dart';

class CupertinoScaffold extends StatelessWidget {
  final Widget child;
  final bool withAppBar;
  final String? appBarTitle;
  final Color? appBarBackgroundColor;
  final bool appBarWithElevation;
  final Icon? leadingIcon;
  final Widget? trailing;
  final bool automaticallyImplyLeading;
  final BottomNavBar? bottomNavigationBar;

  const CupertinoScaffold({
    super.key,
    required this.child,
    this.withAppBar = true,
    this.appBarTitle,
    this.appBarBackgroundColor,
    this.appBarWithElevation = true,
    this.leadingIcon,
    this.trailing,
    this.automaticallyImplyLeading = true,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final BottomNavBar? bottomNavigationBar = this.bottomNavigationBar;

    return CupertinoPageScaffold(
      navigationBar: withAppBar
          ? CupertinoNavigationBar(
              automaticallyImplyLeading: automaticallyImplyLeading,
              backgroundColor: appBarBackgroundColor ?? AppColors.secondary,
              middle: Text(
                appBarTitle ?? '',
                style: const TextStyle(color: CupertinoColors.black),
              ),
              border: appBarWithElevation == false
                  ? Border.all(color: AppColors.transparent)
                  : null,
              leading: leadingIcon != null
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        leadingIcon?.icon,
                        color: AppColors.black,
                        size: 24,
                      ),
                    )
                  : null,
              trailing: trailing,
            )
          : null,
      child: bottomNavigationBar != null
          ? _CupertinoBottomNavigationBar(
              bottomNavigationBar: bottomNavigationBar,
              page: child,
            )
          : child,
    );
  }
}

class _CupertinoBottomNavigationBar extends StatelessWidget {
  final BottomNavBar bottomNavigationBar;
  final Widget page;

  const _CupertinoBottomNavigationBar({
    required this.bottomNavigationBar,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: bottomNavigationBar.selectedItemIndex,
        items: bottomNavigationBar.items,
        onTap: bottomNavigationBar.onItemPressed,
        backgroundColor: AppColors.secondary,
        inactiveColor: CupertinoColors.black.withOpacity(0.3),
        activeColor: CupertinoColors.black,
      ),
      tabBuilder: (_, int index) {
        return page;
      },
    );
  }
}
