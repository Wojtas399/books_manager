import 'package:flutter/material.dart';

class EmptyContentInfoComponent extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final String? subtitle;

  const EmptyContentInfoComponent({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    Color? color =
        Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.3);
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null ? Icon(icon, size: 48, color: color) : const SizedBox(),
          SizedBox(height: icon != null ? 16 : 0),
          title != null
              ? Text(
                  title!,
                  style: TextStyle(
                    fontSize: 20,
                    color: color,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                  textAlign: TextAlign.center,
                )
              : const SizedBox(),
          SizedBox(height: title != null ? 8 : 0),
          subtitle != null
              ? Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 16,
                    color: color,
                    letterSpacing: 0.15,
                  ),
                  textAlign: TextAlign.center,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
