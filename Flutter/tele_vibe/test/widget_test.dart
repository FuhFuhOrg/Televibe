import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:tele_vibe/GettedData/pseudoChatApi.dart';
import 'package:tele_vibe/Widgets/allChatsClass.dart';
import 'package:tele_vibe/Widgets/loginClass.dart';
import 'package:tele_vibe/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('App opens login screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      _testApp(const LoginPage(enableAutoLogin: false)),
    );

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Televibe'), findsOneWidget);
    expect(find.text('Open chats'), findsOneWidget);
  });

  testWidgets('Conversation hub can open a chat without crashing',
      (WidgetTester tester) async {
    await PseudoChatApi.activate();

    await tester.pumpWidget(
      _testApp(const AllChatsPage()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AllChatsPage), findsOneWidget);
    expect(find.text('Conversation hub'), findsOneWidget);

    await tester.tap(find.text('Anna Carter').last);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Anna Carter'), findsOneWidget);
    expect(find.text('Perfect, I will review it and leave notes in the file.'),
        findsOneWidget);
  });

  testWidgets('Prepared chats open from login without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      _testApp(const LoginPage(enableAutoLogin: false)),
    );

    await tester.tap(find.text('Open chats'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(AllChatsPage), findsOneWidget);
    expect(find.text('Conversation hub'), findsOneWidget);
  });
}

Widget _testApp(Widget home) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}
