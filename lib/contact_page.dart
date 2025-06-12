import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'localization.dart';
import 'providers/language_provider.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  void _launchEmail() async {
    final uri = Uri(scheme: 'mailto', path: 'info@srclassic.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);
    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('contact_us'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone, size: 100, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _launchEmail,
              child: Text(
                'info@srclassic.com',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      decoration: TextDecoration.underline,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
