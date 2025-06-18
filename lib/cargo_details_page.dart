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
    final isDark = theme.brightness == Brightness.dark;
    final loc =
    AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);

    final bool isDispatched = cargo['dispatchInfo'] != null;
    final Map<String, dynamic>? dispatchInfo = cargo['dispatchInfo'];
    final Map<String, dynamic> cargoInfo = cargo['cargoInfo'];
    final Map<String, dynamic> allDetails =
        (cargo['allDetails'] as Map<String, dynamic>?) ?? {};

    final Color primaryColor =
    isDispatched ? Colors.red[600]! : Colors.blue[600]!;

    Widget buildRow(String label, String value, {bool alt = false}) {
      final bgColor = isDark
          ? (alt ? const Color(0xFF2A2A2A) : const Color(0xFF1E1E1E))
          : (alt ? const Color(0xFFF5F5F5) : const Color(0xFFFFFFFF));

      return Container(
        color: bgColor,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  // Reserve space for the status badge while keeping the
                  // header color consistent.
                  Container(height: 40, color: primaryColor),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    color: primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          cargo['date'] ?? '',
                          style:
                          theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cargo['id'] ?? '',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          cargo['route'] ?? '',
                          style:
                          theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
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
                    color: primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    loc.translate(isDispatched ? 'out' : 'store'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (isDispatched) ...[
            buildRow(
              loc.translate('dispatch_date'),
              dispatchInfo?['date'] ?? '-',
            ),
            buildRow(
              loc.translate('dispatch_status'),
              dispatchInfo?['status'] ?? '-',
              alt: true,
            ),
            const Divider(thickness: 1),
          ],

          buildRow(
            loc.translate('registered'),
            cargoInfo['registeredDateTime'] ?? '-',
          ),
          buildRow(
            loc.translate('sender'),
            '${cargoInfo['senderName'] ?? ''} - ${cargoInfo['senderPhone'] ?? ''}',
            alt: true,
          ),
          buildRow(
            loc.translate('receiver'),
            '${cargoInfo['receiverName'] ?? ''} - ${cargoInfo['receiverPhone'] ?? ''}',
          ),
          buildRow(
            loc.translate('quantity'),
            cargoInfo['quantity'] ?? '-',
            alt: true,
          ),
          buildRow(
            loc.translate('payment_option'),
            cargoInfo['paymentOption'] ?? '-',
          ),
          buildRow(
            loc.translate('total_price'),
            cargoInfo['totalPrice'] ?? '-',
            alt: true,
          ),

          if (allDetails.isNotEmpty) ...[
            const Divider(thickness: 1),
            ...List<Widget>.generate(allDetails.length, (index) {
              final entry = allDetails.entries.elementAt(index);
              return buildRow(
                entry.key,
                entry.value.toString(),
                alt: index.isOdd,
              );
            }),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
