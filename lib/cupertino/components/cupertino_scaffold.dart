import 'package:flutter/cupertino.dart';

import '../../config/themes/app_colors.dart';

class CupertinoScaffold extends StatelessWidget {
  final Widget child;
  final bool withAppBar;
  final String? appBarTitle;
  final Color? appBarBackgroundColor;
  final bool appBarWithElevation;
  final Icon? leadingIcon;
  final bool automaticallyImplyLeading;

  const CupertinoScaffold({
    super.key,
    required this.child,
    this.withAppBar = true,
    this.appBarTitle,
    this.appBarBackgroundColor,
    this.appBarWithElevation = true,
    this.leadingIcon,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: withAppBar
          ? CupertinoNavigationBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
              backgroundColor: appBarBackgroundColor ?? AppColors.secondary,
              middle: Text(appBarTitle ?? ''),
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
            )
          : null,
      child: child,
    );
  }
}
