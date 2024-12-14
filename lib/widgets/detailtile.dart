import 'package:flutter/material.dart';

class DetailTile extends StatefulWidget {
  final String title;
  final IconData iconData;
  final String value;

  const DetailTile(
      {super.key,
      required this.title,
      required this.iconData,
      required this.value});
  @override
  _DetailTileState createState() => _DetailTileState();
}

class _DetailTileState extends State<DetailTile> with TickerProviderStateMixin {
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
                    child: FadeTransition(
                      opacity: _animation,
                      child: Icon(
                        Icons.language,
                        size: constraints.maxWidth * 0.6,
                      ),
                    ));
              },
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: FadeTransition(
                        opacity: _animation,
                        child: Text(
                          widget.title,
                          softWrap: true,
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 24),
                        ),
                      )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: FadeTransition(
                          opacity: _animation,
                          child: Text(
                            widget.value,
                            softWrap: true,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 32),
                          ))),
                ],
              ))
        ],
      ),
    );
  }
}
