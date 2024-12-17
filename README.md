# 技術テスト

このリポジトリは、株式会社ゆめみ様 の技術テストに基づいて作成されたプロジェクトです。

## 仕様

- Flutter を用いた iOS/Android 向けアプリ
- Github REST API(/search/repositories)でレポジトリの情報を取得
- ページ構成
  - リストページ レポジトリの一覧をレポジトリ名で表示
  - 詳細ページ　以下の情報を表示
    - レポジトリ名
    - ユーザーアイコン
    - 言語
    - Star 数
    - Watcher 数
    - Fork 数
    - Issue 数
  - 設定ページ
  - 例外発生時アラート表示
    - 不適切なクエリ
    - 検索結果が 0 件
    - ネットワークエラー等
- 多言語対応(英語/日本語)
- アニメーション
- マテリアルデザイン
- レスポンシブ UI
- CI/CD パイプライン
  - GithubActions + Firebase App Distribution

## 開始前の技術レベル

Flutter は半年前に開始ししアプリを 2 つリリース.機能を愚直に実装し形にできる程度.

**使用したライブラリ**

- HTTP
- SharedPreferences
- GoogleMap
- SQLite

**未経験の技術**

- マテリアルデザイン
- レスポンシブ UI(横画面)
- Provider を用いた状態管理
- 多言語対応
- アニメーション
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
    - ページ雛形作成
- 2 日目
  - テスト作成
  - 実装 2
    - 多言語対応
  - パイプライン
    - リント&テストまでのワークフロー完成
    - Firebase App Distribution(Android) 連携
- 3 日目
  - Firebase App Distribution (iOS) 連携
    - 失敗
- 4 日目
  - テスト実装
    - Unit
    - UI
    - Integration(通常操作のみ)
- 5 日目
  - リストページへのアニメーション追加
    - MVVM パターンに組み込めず却下
  - Firebase App Distribution (iOS) 連携再チャレンジ
    - 失敗
  - レスポンシブ対応
- 6 日目
  - iOS の Distribution に再々チャレンジ
    - Fastlane の導入
  - Integration テストの充実
    - API のエラー発生時
    - 設定画面
- 7 日目
  - iOS の Distribution に成功

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
    String _query = "";
    SortTypes _sortType = SortTypes.updated;
    //Repositoryはレポジトリのモデル
    List<Repository> _items = [];
    //追加実装
    bool _isLoading = false;
    int page = 1;
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
     // レスポンス処理
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
```

```dart
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
  //全言語のAppLocalizationsが必要な時(言語設定)に使用
  final List<MapEntry<Locale, AppLocalizations>> _appLocalizationsEntryList =
      [];
  SettingsProvider(SharedPreferences prefs) {
    _prefs = prefs;
    //_appLocalizationsEntryListの初期化
  }
}
```

### Widget

経験があるので独力で行いつつ,細かいスタイルやその他プロパティについては生成 AI に聞くことでスムーズに開発を進めた.以下のエラーが発生.

- ページの雛形作成中にウィジェット関連でエラー. `Column` と `ListView` を入れ子にするとサイズが定まらなくなるのが原因.`ListView`を`Expanded`で囲むなどで解決.
  https://qiita.com/umi_mori/items/fb7b67a5c5bb3dda927e
- `GestureDetector` が子要素上しか反応しなかった.
  https://note.com/gawakun/n/n54661ad04106
  https://api.flutter.dev/flutter/rendering/HitTestBehavior.html
  またリストページで追加の読み込みをできるようにした.
- [Flutter での Lazy Loading リストビューの実装](https://qiita.com/omitsuhashi/items/ea6ae22d9572ea882a2f).

### 多言語化

[Flutter アプリを多言語化する方法（作業時間：10 分）](https://zenn.dev/amuro/articles/27799da3afc40e)を参考にした.
依存関係でハマりがちだが

```
flutter clean
flutter pub get
flutter gen-l10n
```

で治る.

### マテリアルデザイン

`Theme.of(context).colorScheme`でカラースキームを取得して必要に応じてスタイルを変更.

### アニメーション

- 詳細ページには主に`FadeTransition`を用いた.[リファレンス](https://api.flutter.dev/flutter/widgets/FadeTransition-class.html)を参照.
- リストページは API 通信,MVVM,インディケーター,追加読み込みなどが絡み合い,MVVM の設計パターンが壊れてしまったためアニメーションを断念.今後学んでいこうと思います.

### パイプライン作成

以下を参考.

1. [Flutter アプリの CI/CD パイプライン構築ガイド](https://zenn.dev/takuowake/articles/e1f52c5f0fb4ab)
2. [[Flutter]GitHub Actions で App Distribution にアプリをアップロードした](https://zenn.dev/shima999ba/articles/ae1fc477744e2a)
3. [GitHubActions×Fastlane×Firebase で iOS アプリを配布する CI/CD を構築](https://note.com/resan0725/n/nc84186fa841c)

最終的にリント/テストと Android のデプロイは 2.,iOS のデプロイは 3.をベースに実装.

- Github Actions のバージョンでエラー

```
Error: This request has been automatically failed because it uses a deprecated version of `actions/download-artifact: v2`.
```

該当部分は以下

```yaml
- uses: actions/checkout@v2
  - name: Get release-ipa from artifacts
    uses: actions/download-artifact@v4
```

`v2`を`v4`に書き換えて解決.`download-artifact`以外に`upload-artifact`,`checkout-artifact`も同様.

### テスト

見逃しをなくすために生成 AI にユニット/Widget のコードを送って作成してもらい,適宜自分の環境に書き換えたり,不足している部分を追記した.

#### ユニットテスト(Provider)

[provider のテスト](https://riverpod.dev/ja/docs/essentials/testing)を参考.また htpp 通信のテストにモックを導入した.([【Flutter】DI と Mock を使って WEB API をテストする + mockito チートシート コード付](https://flutter.salon/plugin/mockito/))

```Dart
    late MockClient mockClient;
    setUp(() {
      //リセット
      GetIt.I.reset();
      mockClient = MockClient(handler);
      GetIt.I.registerLazySingleton<http.Client>(() => mockClient);
    }
    //test
```

`setUp`を使うならこのように登録する前に必ずリセットしないと重複登録でエラーになる.`setUpAll`ならいらない.

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

このような形式だったが Widget 側で null エラーに.かなり調べたが改善しなかったので ChatGPT に聞いたら解決してしまった.

```Dart
group('SortButton Widget Test', () {
    late RepositoryProvider mockProvider;
    setUp(() {
      mockProvider = RepositoryProvider();
    });
    Widget createTestableWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<RepositoryProvider>.value(
          value: mockProvider,
          child: Scaffold(
              body: Target(),
          ),
        ),
      );
    }

    testWidgets('renders SortButton correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget());
      //...
    }
```

MaterialApp の中にないとダメなのだろうか.

#### IntegrationTest

[【Flutter】IntegrationTest の準備](https://zenn.dev/shima999ba/articles/d0aba49b159bf0)を参考.

### Firebase App Distribution

必要な環境変数を集めて GithubActions にセットする.

- 共通
  - FIREBASE_PROJ_DEV_NAME : プロジェクト ID
  - FIREBASE_AUTH_TOKEN : Firebase のトークン
  - FIREBASE_DEV_TOKEN : Firebase の Json Token
  - FIREBASE_DEV_IOS_ID,FIREBASE_DEV_ANDROID_ID : Firebase のアプリ ID(iOS/Android で共通)
- iOS
  - APPSTORE_CERT_BASE64 : 証明書(Base64 でエンコード)
  - APPSTORE_CERT_PASSWORD : 証明書のパスワード
  - MOBILEPROVISION_ADHOC_BASE64 : プロビジョニングプロファイル(Adhoc)
  - KEYCHAIN_PASSWORD : キーチェーンパスワード(任意の文字列で可)
- Android
  - ANDROID_KEY_JKS]キーストアファイル
  - ANDROID_STORE_PASSWORD : キーストアファイルのパスワード
  - ANDROID_ALIAS_PASSWORD : キーストアファイルの ALIAS のパスワード
  - ANDROID_KEY_ALIAS : キーストアファイルの ALIAS 名

#### iOS の手順

- iOS のバージョンが初期設定の 12.0 では Firebase と連携できなかったため 14.0 に変更.
- キーチェーンアクセスから証明書要求ファイル作成 ([参考](https://faq.growthbeat.com/article/178-ios-p12))
- Apple Developer で Certificates を作成,ダウンロード
  - Apple Distributionn を選択
  - 取得した証明書要求ファイルをセット
- ダウンロードしたファイルをキーチェーンアクセスで開き`*.p12`で書き出し
  - ログイン->自分の証明書で選択
  - パスワードを入力し`APPSTORE_CERT_BASE64`にセット
  - Base64 にエンコードして`APPSTORE_CERT_BASE64`にセット
- Apple Developer から AppID を作成
  - バンドル ID には`com.example.yourappname`を入力
- Apple Developer から Profile を作成 ([参考](https://developer.apple.com/jp/help/account/manage-profiles/create-a-development-provisioning-profile/))
  - 用途に Ad Hoc を選択
  - 作成した AppID を選択
  - 取得した証明書を選択
  - テスターに含めるデバイスを選択
  - 名前を入力して作成
- Xcode から設定変更
  - `BuildSettings`->`Code Siging Identity`で`Certificates in Keychain`から作成した証明書を選択[参考](https://dev.classmethod.jp/articles/xcode-no-signing-certificate-ios-development-found-error/)
  - `Signing & Capablities`
    - `Automatic manage signing`のチェックを外す
    - `Provisioning File`で作成した Profile を選択.
      - ない場合は`import file`
    - `Provisioning profile *** doesn't include signing certificate`と表示されたら証明書と Profile が一致してないので要確認
- 参考(3.)の手順 2 以降を実行

  - ワークフローを修正

    - 参考(2.)の`jobs`に置き換わるように
    - 下記を追加(対象の job は`.github/workflows/ios_build_stg.yaml`を参照)

    ```yaml
    working-directory: ./ios
    ```

    - Flutter のセットアップを追加

    ```yaml
    - uses: actions/setup-node@v1
        with:
          node-version: "18.x"
      #追加ここから
      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: "3.27.0"
      - name: Setup packages
        run: |
          flutter pub get
          dart run build_runner build -d
      #追加ここまで
      - name: Bundle Install
        run: bundle install
        working-directory: ./ios
    ```

  - `ios/fastlane/Fastfile`を修正
    ```
    export_options: {
        method: "ad-hoc",
        provisioningProfiles: {
            "***バンドルID***" => "***Your Profile Name***"
        }
    }
    ```
  - base64 コマンドの修正
    - ファイル名を指定するとき`-i`,`-o`がなくてエラーになる
    - ProvisioningProfile の方のファイル名がおかしかったので修正

  ```yaml
  - name: Keychain.p12
        run: |
          echo "${{ secrets.APPSTORE_CERT_BASE64 }}" > ios_distribution.p12.txt
          base64 --decode -i ios_distribution.p12.txt -o ios_distribution.p12
        working-directory: ./ios

      - name: ProvisioningProfile
        run: |
          echo "${{ secrets.MOBILEPROVISION_ADHOC_BASE64 }}" > adhoc.mobileprovision.txt
          base64 --decode -i adhoc.mobileprovision.txt -o adhoc.mobileprovision
        working-directory: ./ios
  ```

  その他 Firebase と iOS の連携で起きるバージョン関係のエラー

- [参考 1](https://zenn.dev/t_fukuyama/articles/9048d5f26befee)
- [参考 2](https://qiita.com/kokogento/items/6c0baf22c85a28db388c)

### Android の手順

通常通り keytool 周りを一通り取得すれば大丈夫なので省略.

- 1.を使用していたときに Java が入ってなかった.

```
Android Gradle plugin requires Java 17 to run. You are currently using Java 11.
```

Java のセットアップもワークフローに組み込むことで対処.[[参考](https://stackoverflow.com/questions/77033194/java-17-is-required-instad-of-java-11-android-ci-cd-github-actions)]

## 備考

その他備忘録. これらで治りはしなかったが今後役立つかもしれない.

https://qiita.com/warapuri/items/2a32cb2201ce75aa5f4b
https://qiita.com/warapuri/items/2a32cb2201ce75aa5f4b
https://qiita.com/kokogento/items/c2979542a34610925e2d
