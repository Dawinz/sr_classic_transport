import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'localization.dart';
import 'providers/language_provider.dart';

class AboutUsPage extends StatelessWidget {
/// Displays information about the company (to be implemented).
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);
    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('about_us'))),
      body: const SizedBox.shrink(),
    );
  }
}
