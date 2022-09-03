import 'package:app/components/custom_button.dart';
import 'package:flutter/widgets.dart';

class BookPreviewButton extends StatelessWidget {
  const BookPreviewButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: CustomButton(
        label: 'Rozpocznij czytanie',
        onPressed: () {},
      ),
    );
  }
}
