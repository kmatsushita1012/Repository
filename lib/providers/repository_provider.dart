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

  Future<void> setQuery(String query, void Function(int) errorHandler) async {
    _query = query;
    _clear();
    await _getRepositories(errorHandler);
  }

  Future<void> setSortType(
      SortTypes sortType, void Function(int) errorHandler) async {
    _sortType = sortType;
    _clear();
    await _getRepositories(errorHandler);
  }

  Future<void> getMoreRepositories(void Function(int) errorHandler) async {
    _sortType = sortType;
    page += 1;
    await _getRepositories(errorHandler);
  }

  void _clear() {
    _items = [];
    page = 1;
  }

  Future<void> _getRepositories(void Function(int) errorHandler) async {
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
    } else {
      errorHandler(response.statusCode);
    }
    notifyListeners();
  }
}
