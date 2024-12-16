import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repository/models/repository.dart';
import 'package:repository/page/settingspage.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:repository/widgets/detailcard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:repository/widgets/detailtile.dart';

class DetailPage extends StatefulWidget {
  final int index;

  const DetailPage({super.key, required this.index});
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  double opacityLevel = 1.0;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
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

  void _trailingPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsPage()));
  }

  Widget _lineupTwoWidget(Orientation orientation, Widget upper, Widget lower) {
    return orientation == Orientation.portrait
        ? Column(
            children: [upper, lower],
          )
        : Row(
            children: [
              Expanded(flex: 1, child: upper),
              Expanded(flex: 1, child: lower)
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.detail,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: colorScheme.onPrimary,
        backgroundColor: colorScheme.primary,
        actions: [
          IconButton(
              onPressed: () => _trailingPressed(context),
              icon: const Icon(Icons.settings))
        ],
      ),
      body: Consumer<RepositoryProvider>(builder: (context, model, _) {
        Repository item = model.getRepository(widget.index);
        return SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(children: [
                      Expanded(
                          child: FadeTransition(
                        opacity: _animation,
                        child: Text(
                          item.name,
                          softWrap: true,
                          style: const TextStyle(
                              fontSize: 48, fontWeight: FontWeight.bold),
                        ),
                      )),
                      const SizedBox(width: 16),
                      FadeTransition(
                          opacity: _animation,
                          child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 2,
                                      color: colorScheme.shadow.withAlpha(31),
                                      spreadRadius: 5)
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 48,
                                backgroundImage:
                                    NetworkImage(item.userIconPath),
                              ))),
                    ]),
                    const SizedBox(
                      height: 16,
                    ),
                    _lineupTwoWidget(
                        MediaQuery.of(context).orientation,
                        DetailTile(
                          title: AppLocalizations.of(context)!.language,
                          iconData: Icons.language,
                          value: item.language ??
                              AppLocalizations.of(context)!.unset,
                          animation: _animation,
                        ),
                        AspectRatio(
                          // height: MediaQuery.of(context).size.width,
                          aspectRatio: 1,
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 1.0,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              DetailCard(
                                title: AppLocalizations.of(context)!.stars,
                                iconData: Icons.star,
                                value: item.stars,
                                animation: _animation,
                              ),
                              DetailCard(
                                title: AppLocalizations.of(context)!.wathcers,
                                iconData: Icons.visibility,
                                value: item.watchers,
                                animation: _animation,
                              ),
                              DetailCard(
                                title: AppLocalizations.of(context)!.forks,
                                iconData: Icons.fork_right,
                                value: item.forks,
                                animation: _animation,
                              ),
                              DetailCard(
                                title: AppLocalizations.of(context)!.issues,
                                iconData: Icons.adjust,
                                value: item.stars,
                                animation: _animation,
                              ),
                            ],
                          ),
                        ))
                  ],
                )));
      }),
    );
  }
}
