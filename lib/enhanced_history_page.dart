import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

import 'localization.dart';
import 'providers/language_provider.dart';
import 'cargo_details_page.dart';

/// Displays a list of previously tracked shipments from a bundled JSON file.

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

  /// Reads shipment history information from the JSON asset.

  Future<List<dynamic>> _loadHistory() async {
    final data = await rootBundle.loadString('assets/data/shipments.json');
    return json.decode(data) as List<dynamic>;
  }

  void _showCargoDetails(BuildContext context, Map<String, dynamic> cargoData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CargoDetailsPage(cargoData: cargoData),
      ),
    );
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
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                color: theme.cardColor,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  onTap: () => _showCargoDetails(context, historyItems[index]),
                  borderRadius: BorderRadius.circular(12),
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
                                // Quick info section
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${loc.translate('sender')}:',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.grey[300] : Colors.grey[700],
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              historyItems[index]['cargoInfo']['senderName'],
                                              style: theme.textTheme.bodyMedium,
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${loc.translate('receiver')}:',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.grey[300] : Colors.grey[700],
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              historyItems[index]['cargoInfo']['receiverName'],
                                              style: theme.textTheme.bodyMedium,
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${loc.translate('total_price')}:',
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.grey[300] : Colors.grey[700],
                                            ),
                                          ),
                                          Text(
                                            historyItems[index]['cargoInfo']['totalPrice'],
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: baseColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (isOut) ...[
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${loc.translate('dispatch_status')}:',
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: isDark ? Colors.grey[300] : Colors.grey[700],
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                historyItems[index]['dispatchInfo']['status'],
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  color: Colors.orange,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ],
                                  ),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
