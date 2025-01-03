import 'package:flutter/material.dart';
import 'about_us.dart';
import '../widgets/slider_cards.dart';
import '../widgets/app_bar.dart';  // Import the custom widgets
import '../widgets/ham_menu.dart';
import 'AccountPage.dart';

class SalesRepDashboard extends StatefulWidget {
  const SalesRepDashboard({super.key});

  @override
  _SalesRepDashboardState createState() => _SalesRepDashboardState();
}

class _SalesRepDashboardState extends State<SalesRepDashboard> with TickerProviderStateMixin {
  late AnimationController _menuAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _menuRotationAnimation;
  bool isMenuOpen = false;

  final List<CardData> _cards = [
    CardData(
      title: "Today's Updates",
      content: "10 new shops added in your area",
      icon: Icons.update,
      color: Color(0xFF5C4B99),
    ),
    CardData(
      title: "Performance",
      content: "Your visits are up by 25%",
      icon: Icons.trending_up,
      color: Color(0xFF9F91CC),
    ),
    CardData(
      title: "Tasks",
      content: "5 pending shop visits",
      icon: Icons.task_alt,
      color: Color(0xFFA459D1),
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
        title: 'Profile',
        onTap: () {
          _toggleMenu();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>const AccountPage(collectionType: 'sales-rep')),
          );
        },
      ),
      DrawerMenuItem(
        icon: Icons.storefront_outlined,
        title: 'My Shops',
        onTap: () {
    _toggleMenu();
    Navigator.pop(context);
    },
      ),
      DrawerMenuItem(
        icon: Icons.info_outline,
        title: 'About Us',
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
        appBar: CustomAppBar(
          onMenuPressed: _toggleMenu,
          menuRotationAnimation: _menuRotationAnimation,
          logoPath: 'assets/dashIMG.png',
        ),
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SliderCards(cards: _cards),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Discover shops",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 250,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return buildProductCard(context);
                      },
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

  Widget buildProductCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: const Center(
              child: Icon(
                Icons.store,
                size: 60,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF231942),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Visit Shop",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}