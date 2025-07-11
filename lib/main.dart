import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'splash_screen.dart';
import 'onboarding_screen.dart';
import 'enhanced_history_page.dart';
import 'track_page.dart';
import 'booking_page.dart';
import 'package:sr_classic_transport/contact_page.dart';
import 'settings_page.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'localization.dart';
/// Entry point of the SR Classic Transport application.
///
/// This function loads the saved theme and language settings and
/// determines whether onboarding should be shown before running
/// the app.


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isOnboardingComplete = prefs.getBool('isOnboardingComplete') ?? false;

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();
  final languageProvider = LanguageProvider();
  await languageProvider.loadLanguage();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: languageProvider),
      ],
      child: MyApp(isOnboardingComplete: isOnboardingComplete),
    ),
  );
}

/// Root widget that configures theming and localization.
///
/// Depending on whether onboarding is complete it shows the
/// home page or the onboarding screen.

class MyApp extends StatelessWidget {
  final bool isOnboardingComplete;

  const MyApp({super.key, required this.isOnboardingComplete});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'Sr Classic Coach',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData.light().copyWith(
        colorScheme: ThemeData.light().colorScheme.copyWith(primary: Colors.red),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.red,
        cardColor: Colors.red.shade50,
        iconTheme: const IconThemeData(color: Colors.red),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ThemeData.dark().colorScheme.copyWith(primary: Colors.red),
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.red,
        cardColor: Colors.grey[850],
        iconTheme: const IconThemeData(color: Colors.red),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),
      home: SplashScreen(isOnboardingComplete: isOnboardingComplete),
    );
  }
}

/// Stateful container for the five main navigation tabs.
/// It keeps track of the currently selected index and animates
/// page transitions.

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
      // Pages shown in the bottom navigation bar order.

    const TrackPage(key: ValueKey('TrackPage')),
    const BookingPage(key: ValueKey('BookingPage')),
    const EnhancedHistoryPage(key: ValueKey('HistoryPage')),
    const ContactLocationsPage(key: ValueKey('ContactPage')),
    const SettingsPage(key: ValueKey('SettingsPage')),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sr Classic Coach'),
        elevation: 0,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.map),
              label: AppLocalizations(Provider.of<LanguageProvider>(context).languageCode).translate('track'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.book_online_outlined),
              label: AppLocalizations(Provider.of<LanguageProvider>(context).languageCode).translate('booking'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.history),
              label: AppLocalizations(Provider.of<LanguageProvider>(context).languageCode).translate('history'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.contact_page_outlined),
              label: AppLocalizations(Provider.of<LanguageProvider>(context).languageCode).translate('contact'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: AppLocalizations(Provider.of<LanguageProvider>(context).languageCode).translate('settings'),
            ),
          ],
        ),
      ),
    );
  }
}
