import 'package:flutter/material.dart';
import 'coke_details.dart';

class ShopOwnerDashboard extends StatefulWidget {
  const ShopOwnerDashboard({super.key});

  @override
  _ShopOwnerDashboardState createState() => _ShopOwnerDashboardState();
}

class _ShopOwnerDashboardState extends State<ShopOwnerDashboard> with TickerProviderStateMixin {
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
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0), // Start off-screen to the right
      end: Offset.zero, // End at the normal position
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
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
            color: const Color(0xFF231942).withOpacity(0.8), // Slight transparency
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20), // Rounded bottom corners
            ),
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
                  // Search bar in the center
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search products',
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
                  // Hamburger menu with dropdown options
                  IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      if (_animationController.isCompleted) {
                        _animationController.reverse(); // Close the menu
                      } else {
                        _animationController.forward(); // Open the menu
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Main content of the dashboard
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Featured Products",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 2, // Two items per row
                    crossAxisSpacing: 16, // Space between columns
                    mainAxisSpacing: 16, // Space between rows
                    children: [
                      buildProductCard('assets/coke.jpeg', context),
                      buildProductCard('assets/elephanthouse.jpeg', context),
                      buildProductCard('assets/unilever.jpeg', context),
                      buildProductCard('assets/kandos.jpg', context),
                      buildProductCard('assets/maliban.jpg', context), // New product
                      buildProductCard('assets/munchee.png', context), // New product
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Drawer with sliding and fading animation
          SlideTransition(
            position: _slideAnimation,
            child: FadeTransition( // Optional fade-in effect
              opacity: _animationController, // Fade opacity matches animation progress
              child: Align(
                alignment: Alignment.centerRight, // Align the drawer on the right
                child: Container(
                  width: MediaQuery.of(context).size.width / 2, // Drawer width: 1/2 of screen
                  color: Colors.white,
                  child: Drawer(
                    child: Column(
                      children: [
                        // Removed "Menu" word and section
                        // Menu options
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.person, color: Color(0xFF231942)),
                                title: const Text('Account'),
                                onTap: () {
                                  Navigator.pop(context);
                                  print('Account selected');
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.add_box, color: Color(0xFF231942)),
                                title: const Text('Add New Product'),
                                onTap: () {
                                  Navigator.pop(context);
                                  print('Add New Product selected');
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.info, color: Color(0xFF231942)),
                                title: const Text('About Us'),
                                onTap: () {
                                  Navigator.pop(context);
                                  print('About Us selected');
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.logout, color: Color(0xFF231942)),
                                title: const Text('Logout'),
                                onTap: () {
                                  Navigator.pop(context);
                                  print('Logout selected');
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build a modern card for each product
  Widget buildProductCard(String image, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              image,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  color: Colors.grey[200],
                  child: const Icon(
                    Icons.broken_image,
                    size: 60,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CokeDetails(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF231942),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "View Details",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
