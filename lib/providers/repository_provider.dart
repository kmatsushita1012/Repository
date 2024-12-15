import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:repository/models/repository.dart';
import 'package:repository/models/sorttypes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RepositoryProvider extends ChangeNotifier {
  String _query = "";
  SortTypes _sortType = SortTypes.match;
  List<Repository> _items = [];
  bool _isLoading = false;
  int page = 1;
  String get query => _query;
  SortTypes get sortType => _sortType;
  bool get isLoading => _isLoading;
  int get count => _items.length;

  Repository getRepository(int index) {
    return _items[index];
  }

  Future<void> setQuery(String query) async {
    _query = query;
    await _clearAndGetRepositories();
  }

  Future<void> setSortType(SortTypes sortType) async {
    _sortType = sortType;
    await _clearAndGetRepositories();
  }

  Future<void> getMoreRepositories() async {
    _sortType = sortType;
    page += 1;
    await _getRepositories();
  }

  Future<void> _clearAndGetRepositories() async {
    _items = [];
    page = 1;
    await _getRepositories();
  }

  Future<void> _getRepositories() async {
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
    }
    notifyListeners();
  }
}
