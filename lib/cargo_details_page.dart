import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'localization.dart';
import 'providers/language_provider.dart';

class CargoDetailsPage extends StatelessWidget {
  final Map<String, dynamic> cargo;

  const CargoDetailsPage({super.key, required this.cargo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isOut = cargo['status'] == 'Out';
    final Color baseColor = isOut ? Colors.red : Colors.blue;
    final bool isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);
    final Map<String, dynamic>? dispatchInfo = cargo['dispatchInfo'];
    final Map<String, dynamic> cargoInfo = cargo['cargoInfo'];

    /// Convenience widget used to present a label/value pair.
    Widget buildRow(String label, String value, {bool alt = false}) {
      final bgColor = isDark
          ? (alt ? const Color(0xFF2A2A2A) : const Color(0xFF1E1E1E))
          : (alt ? const Color(0xFFF5F5F5) : const Color(0xFFFFFFFF));
      return Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('cargo_details')),
        backgroundColor: baseColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: 40,
                    color: theme.scaffoldBackgroundColor,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    color: baseColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          cargo['date'],
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cargo['id'],
                          style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cargo['route'],
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: baseColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    loc.translate(isOut ? 'out' : 'store'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (dispatchInfo != null) ...[
            const SizedBox(height: 16),
            buildRow(loc.translate('dispatch_date'), dispatchInfo['date']),
            buildRow(loc.translate('dispatch_status'), dispatchInfo['status'], alt: true),
          ],
          const SizedBox(height: 16),
          buildRow(loc.translate('registered'), cargoInfo['registeredDateTime']),
          buildRow(loc.translate('sender'),
              '${cargoInfo['senderName']} - ${cargoInfo['senderPhone']}',
              alt: true),
          buildRow(loc.translate('receiver'),
              '${cargoInfo['receiverName']} - ${cargoInfo['receiverPhone']}'),
          buildRow(loc.translate('quantity'), cargoInfo['quantity'], alt: true),
          buildRow(loc.translate('payment_option'), cargoInfo['paymentOption']),
          buildRow(loc.translate('total_price'), cargoInfo['totalPrice'], alt: true),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
