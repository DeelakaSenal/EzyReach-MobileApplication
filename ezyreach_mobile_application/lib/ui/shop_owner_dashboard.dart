import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'coke_details.dart';
import 'about_us.dart';
import 'AccountPage.dart';
import '../widgets/slider_cards.dart';
import '../widgets/app_bar.dart';
import '../widgets/ham_menu.dart';

class Company {
  final String companyName;
  final String logoUrl;

  Company({
    required this.companyName,
    required this.logoUrl,
  });

  factory Company.fromMap(Map<String, dynamic> map) {
    return Company(
      companyName: map['companyName'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
    );
  }
}

class ShopOwnerDashboard extends StatefulWidget {
  const ShopOwnerDashboard({super.key});

  @override
  _ShopOwnerDashboardState createState() => _ShopOwnerDashboardState();
}

class _ShopOwnerDashboardState extends State<ShopOwnerDashboard> with TickerProviderStateMixin {
  late AnimationController _menuAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _menuRotationAnimation;
  bool isMenuOpen = false;

  final List<CardData> cardDataList = [
    CardData(imagePath: 'assets/slider1.png'),
    CardData(imagePath: 'assets/slider2.png'),
    CardData(imagePath: 'assets/slider3.png'),
  ];

  @override
  void initState() {
    super.initState();
    _menuAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _menuAnimationController,
      curve: Curves.easeInOut,
    ));
    _menuRotationAnimation = Tween<double>(begin: 0, end: 0.5)
        .animate(CurvedAnimation(
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
        icon: Icons.person_outline,
        title: 'Account',
        onTap: () {
          _toggleMenu();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountPage(collectionType: 'shop_owner',),
            ),
          );
        },
      ),
      DrawerMenuItem(
        icon: Icons.add_box_outlined,
        title: 'Add New Product',
        onTap: () {
          _toggleMenu();
          print('Add New Product selected');
        },
      ),
      DrawerMenuItem(
        icon: Icons.info_outlined,
        title: 'About Us',
        onTap: () {
          _toggleMenu();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AboutUsPage(),
            ),
          );
        },
      ),
      DrawerMenuItem(
        icon: Icons.logout_outlined,
        title: 'Logout',
        onTap: () {
          _toggleMenu();
          print('Logout selected');
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        print('Add Product button pressed');
                      },
                      icon: const Icon(
                        Icons.add_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      label: const Text(
                        "Add Product",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB077E3).withOpacity(0.5),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ),
                SliderCards(cards: cardDataList),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Companies",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('company').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text('No companies available'),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          final company = Company.fromMap(doc.data() as Map<String, dynamic>);

                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Changed from start to spaceBetween
                              mainAxisSize: MainAxisSize.max, // Changed from min to max
                              children: [
                                // Company Logo Section
                                Container(
                                  height: 90, // Slightly reduced from 100
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(15),
                                    ),
                                  ),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        company.logoUrl,
                                        width: 60, // Slightly reduced from 70
                                        height: 60, // Slightly reduced from 70
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 60,
                                            height: 60,
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.error_outline),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                // Company Name Section
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8, // Reduced from 12
                                    vertical: 4, // Reduced from 8
                                  ),
                                  child: Text(
                                    company.companyName,
                                    style: const TextStyle(
                                      fontSize: 14, // Reduced from 16
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                // Order Button - Moved padding inside the button's style
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                      bottom: 8,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        print('Order from ${company.companyName}');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFB077E3),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 6), // Reduced from 8
                                        minimumSize: const Size(double.infinity, 32), // Reduced height from 40
                                        maximumSize: const Size(double.infinity, 32), // Reduced height from 40
                                      ),
                                      child: const Text(
                                        'Order',
                                        style: TextStyle(
                                          fontSize: 12, // Reduced from 14
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );

                        },
                      );
                    },
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
}