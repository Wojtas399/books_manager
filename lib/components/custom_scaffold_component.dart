import 'package:app/extensions/navigator_build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final IconData? leadingIcon;
  final String? appBarTitle;
  final bool appBarWithElevation;
  final Color? appBarColor;
  final Color? foregroundColor;
  final bool automaticallyImplyLeading;
  final Widget? trailing;
  final double? trailingRightPadding;
  final Widget? bottomNavigationBar;
  final FloatingActionButton? floatingActionButton;
  final bool resizeToAvoidBottomInset;

  const CustomScaffold({
    super.key,
    required this.body,
    this.leadingIcon,
    this.appBarTitle,
    this.appBarWithElevation = true,
    this.appBarColor,
    this.foregroundColor,
    this.automaticallyImplyLeading = true,
    this.trailing,
    this.trailingRightPadding,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    final IconData? leadingIcon = this.leadingIcon;

    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: _AppBar(
        appBarTitle: appBarTitle,
        appBarColor: appBarColor,
        foregroundColor: foregroundColor,
        appBarWithElevation: appBarWithElevation,
        automaticallyImplyLeading: automaticallyImplyLeading,
        leadingIcon: leadingIcon,
        trailing: trailing,
        trailingRightPadding: trailingRightPadding,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}

class _AppBar extends StatelessWidget with PreferredSizeWidget {
  final String? appBarTitle;
  final Color? appBarColor;
  final Color? foregroundColor;
  final bool appBarWithElevation;
  final bool automaticallyImplyLeading;
  final IconData? leadingIcon;
  final Widget? trailing;
  final double? trailingRightPadding;

  const _AppBar({
    this.appBarTitle,
    this.appBarColor,
    this.foregroundColor,
    this.appBarWithElevation = true,
    this.automaticallyImplyLeading = true,
    this.leadingIcon,
    this.trailing,
    this.trailingRightPadding,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final IconData? leadingIcon = this.leadingIcon;

    return AppBar(
      title: Text(appBarTitle ?? ''),
      leading: _LeadingIcon(
        leadingIcon: leadingIcon,
        automaticallyImplyLeading: automaticallyImplyLeading,
      ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      actions: [
        trailing ?? const SizedBox(),
        SizedBox(width: trailingRightPadding ?? 8),
      ],
      elevation: appBarWithElevation ? 2 : 0,
      backgroundColor: appBarColor,
      foregroundColor: foregroundColor,
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final IconData? leadingIcon;
  final bool automaticallyImplyLeading;

  const _LeadingIcon({
    this.leadingIcon,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    return automaticallyImplyLeading
        ? IconButton(
            splashRadius: 24,
            onPressed: () => _onLeadingIconPressed(context),
            icon: _createLeadingIcon(),
          )
        : const SizedBox();
  }

  Icon _createLeadingIcon() {
    return Icon(leadingIcon ?? MdiIcons.arrowLeft);
  }

  void _onLeadingIconPressed(BuildContext context) {
    context.navigateBack();
  }
}
