import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'localization.dart';
import 'main.dart'; // App home page

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String? selectedLanguage;
  final List<String> languages = ['English', 'Kiswahili', 'French'];
  final Map<String, String> languageCodes = {
    'English': 'en',
    'Kiswahili': 'sw',
    'French': 'fr',
  };
  final Color brandColor = Color(0xFFD32F2F); // Example brand color

  Future<void> completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingComplete', true);
    if (selectedLanguage != null) {
      await prefs.setString('languageCode', languageCodes[selectedLanguage!]!);
    }
  }

  void showLanguageSelectionPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final loc = AppLocalizations(Provider.of<LanguageProvider>(context, listen: false).languageCode);
        return AlertDialog(
          title: Text(loc.translate('no_language_selected')),
          content: Text(loc.translate('please_select_language')),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final loc = AppLocalizations(languageProvider.languageCode);

    return Scaffold(
      backgroundColor: brandColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/language_icon.png', // Path to your image asset
                height: 100,
              ),
              SizedBox(height: 40),
              Text(
                loc.translate('select_language'),
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              ...languages.map((language) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedLanguage == language ? Colors.white : Colors.transparent,
                    foregroundColor: selectedLanguage == language ? brandColor : Colors.white,
                    shadowColor: Colors.black,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: Colors.white),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    final code = languageCodes[language]!;
                    Provider.of<LanguageProvider>(context, listen: false).setLanguage(code);
                    setState(() {
                      selectedLanguage = language;
                    });
                  },
                  child: Text(language),
                ),
              )).toList(),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: brandColor,
                  shadowColor: Colors.black,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () async {
                  if (selectedLanguage != null) {
                    Provider.of<LanguageProvider>(context, listen: false)
                        .setLanguage(languageCodes[selectedLanguage!]!);
                    await completeOnboarding();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(),
                      ),
                    );
                  } else {
                    showLanguageSelectionPrompt(context);
                  }
                },
                child: Text(loc.translate('continue')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
