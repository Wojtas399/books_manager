import 'package:flutter/material.dart';

class MaterialScaffold extends StatelessWidget {
  final Widget child;
  final bool withAppBar;
  final String? appBarTitle;
  final Color? appBarBackgroundColor;
  final bool appBarWithElevation;
  final Icon? leadingIcon;

  const MaterialScaffold({
    super.key,
    required this.child,
    this.withAppBar = true,
    this.appBarTitle,
    this.appBarBackgroundColor,
    this.appBarWithElevation = true,
    this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: withAppBar
          ? AppBar(
              title: Text(appBarTitle ?? ''),
              centerTitle: true,
              backgroundColor: appBarBackgroundColor,
              elevation: appBarWithElevation == false ? 0 : null,
              leading: leadingIcon != null
                  ? GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: leadingIcon,
                    )
                  : null,
            )
          : null,
      body: child,
    );
  }
}
