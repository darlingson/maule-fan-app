import 'package:flutter/material.dart';
import 'package:maule_fan_app/presentation/screens/home_screen.dart';
import 'package:maule_fan_app/presentation/screens/matches_screen.dart';
import 'package:maule_fan_app/presentation/screens/players_screen.dart';
import 'package:maule_fan_app/presentation/screens/team_profile_screen.dart';
import 'package:maule_fan_app/presentation/screens/user_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final _primaryRed = Color(0xFFDA1A32);
  static final _secondaryWhite = Colors.white;

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maule Fan App',
      theme: ThemeData(
        primaryColor: _primaryRed,
        scaffoldBackgroundColor: _secondaryWhite,
        appBarTheme: AppBarTheme(
          backgroundColor: _primaryRed,
          foregroundColor: _secondaryWhite,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: _primaryRed,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: SplashRouter(),
    );
  }
}

class SplashRouter extends StatefulWidget {
  const SplashRouter({super.key});

  @override
  _SplashRouterState createState() => _SplashRouterState();
}

class _SplashRouterState extends State<SplashRouter> {
  bool _loading = true;
  bool _seenOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingSeen();
  }

  void _checkOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = prefs.getBool('seen_onboarding') ?? false;
    // Removed hardcoded override to allow persistence
    setState(() {
      _seenOnboarding = seen;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _seenOnboarding ? MainScreen() : OnboardingScreen();
  }
}

class OnboardingScreen extends StatelessWidget {
  final PageController _controller = PageController();

  OnboardingScreen({super.key});

  void _completeOnboarding(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [
          _buildPage(context, "Welcome", "To the Maule Fan app."),
          _buildPage(
            context,
            "Live Updates",
            "Stay informed with latest match news.",
          ),
          _buildPage(
            context,
            "Let’s Go",
            "Enjoy everything Big Bullets in one app.",
            isLast: true,
            onDone: () => _completeOnboarding(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(
    BuildContext context,
    String title,
    String desc, {
    bool isLast = false,
    VoidCallback? onDone,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_soccer, size: 100, color: Colors.red),
          SizedBox(height: 40),
          Text(
            title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          SizedBox(height: 20),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 60),
          if (isLast)
            ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text("Get Started", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [HomeScreen(), MatchesScreen(teamId: 1), PlayersScreen()];
  final List<String> _titles = ['Home', 'Matches', 'Players'];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _navigateToUserProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserProfileScreen()),
    );
  }

  void _navigateToTeamProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TeamProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => _navigateToUserProfile(context),
          ),
          IconButton(
            icon: const Icon(Icons.sports_soccer),
            onPressed: () => _navigateToTeamProfile(context),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: 'Matches'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Players'),
        ],
      ),
    );
  }
}
