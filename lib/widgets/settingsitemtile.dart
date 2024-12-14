import 'package:flutter/material.dart';

class SettingsItemtile extends StatelessWidget {
  final String text;
  final double height;
  final void Function(BuildContext) onTap;

  const SettingsItemtile(
      {super.key, required this.text, required this.onTap, this.height = 64});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
          height: height,
          child: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              // border: Border.all(color: colorScheme.surface),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: Offset(0, 4),
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