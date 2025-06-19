import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'localization.dart';
import 'providers/language_provider.dart';

class CargoDetailsPage extends StatelessWidget {
  final Map<String, dynamic> cargo;

  const CargoDetailsPage({super.key, required this.cargo});

  Widget _buildInfoStripe(
    BuildContext context,
    String label,
    String value,
    bool isDark, {
    bool alt = false,
  }) {
    final theme = Theme.of(context);
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
          Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc =
        AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);

    final Map<String, dynamic>? dispatchInfo = cargo['dispatchInfo'];
    final Map<String, dynamic> cargoInfo = cargo['cargoInfo'];
    final bool isDispatched = dispatchInfo != null;

    final Color baseColor = isDispatched ? Colors.red : Colors.blue;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('cargo_details')),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            color: theme.cardColor,
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      color: baseColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            cargo['date'] ?? '',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cargo['id'] ?? '',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            cargo['route'] ?? '',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    if (isDispatched)
                      ExpansionTile(
                        title: Text(
                          loc.translate('dispatch_info'),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        children: [
                          _buildInfoStripe(
                              context,
                              '${loc.translate('dispatch_date')}:',
                              dispatchInfo?['date'] ?? '',
                              isDark),
                          _buildInfoStripe(
                              context,
                              '${loc.translate('dispatch_status')}:',
                              (dispatchInfo?['status'] ?? '').toString().trim(),
                              isDark,
                              alt: true),
                        ],
                      ),
                    ExpansionTile(
                      title: Text(
                        loc.translate('cargo_info'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      children: [
                        _buildInfoStripe(
                            context,
                            '${loc.translate('registered')}:',
                            cargoInfo['registeredDateTime'] ?? '',
                            isDark,
                            alt: true),
                        _buildInfoStripe(
                            context,
                            '${loc.translate('sender')}:',
                            '${cargoInfo['senderName'] ?? ''} - ${cargoInfo['senderPhone'] ?? ''}',
                            isDark),
                        _buildInfoStripe(
                            context,
                            '${loc.translate('receiver')}:',
                            '${cargoInfo['receiverName'] ?? ''} - ${cargoInfo['receiverPhone'] ?? ''}',
                            isDark,
                            alt: true),
                        _buildInfoStripe(
                            context,
                            '${loc.translate('quantity')}:',
                            cargoInfo['quantity'] ?? '',
                            isDark),
                        _buildInfoStripe(
                            context,
                            '${loc.translate('payment_option')}:',
                            cargoInfo['paymentOption'] ?? '',
                            isDark,
                            alt: true),
                        _buildInfoStripe(
                            context,
                            '${loc.translate('total_price')}:',
                            cargoInfo['totalPrice'] ?? '',
                            isDark,
                            alt: true),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                      (() {
                        final status =
                            (dispatchInfo?['status'] ?? '').toString().trim();
                        return status.isNotEmpty
                            ? status
                            : loc.translate(isDispatched ? 'out' : 'store');
                      })(),
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
          ),
        ],
      ),
    );
  }
}
