import 'package:flutter/widgets.dart';

import '../../models/bottom_nav_bar.dart';

abstract class WidgetFactory {
  Widget createApp({
    required String title,
    required Widget home,
  });

  Widget createScaffold({
    required Widget child,
    String? appBarTitle,
    bool withAppBar = true,
    Color? appBarBackgroundColor,
    bool appBarWithElevation = true,
    Icon? leadingIcon,
    Widget? trailing,
    bool automaticallyImplyLeading = true,
    BottomNavBar? bottomNavigationBar,
  });

  Widget createTextFormField({
    String? placeholder,
    Icon? icon,
    Color? backgroundColor,
    bool isPassword = false,
    bool isRequired = false,
    TextInputType? keyboardType,
    String? Function(String? value)? validator,
    Function(String)? onChanged,
  });

  Widget createButton({
    required String label,
    required VoidCallback? onPressed,
  });
}
