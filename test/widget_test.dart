// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:localization/main.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//テスト用Widgetを定義　言語を引数に取るように設定
Widget TestWidget(String language) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    //機種の言語設定の代わりになる部分
    locale: Locale(language),
    home: Builder(builder: (context) {
      return MyHomePage(title: AppLocalizations.of(context)!.title);
    }),
  );
}

//日本語フォントの読み込み
Future<void> loadJapaneseFont() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final binary = rootBundle.load('font/Mplus1-Regular.ttf');
  final loader = FontLoader('Roboto')..addFont(binary);
  await loader.load();
}

void main() {
  //多言語対応できているかのGolden Test
  testGoldens('golden test', (WidgetTester tester) async {
    //日本語フォントの読み込み
    await loadJapaneseFont();
    //デバイスの画面サイズ
    final size = Size(415, 896);

    //日本語のテスト
    await tester.pumpWidgetBuilder(TestWidget('ja'), surfaceSize: size);

    await screenMatchesGolden(tester, 'myApp_ja');

    //英語のテスト
    await tester.pumpWidgetBuilder(TestWidget('en'), surfaceSize: size);

    await screenMatchesGolden(tester, 'myApp_en');
  });

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
