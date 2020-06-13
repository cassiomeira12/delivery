import 'package:flutter/material.dart';
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      debugShowCheckedModeBanner: true,
      theme: CustomTheme.of(context),
      home: RootPage(),
    );
  }
}

