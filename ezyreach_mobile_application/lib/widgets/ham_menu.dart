// custom_drawer.dart
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
final Animation<Offset> slideAnimation;
final Animation<double> fadeAnimation;
final List<DrawerMenuItem> menuItems;

const CustomDrawer({
super.key,
required this.slideAnimation,
required this.fadeAnimation,
required this.menuItems,
});

@override
Widget build(BuildContext context) {
return SlideTransition(
position: slideAnimation,
child: FadeTransition(
opacity: fadeAnimation,
child: GestureDetector(
onTap: () {}, // Prevent tap from closing menu
child: Container(
width: MediaQuery.of(context).size.width * 0.6,
height: MediaQuery.of(context).size.height,
decoration: BoxDecoration(
color: Colors.white,
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.1),
blurRadius: 10,
spreadRadius: 2,
),
],
),
child: Column(
children: [
const SizedBox(height: 15),
...menuItems.map((item) => _buildMenuItem(
context,
item.icon,
item.title,
item.onTap,
)),
],
),
),
),
),
);
}

Widget _buildMenuItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
return InkWell(
onTap: onTap,
child: Container(
padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
child: Row(
children: [
Icon(icon, color: const Color(0xFF231942), size: 24),
const SizedBox(width: 16),
Text(
title,
style: const TextStyle(
color: Color(0xFF231942),
fontSize: 16,
fontWeight: FontWeight.w500,
),
),
],
),
),
);
}
}

class DrawerMenuItem {
final IconData icon;
final String title;
final VoidCallback onTap;

DrawerMenuItem({
required this.icon,
required this.title,
required this.onTap,
});
}
