import 'package:app/components/shimmer.dart';
import 'package:app/components/shimmer_loading.dart';
import 'package:app/features/reading/components/reading_book_item_skeleton.dart';
import 'package:app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReadingShimmerLoading extends StatelessWidget {
  const ReadingShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkModeOn = context.select(
      (ThemeProvider themeProvider) => themeProvider.isDarkModeOn(context),
    );

    return Shimmer(
      isDarkMode: isDarkModeOn,
      child: ListView.builder(
        itemCount: 4,
        padding: const EdgeInsets.all(12),
        itemBuilder: (_, int index) {
          return const ReadingBookItemSkeleton(
            imageBody: _ShimmerImage(),
            descriptionBody: _ShimmerDescription(),
          );
        },
      ),
    );
  }
}

class _ShimmerImage extends StatelessWidget {
  const _ShimmerImage();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        color: Colors.white,
      ),
    );
  }
}

class _ShimmerDescription extends StatelessWidget {
  const _ShimmerDescription();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _ShimmerTitle(),
        SizedBox(height: 4),
        _ShimmerAuthor(),
        SizedBox(height: 16),
        _ShimmerStatusOfPages(),
      ],
    );
  }
}

class _ShimmerTitle extends StatelessWidget {
  const _ShimmerTitle();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class _ShimmerAuthor extends StatelessWidget {
  const _ShimmerAuthor();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        height: 14,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}

class _ShimmerStatusOfPages extends StatelessWidget {
  const _ShimmerStatusOfPages();

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        height: 20,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
