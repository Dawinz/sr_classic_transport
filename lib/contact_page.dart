import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactLocationsPage extends StatelessWidget {
  const ContactLocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.grey[900] : Colors.red.shade600;
    final textColor = Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Contacts'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _buildSection(
            context,
            country: 'Tanzania',
            city: 'Dar es salaam',
            image: 'tanzania_dar.png',
            location: 'Dar es salaam, lindi/iringa',
            phones: ['+255 682 756 699'],
          ),
          _buildSection(
            context,
            country: 'Drc Congo',
            city: 'Lumbumbashi',
            image: 'drc_lubumbashi.png',
            location: 'Lumbumbashi, Kabalo sandoa',
            phones: ['+243 826 038 458'],
          ),
          _buildSection(
            context,
            country: 'Kenya',
            city: 'Nairobi',
            image: 'kenya_nairobi.png',
            location: 'Duruma Road opposite Dream line',
            phones: ['+254 719 855 504'],
          ),
          _buildSection(
            context,
            country: 'Uganda',
            city: 'Kampala',
            image: 'uganda_kampala.png',
            location: 'Martin road, old Kampala',
            phones: ['+256 787 341 775', '+256 757 982 860'],
          ),
          _buildSection(
            context,
            country: 'Zimbabwe',
            city: 'Harare',
            image: 'zimbabwe_harare.png',
            location: 'Robert Mugabe and Fifthy street',
            phones: ['+263 772 835 816', '+263 777 477 464'],
          ),
          _buildSection(
            context,
            country: 'Zambia',
            city: 'Lusaka',
            image: 'zambia_lusaka.png',
            location: 'Intercity Bus Terminal, Shop #5',
            phones: ['+260 973 456 789'],
          ),
        _buildSection(
          context,
          country: 'Burundi',
          city: 'Bujumbura',
          image: 'burundi_bujumbura.png',
          location: 'Avenue du Large, Zone Rohero',
          phones: ['+257 612 345 67'],
        ),
      ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _launchWhatsApp,
        child: const FaIcon(FontAwesomeIcons.whatsapp),
      ),
    );
  }

  void _launchWhatsApp() async {
    final uri = Uri.parse('https://wa.me/255682756699');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callPhoneNumber(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Widget _buildSection(
      BuildContext context, {
        required String country,
        required String city,
        required String image,
        required String location,
        required List<String> phones,
      }) {
    final textColor = Colors.white;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          country,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          city,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/$image',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (location.isNotEmpty)
                    Text(
                      location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(height: 6),
                  ...phones.map(
                    (phone) => GestureDetector(
                      onTap: () => _callPhoneNumber(phone),
                      child: Text(
                        phone,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(color: Colors.white30, height: 30),
      ],
    );
  }
}
