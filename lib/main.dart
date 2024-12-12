import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:repository/page/list.dart';
import 'package:repository/providers/repository_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:repository/providers/settings_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
        // title: AppLocalizations.of(context)!.title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: ListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
