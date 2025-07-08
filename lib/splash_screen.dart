import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'providers/theme_provider.dart';
import 'onboarding_screen.dart';
import 'enhanced_history_page.dart';
import 'track_page.dart';
import 'booking_page.dart';
import 'contact_page.dart';
import 'settings_page.dart';
import 'localization.dart';

class SplashScreen extends StatefulWidget {
  final bool isOnboardingComplete;

  const SplashScreen({
    super.key,
    required this.isOnboardingComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Create fade animation
    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeInOut),
    ));

    // Create scale animation for a subtle zoom effect
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));

    // Start the animation sequence
    _startAnimation();
  }

  void _startAnimation() async {
    // Wait for 3 seconds, then start fade out
    await Future.delayed(const Duration(milliseconds: 3000));
    
    if (mounted) {
      _animationController.forward().then((_) {
        _navigateToNextScreen();
      });
    }
  }

  void _navigateToNextScreen() {
    if (widget.isOnboardingComplete) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const HomePage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return OnboardingScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with shadow and glow effect
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // App name with fade animation
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Sr Classic Coach',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Tagline with fade animation
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Connecting East & Central Africa',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // Loading indicator
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.red.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Home page widget that contains the main navigation
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    TrackPage(key: ValueKey('TrackPage')),
    BookingPage(key: ValueKey('BookingPage')),
    EnhancedHistoryPage(key: ValueKey('HistoryPage')),
    ContactLocationsPage(key: ValueKey('ContactPage')),
    SettingsPage(key: ValueKey('SettingsPage')),
  ];

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