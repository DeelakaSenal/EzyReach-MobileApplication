import 'package:flutter/material.dart';
import 'coke_details.dart';
import 'about_us.dart';
import 'AccountPage.dart';
import '../widgets/slider_cards.dart';
import '../widgets/app_bar.dart';
import '../widgets/ham_menu.dart';

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
    CardData(
      title: 'Product 1',
      content: 'Details about Product 1',
      icon: Icons.shopping_cart,
      color: Colors.blue,
    ),
    CardData(
      title: 'Product 2',
      content: 'Details about Product 2',
      icon: Icons.local_offer,
      color: Colors.green,
    ),
    CardData(
      title: 'Product 3',
      content: 'Details about Product 3',
      icon: Icons.star,
      color: Colors.orange,
    ),
  ];

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
                SliderCards(cards: cardDataList),
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
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        buildProductCard('assets/coke.jpeg', context),
                        buildProductCard('assets/elephanthouse.jpeg', context),
                        buildProductCard('assets/unilever.jpeg', context),
                        buildProductCard('assets/kandos.jpg', context),
                        buildProductCard('assets/maliban.jpg', context),
                        buildProductCard('assets/munchee.png', context),
                      ],
                    ),
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