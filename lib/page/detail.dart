import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repository/models/repository.dart';
import 'package:repository/page/settings.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:repository/widgets/detailcard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:repository/widgets/detailtile.dart';

class DetailPage extends StatelessWidget {
  final int index;

  const DetailPage({super.key, required this.index});

  void _trailingPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsPage()));
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
        Repository item = model.items[index];
        return SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(
                          item.name,
                          softWrap: true,
                          style: const TextStyle(
                              fontSize: 48, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 2,
                                  color: colorScheme.shadow.withOpacity(0.1),
                                  spreadRadius: 5)
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(item.userIconPath),
                          )),
                    ]),
                    const SizedBox(
                      height: 16,
                    ),
                    DetailTile(
                        title: "Language",
                        iconData: Icons.language,
                        value: item.language.toString()),
                    SizedBox(
                      height: MediaQuery.of(context).size.width,
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 1,
                        shrinkWrap: false,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          DetailCard(
                              title: "Stars",
                              iconData: Icons.star,
                              value: item.stars.toString()),
                          DetailCard(
                              title: "Watchers",
                              iconData: Icons.visibility,
                              value: item.watchers.toString()),
                          DetailCard(
                              title: "Forks",
                              iconData: Icons.fork_right,
                              value: item.forks.toString()),
                          DetailCard(
                              title: "Issues",
                              iconData: Icons.priority_high,
                              value: item.stars.toString()),
                        ],
                      ),
                    )
                  ],
                )));
      }),
    );
  }
}
