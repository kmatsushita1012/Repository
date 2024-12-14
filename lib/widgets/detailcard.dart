import 'package:countup/countup.dart';
import 'package:flutter/material.dart';

class DetailCard extends StatefulWidget {
  final String title;
  final IconData iconData;
  final int value;

  const DetailCard(
      {super.key,
      required this.title,
      required this.iconData,
      required this.value});
  @override
  _DetailCardState createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> with TickerProviderStateMixin {
  double opacityLevel = 1.0;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                              child: FadeTransition(
                            opacity: _animation,
                            child: Icon(
                              widget.iconData,
                              size: constraints.maxWidth * 0.9,
                            ),
                          ));
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
                  child: FadeTransition(
                      opacity: _animation,
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 24),
                      )),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Countup(
                    begin: 0,
                    end: widget.value.toDouble(),
                    duration: Duration(seconds: 1),
                    separator: ',',
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                ),
              ],
            )));
  }
}
