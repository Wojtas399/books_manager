import 'package:flutter/material.dart';

class ReadingBookItemSkeleton extends StatelessWidget {
  final Widget imageBody;
  final Widget descriptionBody;
  final VoidCallback? onPressed;

  const ReadingBookItemSkeleton({
    super.key,
    required this.imageBody,
    required this.descriptionBody,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Stack(
          children: [
            _DescriptionSkeleton(
              descriptionBody: descriptionBody,
            ),
            _ImageSkeleton(
              imageBody: imageBody,
            ),
          ],
        ),
      ),
    );
  }
}

class _DescriptionSkeleton extends StatelessWidget {
  final Widget descriptionBody;

  const _DescriptionSkeleton({required this.descriptionBody});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Card(
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(128, 16, 16, 16),
          child: descriptionBody,
        ),
      ),
    );
  }
}

class _ImageSkeleton extends StatelessWidget {
  final Widget imageBody;

  const _ImageSkeleton({required this.imageBody});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 120,
          height: 160,
          child: imageBody,
        ),
      ),
    );
  }
}
