import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'localization.dart';
import 'about_us_page.dart';
import 'terms_of_service_page.dart';
import 'contact_page.dart';

/// Settings and preferences for the application.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final loc = AppLocalizations(languageProvider.languageCode);

    void _showLanguageDialog(BuildContext context, LanguageProvider provider, AppLocalizations loc) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(loc.translate('change_language')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('English'),
                  onTap: () {
                    provider.setLanguage('en');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Kiswahili'),
                  onTap: () {
                    provider.setLanguage('sw');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('French'),
                  onTap: () {
                    provider.setLanguage('fr');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final isLight = Theme.of(context).brightness == Brightness.light;
              return AlertDialog(
                title: Text(
                  loc.translate('are_you_sure'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isLight ? Colors.black : null,
                  ),
                ),
                content: Text(loc.translate('remove_saved_number')),
                actions: [
                  TextButton(
                    child: Text(loc.translate('cancel')),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white, // Always white text
                    ),
                    child: Text(
                      loc.translate('forget'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('savedPhoneNumber');
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(loc.translate('saved_number_forgotten'))),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(Icons.delete_outline),
        label: Text(loc.translate('forget_saved_number')),
        backgroundColor: Colors.red,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // SR Classic Logo
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Image.asset(
                  'assets/images/sr_classic_logo.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 24),

            SectionTitle(title: loc.translate('legal')),
            SettingItem(
              icon: Icons.info_outline,
              title: loc.translate('about_us'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AboutUsPage()),
                );
              },
            ),
              SettingItem(
                icon: Icons.description_outlined,
                title: loc.translate('terms_of_service'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TermsOfServicePage()),
                  );
                },
              ),
              SettingItem(
                icon: Icons.contact_page_outlined,
                title: loc.translate('contact_us'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ContactLocationsPage()),
                  );
                },
              ),

            const SizedBox(height: 24),

            SectionTitle(title: loc.translate('preferences')),
            ThemeToggleSwitch(),

            const SizedBox(height: 24),

            SectionTitle(title: loc.translate('settings')),
            SettingItem(
              icon: Icons.language_outlined,
              title: loc.translate('change_language'),
              onTap: () {
                _showLanguageDialog(context, languageProvider, loc);
              },
            ),
            SettingItem(
              icon: Icons.share_outlined,
              title: loc.translate('share_app'),
              onTap: () {
                Share.share('Check out SR Classic Transport App!');
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Section Title
/// Small heading used to group related settings.
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          fontSize: 12,
        ),
      ),
    );
  }
}

// Setting Item Card
/// Reusable card used throughout the settings list.
class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const SettingItem({super.key, required this.icon, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).iconTheme.color),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap ?? () {},
      ),
    );
  }
}

// Theme Toggle Widget
/// Card that lets the user pick between light, dark or system theme.
class ThemeToggleSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final loc = AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);
    final current = themeProvider.themeMode;
    final isLight = Theme.of(context).brightness == Brightness.light;

    void _showThemeDialog() {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            loc.translate('select_theme'),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isLight ? Colors.black : null,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue: current,
                title: Text(loc.translate('system_default')),
                onChanged: (val) {
                  themeProvider.setTheme(val!);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: current,
                title: Text(loc.translate('light_mode')),
                onChanged: (val) {
                  themeProvider.setTheme(val!);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: current,
                title: Text(loc.translate('dark_mode')),
                onChanged: (val) {
                  themeProvider.setTheme(val!);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.dark_mode),
        title: Text(loc.translate('app_theme')),
        subtitle: Text(
          current == ThemeMode.light
              ? loc.translate('light_mode')
              : current == ThemeMode.dark
                  ? loc.translate('dark_mode')
                  : loc.translate('system_default'),
        ),
        trailing: const Icon(Icons.arrow_drop_down),
        onTap: _showThemeDialog,
      ),
    );
  }
}
