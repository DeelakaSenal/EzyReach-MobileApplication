import 'package:flutter/material.dart';
import '../widgets/slider_cards.dart'; // Replace with the actual path to your SliderCards file
import '../widgets/app_bar.dart'; // Replace with the actual path to your CustomAppBar file
import '../widgets/ham_menu.dart'; // Replace with the actual path to your CustomDrawer file
import 'about_us.dart';
import 'AccountPage.dart';
class CompanyDashboard extends StatefulWidget {
  const CompanyDashboard({super.key});

  @override
  _CompanyDashboardState createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> with TickerProviderStateMixin {
  late AnimationController _menuAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _menuRotationAnimation;
  bool isMenuOpen = false;

  @override
  void initState() {
    super.initState();
    _menuAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _menuAnimationController,
      curve: Curves.easeInOut,
    ));
    _menuRotationAnimation = Tween<double>(
      begin: 0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _menuAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _menuAnimationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
      if (isMenuOpen) {
        _menuAnimationController.forward();
      } else {
        _menuAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<DrawerMenuItem> menuItems = [
      DrawerMenuItem(
        icon: Icons.business,
        title: 'Company Profile',
        onTap: () {
          _toggleMenu();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>const AccountPage(collectionType: 'company')),
          );
        },
      ),
      DrawerMenuItem(
        icon: Icons.add_box_outlined,
        title: 'Products',
        onTap: () {
          _toggleMenu();
          Navigator.pop(context);
        },
      ),
      DrawerMenuItem(
        icon: Icons.info_outlined,
        title: 'About us',
        onTap: () {
          _toggleMenu();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutUsPage()),
          );
        },
      ),
      DrawerMenuItem(
        icon: Icons.logout_outlined,
        title: 'Logout',
        onTap: () {
          _toggleMenu();
          Navigator.pop(context);
        },
      ),
    ];

    return GestureDetector(
      onTap: () {
        if (isMenuOpen) {
          _toggleMenu();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF3E5F5),
        appBar: CustomAppBar(
          onMenuPressed: _toggleMenu,
          menuRotationAnimation: _menuRotationAnimation,
          logoPath: 'assets/loginlogo.png',
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SliderCards(
                  cards: [
                    CardData(imagePath: 'assets/slider1.png'),
                    CardData(imagePath: 'assets/slider2.png'),
                    CardData(imagePath: 'assets/slider3.png'),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Dashboard Insights",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      _buildDashboardCard(
                        title: "Company Overview",
                        description: "View and manage your company details.",
                        icon: Icons.business,
                        onTap: () {},
                      ),
                      _buildDashboardCard(
                        title: "Team Management",
                        description: "Manage your team and their roles.",
                        icon: Icons.group,
                        onTap: () {},
                      ),
                      _buildDashboardCard(
                        title: "Reports",
                        description: "Generate and view reports.",
                        icon: Icons.bar_chart,
                        onTap: () {},
                      ),
                      _buildDashboardCard(
                        title: "Settings",
                        description: "Adjust application settings.",
                        icon: Icons.settings,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CustomDrawer(
              slideAnimation: _slideAnimation,
              fadeAnimation: _menuAnimationController,
              menuItems: menuItems,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      color: const Color(0xFF8906E6),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(icon, color: Colors.white, size: 40.0),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(color: Colors.white70, fontSize: 14.0),
        ),
        onTap: onTap,
      ),
    );
  }
}
