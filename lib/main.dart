import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:repository/page/listpage.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:repository/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  //非同期処理用
  WidgetsFlutterBinding.ensureInitialized();
  //SharedPreferencesを初期化
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Firebaseを連携
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //httpクライアントを設定
  GetIt.I.registerLazySingleton<http.Client>(
    () => http.Client(),
  );
  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    //プロバイダを設定
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => RepositoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(prefs),
        )
      ],
      builder: (context, child) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: context.watch<SettingsProvider>().locale,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: ListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
