class Repository {
  final String name;
  final String userIconPath;
  final String language;
  final int star;
  final int watcher;
  final int fork;
  final int issue;

  Repository(
      {required this.name,
      required this.userIconPath,
      required this.language,
      required this.star,
      required this.watcher,
      required this.fork,
      required this.issue});
      
  factory Repository.fromSearhRepositoryItem(dynamic item) {
    return Repository(
        name: item["name"],
        userIconPath: item["owner"]["avatar_url"],
        language: item["language"],
        star: item["stargazers_count"],
        watcher: item["watchers"],
        fork: item["forks"],
        issue: item["open_issues"]);
  }
}
