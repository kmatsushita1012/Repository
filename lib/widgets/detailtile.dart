import 'package:flutter/material.dart';

//言語用のタイル
class DetailTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final String value;
  final Animation<double> animation;

  const DetailTile(
      {super.key,
      required this.title,
      required this.iconData,
      required this.value,
      required this.animation});

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(31),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ]),
      child: Row(
        children: [
          //アイコン
          Expanded(
            flex: 2,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Align(
                    alignment: Alignment.centerLeft,
                    child: FadeTransition(
                      opacity: animation,
                      child: Icon(
                        Icons.language,
                        size: constraints.maxWidth * 0.6,
                      ),
                    ));
              },
            ),
          ),
          Expanded(
              flex: 3,
              child: Column(
                children: [
                  //タイトル
                  Align(
                      alignment: Alignment.centerLeft,
                      child: FadeTransition(
                        opacity: animation,
                        child: Text(
                          title,
                          softWrap: true,
                          style: TextStyle(fontSize: 24),
                        ),
                      )),
                  //言語名
                  Align(
                      alignment: Alignment.centerLeft,
                      child: FadeTransition(
                          opacity: animation,
                          child: Text(
                            value,
                            softWrap: true,
                            style: TextStyle(fontSize: 32),
                          ))),
                ],
              ))
        ],
      ),
    );
  }
}
