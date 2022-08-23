import 'package:flutter/material.dart';

import '../../models/bottom_nav_bar.dart';

class MaterialScaffold extends StatelessWidget {
  final Widget child;
  final bool withAppBar;
  final String? appBarTitle;
  final Color? appBarBackgroundColor;
  final bool appBarWithElevation;
  final Icon? leadingIcon;
  final Widget? trailing;
  final bool automaticallyImplyLeading;
  final BottomNavBar? bottomNavigationBar;

  const MaterialScaffold({
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
    final Icon? leadingIcon = this.leadingIcon;
    final Widget? trailing = this.trailing;

    return Scaffold(
      appBar: withAppBar
          ? AppBar(
              automaticallyImplyLeading: automaticallyImplyLeading,
              title: Text(appBarTitle ?? ''),
              centerTitle: true,
              backgroundColor: appBarBackgroundColor,
              elevation: appBarWithElevation == false ? 0 : null,
              leading: leadingIcon != null
                  ? _LeadingIcon(icon: leadingIcon)
                  : automaticallyImplyLeading
                      ? const _LeadingIcon(icon: Icon(Icons.close))
                      : null,
              actions: [
                trailing ?? const SizedBox(),
                const SizedBox(width: 12),
              ],
            )
          : null,
      bottomNavigationBar: bottomNavigationBar != null
          ? BottomNavigationBar(
              items: bottomNavigationBar.items,
              currentIndex: bottomNavigationBar.selectedItemIndex,
              onTap: bottomNavigationBar.onItemPressed,
            )
          : null,
      body: child,
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final Icon icon;

  const _LeadingIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: icon,
    );
  }
}
