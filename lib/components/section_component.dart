import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config/themes/app_colors.dart';
import '../interfaces/factories/text_factory_interface.dart';

class SectionComponent extends StatelessWidget {
  final String sectionName;
  final Widget child;
  final bool withBottomDivider;

  const SectionComponent({
    super.key,
    required this.sectionName,
    required this.child,
    this.withBottomDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.grey.withOpacity(withBottomDivider ? 0.2 : 0),
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: withBottomDivider ? 32 : 0),
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          Row(
            children: [
              _SectionName(sectionName: sectionName),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _SectionName extends StatelessWidget {
  final String sectionName;

  const _SectionName({required this.sectionName});

  @override
  Widget build(BuildContext context) {
    final textFactory = context.read<TextFactoryInterface>();
    return textFactory.createSubtitleText(
      text: sectionName,
      context: context,
    );
  }
}
