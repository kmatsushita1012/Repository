import 'package:flutter/material.dart';

//リストの階層構造タイル　[Title　>]
class ProceedableTile extends StatefulWidget {
  final String text;
  final double height;
  final void Function(BuildContext) onTap;

  const ProceedableTile({
    super.key,
    required this.text,
    required this.onTap,
    this.height = 72,
  });
  @override
  _ProceedableTileState createState() => _ProceedableTileState();
}

class _ProceedableTileState extends State<ProceedableTile> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
          height: widget.height,
          child: Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(31),
                  blurRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                //タイトル
                Expanded(
                    child: Text(
                  widget.text,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
                )),
                const SizedBox(
                  width: 16,
                ),
                // >のアイコン
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
          )),
      onTap: () => widget.onTap(context),
    );
  }
}
