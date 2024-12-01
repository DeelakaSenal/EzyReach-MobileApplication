import 'package:flutter/material.dart';
import 'coke_details.dart';

class ShopOwnerDashboard extends StatelessWidget {
  const ShopOwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // Adjusted AppBar height for the search bar
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF231942).withOpacity(0.8), // Slight transparency to match the theme
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/loginlogo.png', // Logo image
                          width: 60, // Adjusted size for larger logo
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  // Search bar
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: buildDrawer(context), // Side navigation panel (Drawer)
      body: Column(
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
    );
  }

  // Build the Drawer (side navigation panel)
  Drawer buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
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
              height: 100, // Adjust the height for grid layout
              width: double.infinity, // Make width take full space
              fit: BoxFit.cover, // Ensures the image covers the space properly
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 100,
                  color: Colors.grey[200], // Placeholder color
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
              // Navigate to the CokeDetails page when the button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CokeDetails(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF231942), // Updated button color
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
