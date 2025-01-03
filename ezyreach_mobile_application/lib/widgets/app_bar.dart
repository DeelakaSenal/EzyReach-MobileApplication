// custom_app_bar.dart
import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final Animation<double> menuRotationAnimation;
  final String logoPath;

  const CustomAppBar({
    Key? key,
    required this.onMenuPressed,
    required this.menuRotationAnimation,
    this.logoPath = 'assets/dashIMG.png',
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _searchAnimationController;
  late Animation<double> _searchBarAnimation;
  bool isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    _searchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _searchBarAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      isSearchVisible = !isSearchVisible;
      if (isSearchVisible) {
        _searchAnimationController.forward();
      } else {
        _searchAnimationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF231942).withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: RotationTransition(
                  turns: widget.menuRotationAnimation,
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: widget.onMenuPressed,
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: isSearchVisible ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: Image.asset(
                  widget.logoPath,
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
              AnimatedBuilder(
                animation: _searchBarAnimation,
                builder: (context, child) {
                  return Positioned.fill(
                    child: AnimatedOpacity(
                      opacity: isSearchVisible ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: TextField(
                          autofocus: isSearchVisible,
                          decoration: InputDecoration(
                            hintText: 'Search shops',
                            hintStyle: const TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.3),
                            contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.search, color: Colors.white54),
                          ),
                          style: const TextStyle(color: Colors.white),
                          onEditingComplete: _toggleSearch,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    if (!isSearchVisible) {
                      _toggleSearch();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}