# repository

##　未経験の技術

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

## 解説

2 日目の Firebase App Distribution への連携時にプロジェクトを作り直さざるを得なくなったため,2 日目以前のコミットの記録が消滅しました。ご容赦ください。代わりに時系列順に作業工程を詳しく説明します.

### パイプライン作成

[こちら](https://zenn.dev/takuowake/articles/e1f52c5f0fb4ab)で勉強しました.暫定的に Build APK まで実装しました.

### UI 設計

Figma を用いて作成しました。

### Provider

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

### ページ雛形

最低限のテストができるように基本的なウィジェットを配置しました.以下のエラーが発生しました.

- ページの雛形作成中にウィジェット関連でエラー. `Column` と `ListView` を入れ子にするとサイズが定まらなくなるのが原因.`ListView`を`Expanded`で囲むなどで解決.
  https://qiita.com/umi_mori/items/fb7b67a5c5bb3dda927e
- GestureDetector が子要素上しか反応しなかった.
  https://note.com/gawakun/n/n54661ad04106
  https://api.flutter.dev/flutter/rendering/HitTestBehavior.html

### IntegrationTest

[こちら](https://zenn.dev/shima999ba/articles/d0aba49b159bf0)で勉強しました.`await tester.pumpAndSettle()`でのタイミングの調節や`Widget`の再配置が必要な箇所が多く苦労しました.

###　ビルド

Github Actions でバージョン関係を中心に大量にエラーが発生しました.
例:

```
FAILURE: Build failed with an exception.

* Where:
Build file '/home/runner/work/RepositoryViewer/RepositoryViewer/android/app/build.gradle' line: 2

* What went wrong:
An exception occurred applying plugin request [id: 'com.android.application']
> Failed to apply plugin 'com.android.internal.application'.
   > Android Gradle plugin requires Java 17 to run. You are currently using Java 11.
      Your current JDK is located in /usr/lib/jvm/temurin-11-jdk-amd64
      You can try some of the following options:
       - changing the IDE settings.
       - changing the JAVA_HOME environment variable.
       - changing `org.gradle.java.home` in `gradle.properties`.

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.

* Get more help at https://help.gradle.org

BUILD FAILED in 1m 4s
Running Gradle task 'assembleRelease'...                           65.4s

┌─ Flutter Fix ───────────────────────────────────────────────────────────────────────┐
│ [!] Android Gradle plugin requires Java 17 to run. You are currently using Java 11. │
│                                                                                     │
│ To fix this issue, try updating to the latest Android SDK and Android Studio on:    │
│ https://developer.android.com/studio/install                                        │
│ If that does not work, you can set the Java version used by Flutter by              │
│ running `flutter config --jdk-dir=“</path/to/jdk>“`                                 │
│                                                                                     │
│ To check the Java version used by Flutter, run `flutter doctor --verbose`           │
└─────────────────────────────────────────────────────────────────────────────────────┘
Gradle task assembleRelease failed with exit code 1
```

Java のセットアップもワークフローに組み込むことで対処.[[参考](https://stackoverflow.com/questions/77033194/java-17-is-required-instad-of-java-11-android-ci-cd-github-actions)]

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
