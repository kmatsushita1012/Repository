import 'package:flutter/material.dart';

class ProceedableTile extends StatelessWidget {
  final String text;
  final void Function(BuildContext) onTap;

  const ProceedableTile({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
          height: 64,
          child: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              // border: Border.all(color: colorScheme.surface),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), // 影の色
                  blurRadius: 2, // ぼかし具合
                  offset: Offset(0, 4), // 影の位置
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
                )),
                const SizedBox(
                  width: 16,
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
          )),
      onTap: () => onTap(context),
    );
  }
}
