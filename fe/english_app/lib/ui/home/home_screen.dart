import 'package:english_app/providers/auth_provider.dart';
import 'package:english_app/ui/chat/chatScreen.dart';
import 'package:english_app/ui/home/aptitude_test_screen.dart';
import 'package:english_app/ui/home/full_test.dart';
import 'package:english_app/ui/home/grammar_screen.dart';
import 'package:english_app/ui/home/mini_test_screen.dart';
import 'package:english_app/ui/home/rank_screen.dart';
import 'package:english_app/ui/home/skill_test_screen.dart';
import 'package:english_app/ui/home/update_vip_screen.dart';
import 'package:english_app/ui/login/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.loadUserData().then((_) {
      print('Loaded Email in HomeScreen: ${authProvider.email}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(authProvider), // Pass authProvider to display user data
          _buildFeatureGrid(context),
        ],
      ),
      floatingActionButton: _buildFloatingButton(context),
    );
  }

  /// AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Home"),
      backgroundColor: Colors.purple,
      leading: Builder(
        builder: (context) => IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
      ),
    );
  }

  /// Header
  Widget _buildHeader(AuthProvider authProvider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Image.asset(
            'assets/images/onboarding/onboarding2.jpg',
            width: 80,
            height: 80,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SPIDERMEO",
                style: GoogleFonts.roboto(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                "Email: ${authProvider.email ?? 'Not logged in'}",
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// FeatureGrid
  Widget _buildFeatureGrid(BuildContext context) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildFeatureCard(context, "Aptitude Test",
              "assets/images/onboarding/onboarding1.jpg", AptitudeTestScreen()),
          _buildFeatureCard(context, "Mini Test",
              "assets/images/onboarding/onboarding2.jpg", MiniTestScreen()),
          _buildFeatureCard(context, "Full Test",
              "assets/images/onboarding/onboarding3.jpg", FullTestScreen()),
          _buildFeatureCard(context, "Skill Test",
              "assets/images/onboarding/onboarding1.jpg", SkillTestScreen()),
          _buildFeatureCard(context, "Grammars",
              "assets/images/onboarding/onboarding2.jpg", GrammarScreen()),
          _buildFeatureCard(context, "Ranked",
              "assets/images/onboarding/onboarding3.jpg", RankScreen()),
        ],
      ),
    );
  }

  /// FeatureCard
  Widget _buildFeatureCard(
      BuildContext context, String title, String imagePath, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 80),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  /// (ChatAI Button)
  Widget _buildFloatingButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.purple,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GeminiChatScreen()),
        );
      },
      child: const Icon(Icons.chat, color: Colors.white),
    );
  }

  /// Drawer
  Widget _buildDrawer(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildDrawerHeader(),
            _buildDrawerItem(Icons.home, "Home", Colors.deepPurple, () {
              Navigator.pop(context); // Close the drawer
            }),
            _buildDrawerItem(
              Icons.admin_panel_settings,
              "VIP PREMIUM",
              Colors.purple,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateVipScreen()),
                );
              },
            ),
            const Divider(),
            _buildDrawerCategory("Study"),
            _buildDrawerItem(Icons.school, "Grammar", Colors.purple, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GrammarScreen()),
              );
            }),
            const Divider(),
            _buildDrawerCategory("Test"),
            _buildDrawerItem(Icons.quiz, "Aptitude Test", Colors.purple, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AptitudeTestScreen()),
              );
            }),
            _buildDrawerItem(Icons.edit, "Mini Test", Colors.purple, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MiniTestScreen()),
              );
            }),
            _buildDrawerItem(Icons.sort, "Skill Test", Colors.purple, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SkillTestScreen()),
              );
            }),
            _buildDrawerItem(Icons.headphones, "Full Test", Colors.purple, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FullTestScreen()),
              );
            }),
            const Divider(),
            _buildDrawerCategory("Profile"),
            _buildDrawerItem(
                Icons.person, "My information", Colors.purple, () {}),
            _buildDrawerItem(Icons.leaderboard, "Ranked", Colors.purple, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RankScreen()),
              );
            }),
            _buildDrawerItem(Icons.logout, "Log out", Colors.purple, () {
              authProvider.logout(); // Clear user data
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Drawer Header
  Widget _buildDrawerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Colors.purple,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Text(
            "SPIDERMEO",
            style: GoogleFonts.roboto(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            "Language Learning Application",
            style: GoogleFonts.roboto(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  /// Drawer Item
  Widget _buildDrawerItem(
      IconData icon, String title, Color iconColor, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: GoogleFonts.roboto(fontSize: 16)),
      onTap: onTap,
    );
  }

  /// Drawer Category
  Widget _buildDrawerCategory(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
