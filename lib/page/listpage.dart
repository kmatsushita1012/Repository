import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repository/page/detailpage.dart';
import 'package:repository/page/settingspage.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:repository/widgets/proceedabletile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:repository/widgets/queryfield.dart';
import 'package:repository/widgets/sortbutton.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<RepositoryProvider>().getMoreRepositories();
      }
    });
  }

  Widget _buildItem(BuildContext contex, int index) {
    RepositoryProvider provider = context.read<RepositoryProvider>();
    if (index < provider.count) {
      return ProceedableTile(
        text: provider.getRepository(index).name,
        onTap: (context) => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
                      index: index,
                    ))),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.list,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          actions: [
            IconButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage())),
                icon: const Icon(Icons.settings))
          ],
        ),
        body: Consumer<RepositoryProvider>(
          builder: (context, provider, _) => Container(
            margin: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: QueryField()),
                    const SizedBox(
                      width: 16,
                    ),
                    SizedBox(width: 48, height: 48, child: SortButton()),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: provider.count + (provider.isLoading ? 1 : 0),
                      itemBuilder: _buildItem),
                ),
              ],
            ),
          ),
        ));
  }
}