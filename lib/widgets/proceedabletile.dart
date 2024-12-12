import 'package:flutter/material.dart';

class ProceedableTile extends StatelessWidget {
  final String text;
  final void Function(BuildContext) onTap;

  const ProceedableTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 50,
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 18),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios)
          ],
        ),
      ),
      onTap: () => onTap(context),
    );
  }
}
