import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'localization.dart';
import 'providers/language_provider.dart';

class TrackingResultPage extends StatelessWidget {
  final Map<String, String> info;
  const TrackingResultPage({super.key, required this.info});

  Widget _buildRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc =
        AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('cargo_details')),
      ),
      body: ListView(
        children: [
          _buildRow(context, loc.translate('status'), info['Status'] ?? ''),
          _buildRow(
              context,
              loc.translate('sender'),
              '${info["Sender's name"] ?? ''} - ${info["Sender's phone number"] ?? ''}'),
          _buildRow(
              context,
              loc.translate('receiver'),
              '${info["Receiver's name"] ?? ''} - ${info["Receiver's phone number"] ?? ''}'),
        ],
      ),
    );
  }
}
