import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repository/models/repository.dart';
import 'package:repository/page/settings.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:repository/widgets/detailtile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        return Container(
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
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              color: colorScheme.shadow.withOpacity(0.1),
                              spreadRadius: 5)
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 64, // Image radius
                        backgroundImage: NetworkImage(item.userIconPath),
                      )),
                ]),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withOpacity(0.1), // 影の色
                          blurRadius: 2, // ぼかし具合
                          offset: Offset(0, 2), // 影の位置
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
                                  "Language",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    item.language,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 32),
                                  )),
                            ],
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2, // 2列に設定
                    crossAxisSpacing: 8.0, // 列間のスペース
                    mainAxisSpacing: 8.0, // 行間のスペース
                    childAspectRatio: 1, // 各カードのアスペクト比（正方形）
                    children: [
                      DetailTile(
                          title: "Stars",
                          iconData: Icons.star,
                          value: item.stars.toString()),
                      DetailTile(
                          title: "Watchers",
                          iconData: Icons.visibility,
                          value: item.watchers.toString()),
                      DetailTile(
                          title: "Forks",
                          iconData: Icons.fork_right,
                          value: item.forks.toString()),
                      DetailTile(
                          title: "Issues",
                          iconData: Icons.priority_high,
                          value: item.stars.toString()),
                    ],
                  ),
                )
              ],
            ));
      }),
    );
  }
}
