import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'status_utils.dart';

import 'localization.dart';
import 'providers/language_provider.dart';

/// Displays a list of previously tracked shipments from a bundled JSON file.

class EnhancedHistoryPage extends StatefulWidget {
  const EnhancedHistoryPage({super.key});

  @override
  State<EnhancedHistoryPage> createState() => _EnhancedHistoryPageState();
}

class _EnhancedHistoryPageState extends State<EnhancedHistoryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();

  Future<List<Map<String, dynamic>>?>? _historyFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedNumber();
  }

  Future<void> _loadSavedNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('savedPhoneNumber');
    if (saved != null && saved.isNotEmpty) {
      phoneController.text = saved;
      setState(() {
        _historyFuture = _fetchHistoryData(saved);
      });
    }
  }

  Future<List<Map<String, dynamic>>?> _fetchHistoryData(String phone) async {
    final url =
        Uri.parse('http://217.29.139.44:555/track/history.php?phone=$phone');
    try {
      final response = await http.get(url);
      if (response.statusCode != 200) return null;
      return List<Map<String, dynamic>>.from(
          json.decode(response.body) as List<dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc =
        AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);

    if (_historyFuture == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(loc.translate('tracking_history')),
        ),
        body: Stack(
          children: [
            Image.asset(
              'assets/images/bus_background.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Container(color: Colors.black.withOpacity(0.5)),
            Center(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          loc.translate('track_your_luggage'),
                          style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          loc.translate('enter_phone_and_code'),
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          loc.translate('sender_receiver_number'),
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.black),
                          decoration: _inputDecoration('+243'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return loc.translate('please_enter_phone_number');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              final phone = phoneController.text.trim();
                              _historyFuture = _fetchHistoryData(phone);
                              final future = _historyFuture!;
                              setState(() {});
                              await future;
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          child: Text(
                            loc.translate('quick_check'),
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black45,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('tracking_history')),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: FutureBuilder<List<Map<String, dynamic>>?>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null ||
              (snapshot.data?.isEmpty ?? true)) {
            return Center(child: Text(loc.translate('no_cargo_found')));
          }
          final historyItems = snapshot.data!;
          return ListView.builder(
            itemCount: historyItems.length,
            itemBuilder: (context, index) {
              final status = historyItems[index]['status']?.toString();
              final isArrived = cargoArrived(status);
              final baseColor = statusColor(status);

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
                              if (isArrived)
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
                                        historyItems[index]['dispatchInfo']?['date'] ?? '',
                                        isDark),
                                    _buildInfoStripe(
                                        context,
                                        '${loc.translate('status')}:',
                                        historyItems[index]['dispatchInfo']?['status'] ?? '',
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
                                      historyItems[index]['cargoInfo']?['registeredDateTime'] ?? '',
                                      isDark),
                                  _buildInfoStripe(
                                      context,
                                      '${loc.translate('sender')}:',
                                      '${historyItems[index]['cargoInfo']?['senderName'] ?? ''} - ${historyItems[index]['cargoInfo']?['senderPhone'] ?? ''}',
                                      isDark,
                                      alt: true),
                                  _buildInfoStripe(
                                      context,
                                      '${loc.translate('receiver')}:',
                                      '${historyItems[index]['cargoInfo']?['receiverName'] ?? ''} - ${historyItems[index]['cargoInfo']?['receiverPhone'] ?? ''}',
                                      isDark),
                                  _buildInfoStripe(
                                      context,
                                      '${loc.translate('quantity')}:',
                                      historyItems[index]['cargoInfo']?['quantity'] ?? '',
                                      isDark,
                                      alt: true),
                                  _buildInfoStripe(
                                      context,
                                      '${loc.translate('payment_option')}:',
                                      historyItems[index]['cargoInfo']?['paymentOption'] ?? '',
                                      isDark),
                                  _buildInfoStripe(
                                      context,
                                      '${loc.translate('total_price')}:',
                                      historyItems[index]['cargoInfo']?['totalPrice'] ?? '',
                                      isDark,
                                      alt: true),
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
                          loc.translate(isArrived ? 'out' : 'store'),
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
  /// Helper widget used to display a single row of label/value information.


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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black45),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }
}
