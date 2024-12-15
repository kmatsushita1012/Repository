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

MVVM に触れるのが初めてのため[【Flutter】Provider を使って複数画面で再描画を行う【初心者向け】](https://qiita.com/mamoru_takami/items/730b9db24c68cf8cfe75)を参考.

プロバイダーはメインとなるレポジトリ検索(`RepositoryProvider`)と設定(`SettingsProvider`)の 2 つに分けて作成.

`RepositoryProvider`は以下のとおり実装.

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

http 通信は実装経験があるため当時のコードから引用しアレンジを加えた.

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

データモデルはレポジトリに対応する`Repository`とソートの選択肢に対応する`SortTypes`.

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

`SettingsProvider`は SharedPreference と連携しつつ設定の反映をリアルタイムで反映する.コンストラクタで SharedPreference を取り込むことでモックテストに対応.

```dart
class SettingsProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  late Locale _locale;
  Locale get locale => _locale;

  //全言語のAppLocalizationsが必要な時(言語設定)に使用
  final List<MapEntry<Locale, AppLocalizations>> _appLocalizationsEntryList =
      [];
  List<MapEntry<Locale, AppLocalizations>> get appLocalizationsEntryList =>
      _appLocalizationsEntryList;

  SettingsProvider(SharedPreferences prefs) {
    _prefs = prefs;
    //_appLocalizationsEntryListの初期化
  }

}
```

### Widget

- ページの雛形作成中にウィジェット関連でエラー. `Column` と `ListView` を入れ子にするとサイズが定まらなくなるのが原因.`ListView`を`Expanded`で囲むなどで解決.
  https://qiita.com/umi_mori/items/fb7b67a5c5bb3dda927e
- `GestureDetector` が子要素上しか反応しなかった.
  https://note.com/gawakun/n/n54661ad04106
  https://api.flutter.dev/flutter/rendering/HitTestBehavior.html

- リストページで追加の読み込みをできるようにした.[FlutterでのLazy Loadingリストビューの実装](https://qiita.com/omitsuhashi/items/ea6ae22d9572ea882a2f)を参考にした.


### 多言語化

[Flutter アプリを多言語化する方法（作業時間：10 分）](https://zenn.dev/amuro/articles/27799da3afc40e)を参考にした.
依存関係でハマりがちだが
```
flutter clean
flutter pub get
flutter gen-l10n
```
で治る

### アニメーション
- 詳細ページには主に`FadeTransition`を用いた.[リファレンス](https://api.flutter.dev/flutter/widgets/FadeTransition-class.html)を参照.

### パイプライン作成

[Flutter アプリの CI/CD パイプライン構築ガイド](https://zenn.dev/takuowake/articles/e1f52c5f0fb4ab), [[Flutter]GitHub Actions で App Distribution にアプリをアップロードした](https://zenn.dev/shima999ba/articles/ae1fc477744e2a)を参考.最初は前者を参考にしていたが iOS のビルドがアップできないことに気づき後者に変更.

Github Actions でバージョン関係を中心に大量にエラーが発生.

- 例 1

```
Android Gradle plugin requires Java 17 to run. You are currently using Java 11.
```

Java のセットアップもワークフローに組み込むことで対処.[[参考](https://stackoverflow.com/questions/77033194/java-17-is-required-instad-of-java-11-android-ci-cd-github-actions)]

- 例 2

```
Error: This request has been automatically failed because it uses a deprecated version of `actions/download-artifact: v2`.
```
該当部分は以下
```yaml
- uses: actions/checkout@v2
  - name: Get release-ipa from artifacts
    uses: actions/download-artifact@v4
```
`v2`を`v4`に書き換えて解決.`download-artifact`以外にも`upload-artifact`などで頻出した.

### Firebase App Distribution

- iOS のバージョンが初期設定の 12.0 では Firebase と連携できなかったため 14.0 に変更.
  [参考 1](https://zenn.dev/t_fukuyama/articles/9048d5f26befee)
-
[参考 2](https://qiita.com/kokogento/items/6c0baf22c85a28db388c)


#### iOS
- キーチェーンアクセスから証明書要求ファイル作成 ([参考](https://faq.growthbeat.com/article/178-ios-p12))
- Apple DeveloperでCertificatesを作成,ダウンロード
  - 用途にiOS Distributionを選択
  - 取得した証明書要求ファイルをセット
- ダウンロードしたファイルをキーチェーンアクセスで開き.p12で書き出し.
  - ログイン->自分の証明書で選択
- Apple DeveloperからAppIDを作成
- Apple DeveloperからProfileを作成
  - 用途にApp Store Connectを選択.
  - 作成したAppIDを選択
  - 





### テスト

[【Flutter】IntegrationTest の準備](https://zenn.dev/shima999ba/articles/d0aba49b159bf0)を参考.

#### ユニットテスト(Provider)

[provider のテスト](https://riverpod.dev/ja/docs/essentials/testing)を参考.また htpp 通信のテストにモックを導入した.([【Flutter】DI と Mock を使って WEB API をテストする + mockito チートシート コード付](https://flutter.salon/plugin/mockito/))

#### Widget

Provider が絡むテキストフィールドとボタンでつまづいた.

```dart
 testWidgets('renders QueryField correctly', (WidgetTester tester) async {
  final provider = RepositoryProvider()
    await tester.pumpWidget(MultiProvider(
      providers: [ChangeNotifierProvider.value(provider)],
      builder: (context, builder) => MaterialApp(
        //...
      ),
    ));
```

このような形式だったが Widget 側



## 備考




https://qiita.com/MLLB/items/6b615428357ee9994c7e

https://developer.apple.com/jp/help/account/manage-profiles/create-a-development-provisioning-profile/


https://qiita.com/warapuri/items/2a32cb2201ce75aa5f4b

https://qiita.com/kokogento/items/c2979542a34610925e2d
https://dev.classmethod.jp/articles/xcode-no-signing-certificate-ios-development-found-error/
証明書 -> Type は AppstoreConnect
