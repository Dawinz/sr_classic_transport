import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:sr_classic_transport/main.dart';
import 'package:sr_classic_transport/providers/theme_provider.dart';
import 'package:sr_classic_transport/providers/language_provider.dart';
import 'package:sr_classic_transport/localization.dart';

void main() {
  testWidgets('App launches and shows home screen', (WidgetTester tester) async {
    // Build the app with ThemeProvider and simulate onboarding completed
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: MyApp(isOnboardingComplete: true),
      ),
    );

    // Wait for animations and builds
    await tester.pumpAndSettle();

    // Check that a key element on your home screen is present
    final expected = AppLocalizations('en').translate('track_your_luggage');
    expect(find.text(expected), findsOneWidget);
  });
}
