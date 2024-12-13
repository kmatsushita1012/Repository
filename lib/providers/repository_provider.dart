import 'package:flutter/foundation.dart';
import 'package:repository/models/repository.dart';
import 'package:repository/models/sorttypes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RepositoryProvider extends ChangeNotifier {
  String query = "";
  SortTypes sortType = SortTypes.updated;
  List<Repository> items = [];
  bool isLoading = false;

  void setText(String text) {
    this.query = text;
    items = [];
    getRepositories(1);
    notifyListeners();
  }

  void setSortType(SortTypes sortType) {
    this.sortType = sortType;
    items = [];
    getRepositories(1);
    notifyListeners();
  }

  void getRepositories(int page) {
    isLoading = true;
    notifyListeners();
    http
        .get(Uri.https(
      "api.github.com",
      "/search/repositories",
      {'q': query, 'sort': sortType.toString(), 'page': page.toString()},
    ))
        .then((response) {
      if (response.statusCode == 200) {
        dynamic responseBody = utf8.decode(response.bodyBytes);
        dynamic parsedJson = jsonDecode(responseBody);
        for (var elem in parsedJson["items"]) {
          try {
            Repository item = Repository.fromSearhRepositoryItem(elem);
            items.add(item);
          } catch (e) {
            print("parse error ${e}");
            continue;
          }
        }
      }
      isLoading = false;
      notifyListeners();
    });
  }
}
