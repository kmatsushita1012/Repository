import 'package:flutter/material.dart';

class SelectableTile<T> extends StatelessWidget {
  final bool isSelected;
  final String text;
  final double height;
  final void Function() onTap;

  const SelectableTile({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onTap,
    this.height = 64,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            isSelected
                ? const SizedBox(width: 40, child: Icon(Icons.check))
                : const SizedBox(
                    width: 40,
                  ),
            Expanded(
                child: Text(
              text,
              softWrap: true,
              style: const TextStyle(fontSize: 18),
            ))
          ],
        ),
      ),
    );
  }
}
