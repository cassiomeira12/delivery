import 'package:flutter/material.dart';
import 'services/parse/parse_init.dart';
import 'themes/my_themes.dart';
import 'themes/custom_theme.dart';
import 'strings.dart';
import 'views/root_page.dart';

void main() {
  runApp(
    CustomTheme(
      initialThemeKey: MyThemeKeys.LIGHT,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RootPage root;

  @override
  void initState() {
    super.initState();
    root = RootPage();
    ParseInit.init().then((value) {
      root.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      debugShowCheckedModeBanner: true,
      theme: CustomTheme.of(context),
      home: root,
    );
  }

}
