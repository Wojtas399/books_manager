import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SearchFieldComponent extends StatefulWidget {
  final Function(String value)? onChanged;

  const SearchFieldComponent({super.key, this.onChanged});

  @override
  State<SearchFieldComponent> createState() => _SearchFieldComponentState();
}

class _SearchFieldComponentState extends State<SearchFieldComponent> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          suffixIcon: _CleanIcon(
            isShowed: _controller.text.isNotEmpty,
            onPressed: _onCleanIconPressed,
          ),
          prefixIcon: const Icon(MdiIcons.magnify),
          hintText: 'Szukaj...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.all(4),
        ),
        onChanged: (_) => _onChanged(),
      ),
    );
  }

  void _onChanged() {
    _emitNewSearchValue();
    setState(() {});
  }

  void _onCleanIconPressed() {
    _controller.text = '';
    _emitNewSearchValue();
    setState(() {});
  }

  void _emitNewSearchValue() {
    final Function(String value)? onChanged = widget.onChanged;
    if (onChanged != null) {
      onChanged(_controller.text);
    }
  }
}

class _CleanIcon extends StatefulWidget {
  final bool isShowed;
  final VoidCallback? onPressed;

  const _CleanIcon({
    this.isShowed = false,
    this.onPressed,
  });

  @override
  State<_CleanIcon> createState() => _CleanIconState();
}

class _CleanIconState extends State<_CleanIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didUpdateWidget(_CleanIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isShowed) {
      _animationController.forward();
    } else {
      _animationController.animateBack(0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        onPressed: widget.onPressed,
        icon: const Icon(MdiIcons.close),
        splashRadius: 10,
      ),
    );
  }
}
