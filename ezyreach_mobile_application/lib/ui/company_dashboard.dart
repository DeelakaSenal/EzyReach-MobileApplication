import 'package:flutter/material.dart';

class CompanyDashboard extends StatefulWidget {
  const CompanyDashboard({super.key});

  @override
  _CompanyDashboardState createState() => _CompanyDashboardState();
}

class _CompanyDashboardState extends State<CompanyDashboard> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the AnimationController and SlideAnimation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // Adjusted AppBar height for the search bar
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF231942).withOpacity(0.8), // Slight transparency to match the theme
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)), // Rounded bottom corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Logo on the left
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(
                      'assets/loginlogo.png', // Logo image
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // Search bar
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search dashboard',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.3), // Slight transparency
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF231942)),
                      ),
                      style: const TextStyle(color: Colors.white), // White text for input
                    ),
                  ),
                  // Hamburger menu with animation
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); // Open the drawer
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF231942), // Drawer background color
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF8906E6), // Header color
              ),
              child: Text(
                'Company Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.business, color: Colors.white),
              title: const Text('Company Overview', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigate to company overview page
                Navigator.pop(context); // Close the drawer after tapping
              },
            ),
            ListTile(
              leading: const Icon(Icons.group, color: Colors.white),
              title: const Text('Team Management', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigate to team management page
                Navigator.pop(context); // Close the drawer after tapping
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Colors.white),
              title: const Text('Reports', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigate to reports page
                Navigator.pop(context); // Close the drawer after tapping
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigate to settings page
                Navigator.pop(context); // Close the drawer after tapping
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome to the Company Dashboard",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView(
                  children: [
                    _buildDashboardCard(
                      title: "Company Overview",
                      description: "View and manage your company details.",
                      icon: Icons.business,
                      onTap: () {
                        // Navigate to company overview page
                      },
                    ),
                    _buildDashboardCard(
                      title: "Team Management",
                      description: "Manage your team and their roles.",
                      icon: Icons.group,
                      onTap: () {
                        // Navigate to team management page
                      },
                    ),
                    _buildDashboardCard(
                      title: "Reports",
                      description: "Generate and view reports.",
                      icon: Icons.bar_chart,
                      onTap: () {
                        // Navigate to reports page
                      },
                    ),
                    _buildDashboardCard(
                      title: "Settings",
                      description: "Adjust application settings.",
                      icon: Icons.settings,
                      onTap: () {
                        // Navigate to settings page
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
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
        leading: Icon(
          icon,
          color: Colors.white,
          size: 40.0,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14.0,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
