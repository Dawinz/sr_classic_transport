import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
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

  /// Fetches tracking information from the remote API and returns a map of
  /// extracted values keyed by their labels.
  Future<Map<String, String>?> _fetchTrackingData(String code) async {
    final url =
        Uri.parse('http://217.29.139.44:555/track/ticket_info.php?code=$code');
    try {
      final response = await http.get(url);
      if (response.statusCode != 200) return null;
      final document = html_parser.parse(response.body);
      final Map<String, String> result = {};
      for (final li in document.querySelectorAll('li')) {
        final spans = li.querySelectorAll('span');
        if (spans.length >= 2) {
          var key = spans[0].text.trim();
          var value = spans[1].text.replaceAll('\u00a0', ' ').trim();
          if (value.startsWith('-')) {
            value = value.substring(1).trim();
          }
          result[key] = value;
        }
      }
      return result.isEmpty ? null : result;
    } catch (_) {
      return null;
    }
  }

  /// Converts the raw info map from [_fetchTrackingData] into the structure
  /// expected by [CargoDetailsPage]. This attempts to map various possible
  /// keys returned by the backend to the fields used previously when the data
  /// came from `shipments.json`.
  Map<String, dynamic> _convertToCargo(Map<String, String> info) {
    String _first(List<String> keys) {
      for (final k in keys) {
        if (info.containsKey(k)) return info[k]!;
      }
      return '';
    }

    final dispatchDate = _first(['Dispatch date', 'Dispatch Date']);
    final dispatchStatus = _first(['Dispatch status', 'Dispatch Status']);

    return {
      'id': _first(['Code', 'ID', 'Ticket number', 'Ticket No', 'Ticket']),
      'date': info['Date'] ?? '',
      'status': info['Status'] ?? '',
      'route': info['Route'] ?? '',
      'dispatchInfo': (dispatchDate.isNotEmpty || dispatchStatus.isNotEmpty)
          ? {'date': dispatchDate, 'status': dispatchStatus}
          : null,
      'cargoInfo': {
        'registeredDateTime':
            _first(['Registered Date & Time', 'Registered date']),
        'senderName': _first(["Sender's name", 'Sender name']),
        'receiverName': _first(["Receiver's name", 'Receiver name']),
        'senderPhone': _first(["Sender's phone number", 'Sender phone']),
        'receiverPhone': _first(["Receiver's phone number", 'Receiver phone']),
        'quantity': info['Quantity'] ?? '',
        'paymentOption': _first(['Payment option', 'Payment Option']),
        'paidPrice': _first(['Paid price', 'Paid Price']),
        'toBePaidPrice':
            _first(['To be paid Price', 'To be paid price', 'To Be Paid Price']),
        'totalPrice': _first(['Total price', 'Total Price']),
      }
    };
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
                            final data = await _fetchTrackingData(code);
                            setState(() {
                              _isLoading = false;
                            });

                            if (data != null) {
                              final senderPhone = data["Sender's phone number"] ?? '';
                              final receiverPhone = data["Receiver's phone number"] ?? '';
                              if (senderPhone.contains(phone) ||
                                  receiverPhone.contains(phone)) {
                                final cargo = _convertToCargo(data);
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    pageBuilder: (_, animation, __) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(1, 0),
                                          end: Offset.zero,
                                        ).chain(CurveTween(curve: Curves.ease)).animate(animation),
                                        child: CargoDetailsPage(cargo: cargo),
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
