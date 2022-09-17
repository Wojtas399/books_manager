import 'package:app/config/themes/app_colors.dart';
import 'package:flutter/widgets.dart';

class PagesProgressBarComponent extends StatelessWidget {
  final int readPagesAmount;
  final int allPagesAmount;
  final double height;
  final Color? progressBarColor;

  const PagesProgressBarComponent({
    super.key,
    required this.readPagesAmount,
    required this.allPagesAmount,
    this.height = 32,
    this.progressBarColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Stack(
        children: [
          _ProgressBar(
            percentage: _countPercentage(),
            height: height,
            progressBarColor: progressBarColor,
          ),
          _NumbersInfo(
            readPagesAmount: readPagesAmount,
            allPagesAmount: allPagesAmount,
          ),
        ],
      ),
    );
  }

  double _countPercentage() {
    if (allPagesAmount == 0) {
      return 0;
    }
    return readPagesAmount / allPagesAmount;
  }
}

class _NumbersInfo extends StatelessWidget {
  final int readPagesAmount;
  final int allPagesAmount;

  const _NumbersInfo({
    required this.readPagesAmount,
    required this.allPagesAmount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$readPagesAmount/$allPagesAmount',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double percentage;
  final double? height;
  final Color? progressBarColor;

  const _ProgressBar({
    required this.percentage,
    this.height,
    this.progressBarColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color? color = progressBarColor;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: (color ?? AppColors.primary).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double maxWidth = constraints.maxWidth;
          final double reversedPercentage = (percentage - 1) * (-1);
          final double rightPosition = reversedPercentage * maxWidth;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                right: rightPosition,
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: color ?? AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
