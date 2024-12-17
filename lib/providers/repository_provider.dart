import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:repository/models/repository.dart';
import 'package:repository/models/sorttypes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//レポジトリ関連のプロバイダ
class RepositoryProvider extends ChangeNotifier {
  //クエリ
  String _query = "";
  //ソート方法
  SortTypes _sortType = SortTypes.match;
  //レスポンス
  List<Repository> _items = [];
  //通信中か否か(インディケーター用)
  bool _isLoading = false;
  //現在のページ(追加読み込みで+1)
  int _page = 1;

  String get query => _query;
  SortTypes get sortType => _sortType;
  bool get isLoading => _isLoading;
  int get count => _items.length;
  int get page => _page;

  Repository getRepository(int index) {
    return _items[index];
  }

  Future<void> setQuery(String query, void Function(int) errorHandler) async {
    _query = query;
    _clear();
    await _callAPI(errorHandler);
  }

  Future<void> setSortType(
      SortTypes sortType, void Function(int) errorHandler) async {
    _sortType = sortType;
    _clear();
    await _callAPI(errorHandler);
  }

  Future<void> getMoreRepositories(void Function(int) errorHandler) async {
    _sortType = sortType;
    _page += 1;
    await _callAPI(errorHandler);
  }
  //レスポンスをクリア
  void _clear() {
    _items = [];
    _page = 1;
  }
  //APIツウシン
  Future<void> _callAPI(void Function(int) errorHandler) async {
    _isLoading = true;
    notifyListeners();

    final http.Client client = GetIt.I<http.Client>();
    final sort = sortType.toQueryString();
    final response = await client.get(Uri.https(
      "api.github.com",
      "/search/repositories",
      sort != null
          ? {'q': query, 'sort': sort, 'page': page.toString()}
          : {'q': query, 'page': page.toString()},
    ));

    _isLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      //正常な処理
      dynamic responseBody = utf8.decode(response.bodyBytes);
      dynamic parsedJson = jsonDecode(responseBody);
      for (var elem in parsedJson["items"]) {
        try {
          Repository item = Repository.fromSearhRepositoryItem(elem);
          _items.add(item);
        } catch (e) {
          continue;
        }
      }
    } else {
      //エラー時
      _query = "";
      errorHandler(response.statusCode);
    }
    notifyListeners();
  }
}
