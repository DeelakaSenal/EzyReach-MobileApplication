import 'package:flutter/material.dart';

class CokeDetails extends StatelessWidget {
  const CokeDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coca-cola'),
        backgroundColor: const Color(0xFFC484F1), // Use the same theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 3), // Shadow position
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
              children: [
                // Coke image
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/coke.jpeg',
                    height: 180, // Adjust the height to fit better
                    width: double.infinity, // Make width take full space
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  'Coca-Cola',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                const Text(
                  'Coca-Cola (Coke) is one of the world\'s most popular carbonated soft drinks, first introduced in 1886. '
                      'It is known for its refreshing taste, sweet flavor, and fizzy texture. Typically, Coke is served chilled '
                      'and is enjoyed as a refreshing beverage in various settings, from casual gatherings to parties. '
                      'The drink contains carbonated water, high fructose corn syrup (or sugar), caramel color, caffeine, '
                      'and other natural flavors. It is available in various packaging sizes, including bottles, cans, and fountains.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center, // Center text horizontally
                ),
                const SizedBox(height: 16),

                // Contact Supplier Button
                ElevatedButton(
                  onPressed: () {
                    print('Contact Supplier button pressed');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF231942), // Dark purple button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Place Order',
                    style: TextStyle(color: Colors.white),
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
