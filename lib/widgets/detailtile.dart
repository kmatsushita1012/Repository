import 'package:flutter/material.dart';

class DetailTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final String value;

  const DetailTile(
      {super.key,
      required this.title,
      required this.iconData,
      required this.value});
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ]),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(
                    Icons.language,
                    size: constraints.maxWidth * 0.6,
                  ),
                );
              },
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      softWrap: true,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        value,
                        softWrap: true,
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 32),
                      )),
                ],
              ))
        ],
      ),
    );
  }
}
