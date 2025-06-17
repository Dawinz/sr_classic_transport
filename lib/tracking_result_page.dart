import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'dart:convert';

class ParsedCargoPage extends StatefulWidget {
  final String trackingCode;
  const ParsedCargoPage({super.key, required this.trackingCode});

  @override
  State<ParsedCargoPage> createState() => _ParsedCargoPageState();
}

class _ParsedCargoPageState extends State<ParsedCargoPage> {
  Map<String, dynamic>? parsedData;

  @override
  void initState() {
    super.initState();
    _fetchAndParse();
  }

  Future<void> _fetchAndParse() async {
    final url = Uri.parse("http://217.29.139.44:555/track/ticket_info.php?code=${widget.trackingCode}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final document = parse(response.body);

      final Map<String, dynamic> data = {
        'Status': _extract(document, 'Status'),
        'Dispatch date': _extract(document, 'Dispatch date'),
        'registered Date': _extract(document, 'registered Date'),
        "Sender's name": _extract(document, "Sender's name"),
        "Sender's Phone number": _extract(document, "Sender's Phone number"),
        "Receiver's name": _extract(document, "Receiver's name"),
        "Receiver's phone number": _extract(document, "Receiver's phone number"),
        'Quantity': _extract(document, 'Quantity'),
        'Payment Option': _extract(document, 'Payment Option'),
        'Total Price': _extract(document, 'Total Price'),
      };

      // ✅ Log clean JSON
      print('🔍 Parsed JSON:');
      print(JsonEncoder.withIndent('  ').convert(data));

      setState(() {
        parsedData = data;
      });
    } else {
      print('❌ Failed to fetch page. Status: ${response.statusCode}');
    }
  }

  String _extract(document, String label) {
    try {
      final element = document.querySelectorAll('li').firstWhere(
            (el) => el.text.contains(label),
      );
      return element.text.split(' - ').last.trim();
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parsed Tracking Info")),
      body: parsedData == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: parsedData!.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            subtitle: Text(entry.value),
          );
        }).toList(),
      ),
    );
  }
}
