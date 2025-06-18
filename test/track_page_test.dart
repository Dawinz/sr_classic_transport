import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:sr_classic_transport/track_page.dart';
import 'package:sr_classic_transport/providers/theme_provider.dart';
import 'package:sr_classic_transport/providers/language_provider.dart';
import 'package:sr_classic_transport/localization.dart';

void main() {
  testWidgets('TrackPage displays validation errors when fields are empty', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: const MaterialApp(home: TrackPage()),
      ),
    );

    await tester.pumpAndSettle();

    final quickCheck = AppLocalizations('en').translate('quick_check');
    await tester.tap(find.text(quickCheck));
    await tester.pump();

    final phoneError = AppLocalizations('en').translate('please_enter_phone_number');
    final codeError = AppLocalizations('en').translate('please_enter_tracking_code');

    expect(find.text(phoneError), findsOneWidget);
    expect(find.text(codeError), findsOneWidget);
  });
}
