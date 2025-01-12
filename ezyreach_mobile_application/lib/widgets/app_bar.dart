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
  final FocusNode _searchFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

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
    _removeOverlay();
    _searchFocusNode.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _createOverlay() {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () {
            _hideSearch();
            _removeOverlay();
          },
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideSearch() {
    setState(() {
      isSearchVisible = false;
      _searchAnimationController.reverse();
      _searchFocusNode.unfocus();
    });
  }

  void _showSearch() {
    setState(() {
      isSearchVisible = true;
      _searchAnimationController.forward();
      _searchFocusNode.requestFocus();
      _createOverlay();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
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
                            focusNode: _searchFocusNode,
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
                              prefixIcon: const Icon(Icons.search_outlined, color: Colors.white54),
                            ),
                            style: const TextStyle(color: Colors.white),
                            onSubmitted: (value) {
                              _hideSearch();
                              _removeOverlay();
                              // Handle search submission here
                            },
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
                    onPressed: _showSearch,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}