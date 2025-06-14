import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'localization.dart';
import 'providers/language_provider.dart';

class BookingPage extends StatelessWidget {
/// Placeholder page for future booking features.
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.build, size: 100, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              loc.translate('coming_soon'),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
          ],
        ),
      ),
    );
  }
}
