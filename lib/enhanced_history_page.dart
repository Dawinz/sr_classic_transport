import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import 'localization.dart';
import 'providers/language_provider.dart';

class EnhancedHistoryPage extends StatefulWidget {
  const EnhancedHistoryPage({super.key});

  @override
  State<EnhancedHistoryPage> createState() => _EnhancedHistoryPageState();
}

class _EnhancedHistoryPageState extends State<EnhancedHistoryPage> {
  late Future<List<dynamic>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _loadHistory();
  }

  Future<List<dynamic>> _loadHistory() async {
    final data = await rootBundle.loadString('assets/data/shipments.json');
    return json.decode(data) as List<dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('tracking_history')),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FutureBuilder<List<dynamic>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          final historyItems = snapshot.data!.cast<Map<String, dynamic>>();
          return ListView.builder(
            itemCount: historyItems.length,
            itemBuilder: (context, index) {
              final status = historyItems[index]['status'];
              final isOut = status == 'Out';
              final baseColor = isOut ? Colors.red : Colors.blue;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                color: theme.cardColor,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
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
                          margin: const EdgeInsets.only(top: 0),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                color: baseColor,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      historyItems[index]['date'],
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      historyItems[index]['id'],
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      historyItems[index]['route'],
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              if (isOut)
                                ExpansionTile(
                                  title: Text(
                                    loc.translate('dispatch_info'),
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : Colors.black,
                                      ),
                                  ),
                                  children: [
                                    _buildInfoStripe(context, '${loc.translate('dispatch_date')}:', historyItems[index]['dispatchInfo']['date'], isDark),
                                    _buildInfoStripe(context, '${loc.translate('status')}:', historyItems[index]['dispatchInfo']['status'], isDark, alt: true),
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
                                  _buildInfoStripe(context, '${loc.translate('registered')}:', historyItems[index]['cargoInfo']['registeredDateTime'], isDark),
                                  _buildInfoStripe(context, '${loc.translate('sender')}:', '${historyItems[index]['cargoInfo']['senderName']} - ${historyItems[index]['cargoInfo']['senderPhone']}', isDark, alt: true),
                                  _buildInfoStripe(context, '${loc.translate('receiver')}:', '${historyItems[index]['cargoInfo']['receiverName']} - ${historyItems[index]['cargoInfo']['receiverPhone']}', isDark),
                                  _buildInfoStripe(context, '${loc.translate('quantity')}:', historyItems[index]['cargoInfo']['quantity'], isDark, alt: true),
                                  _buildInfoStripe(context, '${loc.translate('payment_option')}:', historyItems[index]['cargoInfo']['paymentOption'], isDark),
                                  _buildInfoStripe(context, '${loc.translate('total_price')}:', historyItems[index]['cargoInfo']['totalPrice'], isDark, alt: true),
                                ],
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
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoStripe(BuildContext context, String label, String value, bool isDark, {bool alt = false}) {
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
}
