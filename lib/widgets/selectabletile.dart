import 'package:flutter/material.dart';

class SelectableTile<T> extends StatelessWidget {
  final bool isSelected;
  final String text;
  final void Function() onTap;

  const SelectableTile({
    super.key,
    required this.isSelected,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 64,
        child: Row(
          children: [
            isSelected
                ? const SizedBox(width: 40, child: Icon(Icons.check))
                : const SizedBox(
                    width: 40,
                  ),
            Text(
              text,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }
}
