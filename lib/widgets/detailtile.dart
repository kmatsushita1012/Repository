import 'package:flutter/material.dart';

class DetailTile extends StatelessWidget {
  final String title;
  final Icon icon;
  final String value;

  const DetailTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.value});

  @override
  Widget build(BuildContext context) {
    // Provider.of<T>(context) で親Widgetからデータを受け取る
    // ※ 受け取るデータの クラス と <T> は揃えましょう

    return Container(
        height: 64,
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            children: [
              icon,
              const SizedBox(
                width: 16,
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(fontSize: 18),
              )
            ],
          ),
        ));
  }
}
