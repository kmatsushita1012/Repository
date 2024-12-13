import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final String value;

  const DetailCard(
      {super.key,
      required this.title,
      required this.iconData,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(16),
        child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1, 
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
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ],
            )));
  }
}
