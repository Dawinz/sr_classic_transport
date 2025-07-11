import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cargo_details_page.dart';
import 'providers/language_provider.dart';
import 'localization.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({super.key});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedNumber();
  }

  /// Loads a previously saved phone number from persistent storage.

  Future<void> _loadSavedNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('savedPhoneNumber');
    if (saved != null && saved.isNotEmpty) {
      phoneController.text = saved;
    }
  }

  /// Loads shipment data from the bundled JSON file if not already loaded.
  List<Map<String, dynamic>>? _shipments;

  Future<void> _loadShipments() async {
    if (_shipments != null) return;
    final data = await rootBundle.loadString('assets/data/shipments.json');
    _shipments =
        (json.decode(data) as List).cast<Map<String, dynamic>>();
  }

  /// Finds a shipment by its [code]. Returns `null` if not found.
  Future<Map<String, dynamic>?> _findShipment(String code) async {
    await _loadShipments();
    for (final shipment in _shipments!) {
      final id = shipment['id'] as String?;
      if (id != null && id.toLowerCase() == code.toLowerCase()) {
        return shipment;
      }
    }
    return null;
  }


  /// Prompts the user to optionally save the entered phone number.
  /// Returns true when the dialog is dismissed with any positive action.

  Future<bool> _showSaveNumberDialog(String number, AppLocalizations loc) async {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            loc.translate('save_number_question'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isLight ? Colors.black : null,
            ),
          ),
          content: Text(loc.translate('would_you_like_to_save_number')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(loc.translate('cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(loc.translate('dont_save')),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('savedPhoneNumber', number);
                Navigator.of(context).pop(true);
              },
              child: Text(loc.translate('save')),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  void dispose() {
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final loc = AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);

    return Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        loc.translate('enter_phone_and_code'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Phone number input
                      Text(
                        loc.translate('sender_receiver_number'),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
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
                      const SizedBox(height: 16),

                      // Code number input
                      Text(
                        loc.translate('code_number'),
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: codeController,
                        style: const TextStyle(color: Colors.black),
                        decoration: _inputDecoration('DL123456'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return loc.translate('please_enter_tracking_code');
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
                            final phone = phoneController.text.trim();
                            final proceed = await _showSaveNumberDialog(phone, loc);
                            if (!proceed) return;

                            setState(() {
                              _isLoading = true;
                            });
                            final code = codeController.text.trim();
                            final data = await _findShipment(code);
                            setState(() {
                              _isLoading = false;
                            });

                            if (data != null) {
                              final senderPhone = data['cargoInfo']['senderPhone'] ?? '';
                              final receiverPhone = data['cargoInfo']['receiverPhone'] ?? '';
                              if (senderPhone.contains(phone) ||
                                  receiverPhone.contains(phone)) {
                                final cargo = data;
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_, animation, __) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero,
                                        ).chain(CurveTween(curve: Curves.ease)).animate(animation),
                                        child: CargoDetailsPage(cargoData: cargo),
                                      );
                                    },
                                    transitionDuration: const Duration(milliseconds: 300),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(loc.translate('no_cargo_found'))),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(loc.translate('no_cargo_found'))),
                              );
                            }
                          }
                        },
                        child: Text(
                          loc.translate('quick_check'),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
  /// Returns a styled [InputDecoration] used by the text fields on this page.


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
