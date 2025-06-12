import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'localization.dart';
import 'providers/language_provider.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final textColor = theme.colorScheme.onBackground;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: textTheme.bodyMedium?.copyWith(
            color: textColor,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(
      Provider.of<LanguageProvider>(context).languageCode,
    );

    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('terms_of_service'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            '1. Acceptance of Terms',
            'By accessing or using this app, you agree to be bound by these '
            'Terms of Service. If you disagree with any part, you may not '
            'access the app.',
          ),
          _buildSection(
            context,
            '2. Use of the App',
            'You may use the app only for lawful purposes and in accordance '
            'with these Terms. You agree not to misuse the services we '
            'provide.',
          ),
          _buildSection(
            context,
            '3. Account Responsibilities',
            'If you create an account, you are responsible for maintaining '
            'the confidentiality of your account information and for all '
            'activities that occur under your account.',
          ),
          _buildSection(
            context,
            '4. Intellectual Property',
            'All content, features, and functionality are owned by SR '
            'Classic Transport or its licensors and are protected by '
            'international copyright laws.',
          ),
          _buildSection(
            context,
            '5. Termination',
            'We may terminate or suspend your access immediately, without '
            'prior notice, for any breach of these Terms.',
          ),
          _buildSection(
            context,
            '6. Disclaimer',
            'The app is provided on an "AS IS" and "AS AVAILABLE" basis. Use '
            'of the app is at your own risk.',
          ),
          _buildSection(
            context,
            '7. Limitation of Liability',
            'In no event shall SR Classic Transport or its suppliers be '
            'liable for any damages arising out of or in connection with '
            'your use of the app.',
          ),
          _buildSection(
            context,
            '8. Changes to Terms',
            'We reserve the right to modify or replace these Terms at any '
            'time. Changes will be effective when posted in the app.',
          ),
          _buildSection(
            context,
            '9. Governing Law',
            'These Terms shall be governed by the laws of the jurisdiction '
            'in which SR Classic Transport operates, without regard to its '
            'conflict of law provisions.',
          ),
          _buildSection(
            context,
            '10. Contact Us',
            'If you have any questions about these Terms, please contact us '
            'at info@srclassic.com.',
          ),
        ],
      ),
    );
  }
}
