# RepositoryViewer

## 未経験の技術

- Provider を用いた状態管理
- CI/CD パイプラインの構築,Github Actions
- IntegrationTest
- Firebase App Distribution

## 作業行程

- 1 日目
  - パイプライン雛形作成
  - UI 設計(Figma)
  - 実装 1
    - モデル
    - Provider
    - ページ雛形
- 2 日目
  - テスト作成
  - Firebase App Distribution 連携
  - 実装 2
    - 多言語対応
  - パイプライン完成 & Github Actions ビルド成功

## 作業詳細

2 日目の Firebase App Distribution への連携時にプロジェクトを作り直さざるを得なくなったため,2 日目以前のコミットの記録が消滅しました。ご容赦ください。

### UI 設計

Figma を用いて作成しました。

### 実装

#### Provider

MVVM に触れるのが初めてのため[こちら](https://qiita.com/mamoru_takami/items/730b9db24c68cf8cfe75)で勉強しました.ウィジェットへの適用もこの記事通りに実装しました.

プロバイダーはメインとなるレポジトリ検索(`RepositoryProvider`)と設定(`SettingsProvider`)の 2 つに分けて作成します.

`RepositoryProvider`は以下のとおり実装します.

```dart
class RepositoryProvider extends ChangeNotifier {
    //基本実装
    String query = "";
    SortTypes sortType = SortTypes.updated;
    //Repositoryはレポジトリのモデル
    List<Repository> items = [];
    //追加実装
    bool isLoading = false;
    //セッター・httpによる取得など
}
```

http 通信は実装経験があるため当時のコードから引用しアレンジを加えました.

```dart
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
            print(e);
            continue;
          }
        }
      }
      isLoading = false;
      notifyListeners();
    });
  }
```

データモデルとして以下を作成しました.

```dart
class Repository {
  final String name;
  final String userIconPath;
  final String language;
  final int stars;
  final int watchers;
  final int forks;
  final int issues;
  //コンストラクタ,JSONからのファクトリー
}
enum SortTypes {
  stars,
  forks,
  isuues,
  updated;
  //テキスト,アイコンなど
}
```

`SettingsProvider`は多言語対応で実装したため後述します.

### Widget

最低限のテストができるように基本的なウィジェットを配置しました.以下のエラーが発生しました.

- ページの雛形作成中にウィジェット関連でエラー. `Column` と `ListView` を入れ子にするとサイズが定まらなくなるのが原因.`ListView`を`Expanded`で囲むなどで解決.
  https://qiita.com/umi_mori/items/fb7b67a5c5bb3dda927e
- GestureDetector が子要素上しか反応しなかった.
  https://note.com/gawakun/n/n54661ad04106
  https://api.flutter.dev/flutter/rendering/HitTestBehavior.html

### パイプライン作成

[Flutter アプリの CI/CD パイプライン構築ガイド](https://zenn.dev/takuowake/articles/e1f52c5f0fb4ab), [[Flutter]GitHub Actions で App Distribution にアプリをアップロードした](https://zenn.dev/shima999ba/articles/ae1fc477744e2a)を参考.

### テスト

[Flutter】IntegrationTest の準備](https://zenn.dev/shima999ba/articles/d0aba49b159bf0)を参考.

なぜか`tester.tap()`が反応しない

###　ビルド

Github Actions でバージョン関係を中心に大量にエラーが発生しました.

- 例 1

```
Android Gradle plugin requires Java 17 to run. You are currently using Java 11.
```

Java のセットアップもワークフローに組み込むことで対処.[[参考](https://stackoverflow.com/questions/77033194/java-17-is-required-instad-of-java-11-android-ci-cd-github-actions)]

- 例 2

```

```

### 多言語化

ビルドでのエラーの多さに
https://zenn.dev/amuro/articles/27799da3afc40e
依存関係でハマった.
flutter clean
flutter pub get
flutter gen-l10n
で治る

### Firebase App Distribution

https://github.com/wzieba/Firebase-Distribution-Github-Action?tab=readme-ov-file
https://zenn.dev/yass97/articles/e8d1e460ae6a59

## 備考

https://zenn.dev/t_fukuyama/articles/9048d5f26befee
https://qiita.com/kokogento/items/6c0baf22c85a28db388c

https://riverpod.dev/ja/docs/essentials/testing
https://flutter.salon/plugin/mockito/

https://zenn.dev/faucon/articles/ca4e3763498dac
https://qiita.com/omitsuhashi/items/ea6ae22d9572ea882a2f

https://qiita.com/MLLB/items/6b615428357ee9994c7e
https://faq.growthbeat.com/article/178-ios-p12
https://developer.apple.com/jp/help/account/manage-profiles/create-a-development-provisioning-profile/
https://zenn.dev/shima999ba/articles/ae1fc477744e2a

証明書 -> Type は AppstoreConnect
