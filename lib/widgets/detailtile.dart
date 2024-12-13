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
    // Provider.of<T>(context) で親Widgetからデータを受け取る
    // ※ 受け取るデータの クラス と <T> は揃えましょう

    return Card(
        margin: const EdgeInsets.all(16),
        child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1, // 左半分をアイコン領域に
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Center(
                            child: Icon(
                              iconData,
                              size: constraints.maxWidth * 0.9,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1, // 右半分を空の領域に
                      child: Container(),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ],
            )));
  }
}
