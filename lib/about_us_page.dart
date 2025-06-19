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
              'INTRODUCTION',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "SR Classic coach is a Tanzanian based company which deals with road transportation of passengers and cargo across East and Central Africa. "
                  "SR Classic coach operates in 7 countries including Tanzania, Kenya, Uganda, Burundi, Zambia, Zimbabwe and Democratic Republic of Congo with over 150 fleet of buses and over 1000 staff and operators.\n\n"
                  "The company provides service of transporting people and goods from Dar es Salaam to Lubumbashi, Lusaka, Harare, Kampala, Bujumbura, and more route connections in Kenya, Uganda and DRC Congo to local cities and neighboring countries.",
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            Text(
              'PRICE LIST',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildPriceTable(),
            const SizedBox(height: 30),
            Text(
              'CONTACT US',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceTable() {
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
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Route',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Price',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
