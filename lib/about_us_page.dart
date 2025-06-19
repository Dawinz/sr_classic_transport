import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'localization.dart';
import 'providers/language_provider.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(loc.translate('about_us'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.translate('introduction'),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              loc.translate('about_us_content'),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            Text(
              loc.translate('price_list'),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildPriceTable(loc),
            const SizedBox(height: 30),
            Text(
              loc.translate('contact_us'),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceTable(AppLocalizations loc) {
    final rows = [
      ['JOHANNESBURG - LUBUMBASHI', 'R 1800'],
      ['JOHANNESBURG - LUSAKA', 'R 900'],
      ['JOHANNESBURG - DAR-ES-SALAAM', 'R 2000'],
      ['JOHANNESBURG - KAMPALA', 'R 2800'],
      ['DAR-ES-SALAAM - JOHANNESBURG', 'TZS 300,000'],
      ['LUBUMBASHI - JOHANNESBURG', '\$ 100'],
      ['LUBUMBASHI - LUSAKA', '\$ 50'],
      ['KAMPALA - JOHANNESBURG', 'UGS 600,000'],
      ['LUSAKA - LUBUMBASHI', 'ZK 1400'],
    ];

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
      },
      border: TableBorder.all(color: Colors.grey.shade300),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Colors.redAccent),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                loc.translate('route'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                loc.translate('price'),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        ...rows.map(
              (row) => TableRow(
            children: row.map(
                  (cell) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(cell),
              ),
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('LUBUMBASHI', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('N° 756, Blvd. Msiri, Usine-CRAA, C/Kampemba, Lubumbashi - RDC.'),
        Text('+243 981 568 118 | +243 837 950 009'),
        SizedBox(height: 16),
        Text('JOHANNESBURG', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Mini Plaza 119 Albertina Sisulu & High Road Fordsburg, Opposite Orient Plaza Gate No. 3, Johannesburg - RSA.'),
        Text('+27 (72) 710-3819 | +27 (79) 658-4370'),
      ],
    );
  }
}
