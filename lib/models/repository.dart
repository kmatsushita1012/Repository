//レポジトリの検索結果を格納
class Repository {
  final String name;
  final String userIconPath;
  final String? language;
  final int stars;
  final int watchers;
  final int forks;
  final int issues;

  Repository(
      {required this.name,
      required this.userIconPath,
      required this.language,
      required this.stars,
      required this.watchers,
      required this.forks,
      required this.issues});
      
  //JSON形式からのパーサー
  factory Repository.fromSearhRepositoryItem(dynamic item) {
    return Repository(
        name: item["name"],
        userIconPath: item["owner"]["avatar_url"],
        language: item["language"],
        stars: item["stargazers_count"],
        watchers: item["watchers"],
        forks: item["forks"],
        issues: item["open_issues"]);
  }
}
