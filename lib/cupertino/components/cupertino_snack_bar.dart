import 'package:flutter/cupertino.dart';

class CupertinoSnackBar extends StatefulWidget {
  final String message;

  const CupertinoSnackBar({
    super.key,
    required this.message,
  });

  @override
  State<CupertinoSnackBar> createState() => _CupertinoSnackBarState();
}

class _CupertinoSnackBarState extends State<CupertinoSnackBar> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => setState(() => _show = true));
    Future.delayed(
      const Duration(milliseconds: 4000),
      () {
        if (mounted) {
          setState(() => _show = false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          AnimatedPositioned(
            bottom: _show ? 8.0 : -50.0,
            left: 8.0,
            right: 8.0,
            curve: _show ? Curves.linearToEaseOut : Curves.easeInToLinear,
            duration: const Duration(milliseconds: 250),
            child: CupertinoPopupSurface(
              child: Container(
                color: CupertinoColors.black.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    widget.message,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: CupertinoColors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
