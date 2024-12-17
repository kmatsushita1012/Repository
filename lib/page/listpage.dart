import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repository/models/sorttypes.dart';
import 'package:repository/page/detailpage.dart';
import 'package:repository/page/settingspage.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:repository/widgets/myalertdialog.dart';
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
    //追加読み込みを設定
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        context.read<RepositoryProvider>().getMoreRepositories(
            onSuccess: (_) => _onSuccess(context),
            onError: (value) => _onErrpr(context, value));
      }
    });
  }

  //クエリ入力時
  void _onSubmitted(BuildContext context, String value) {
    final provider = context.read<RepositoryProvider>();
    provider.setQuery(value,
        onSuccess: (_) => _onSuccess(context),
        onError: (value) => _onErrpr(context, value));
  }

  //ソート方法選択時
  void _onSelected(BuildContext context, SortTypes value) {
    final provider = context.read<RepositoryProvider>();
    provider.setSortType(value,
        onSuccess: (_) => _onSuccess(context),
        onError: (value) => _onErrpr(context, value));
  }

  void _onSuccess(BuildContext context) {
    if (context.read<RepositoryProvider>().count == 0) {
      showDialog(
          context: context,
          builder: (_) => MyAlertDialog(
              title: AppLocalizations.of(context)!.notice,
              message: AppLocalizations.of(context)!.no_results));
    }
  }

  //エラー用コールバック
  void _onErrpr(BuildContext context, int statusCode) {
    late String message;
    if (statusCode == 422) {
      message = AppLocalizations.of(context)!.invalid_query;
    } else {
      message = AppLocalizations.of(context)!.http_error;
    }
    showDialog(
        context: context,
        builder: (_) => MyAlertDialog(
            title: AppLocalizations.of(context)!.error, message: message));
  }

  //ListViewのアイテムビルダー
  Widget _buildItem(BuildContext contex, int index) {
    RepositoryProvider provider = context.read<RepositoryProvider>();
    //読み込み中はアイテム数+1を生成し末端はインディケーター
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
      //インディケーター
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  //FloatingActionButtonで上に戻る
  void _scrollTop() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Consumer<RepositoryProvider>(
      builder: (context, provider, _) => Scaffold(
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
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    spacing: 8,
                    children: [
                      //クエリのテキストフィールド
                      Expanded(
                          child: QueryField(
                        onSubmitted: (value) => _onSubmitted(context, value),
                      )),
                      //ソート方法選択ボタン
                      SizedBox(
                          width: 48,
                          height: 48,
                          child: SortButton(
                            onSelected: (value) => _onSelected(context, value),
                          )),
                    ],
                  )),
              //リストビュー
              Expanded(
                  child: Padding(
                padding: EdgeInsets.all(8),
                child: provider.count != 0 || provider.isLoading
                    ? ListView.builder(
                        controller: _scrollController,
                        //読み込み中はインディケーターのために1つ増やす
                        itemCount:
                            provider.count + (provider.isLoading ? 1 : 0),
                        itemBuilder: _buildItem)
                    //アイテムがない時のプレースホルダー
                    : Text(AppLocalizations.of(context)!.empty_list),
              ))
            ],
          ),
          //先頭に戻る時
          floatingActionButton: provider.count != 0
              ? FloatingActionButton(
                  onPressed: _scrollTop,
                  child: Icon(Icons.arrow_upward),
                )
              : null),
    );
  }
}
