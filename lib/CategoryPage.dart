import 'package:flutter/material.dart';

class Categorypage extends StatefulWidget {
  const Categorypage({super.key});

  @override
  State<Categorypage> createState() => _CategorypageState();
}

class _CategorypageState extends State<Categorypage> {
  List<Map<String, dynamic>> categories = [
    {
      'label': 'Espresso',
      'image': 'assets/images/EspressoShot.jpg',
    },
    {
      'label': 'Latte',
      'image': 'assets/images/CaffeLatte.jpg',
    },
    {
      'label': 'Cappuccino',
      'image': 'assets/images/Cappuccino.jpg',
    },
    {
      'label': 'Americano',
      'image': 'assets/images/IcedAmericano.jpg',
    },
    {
      'label': 'Mocha',
      'image': 'assets/images/Mocha.jpg',
    },
    {
      'label': 'Cold Brew',
      'image': 'assets/images/Cold_Brew.jpg',
    },
    {
      'label': 'Desserts',
      'image': 'assets/images/Desserts.jpg',
    },
    {
      'label': 'Coffee Beans',
      'image': 'assets/images/Coffee_Beans.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3F0),

      // APP BAR
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,
        title: const Text(
          'Categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: categories.isEmpty
          ? _buildEmptyState()
          : GridView.builder(
        padding: const EdgeInsets.all(16),

        itemCount: categories.length,

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.82,
        ),

        itemBuilder: (context, index) {
          final category = categories[index];

          return _buildCategoryCard(
            category['label'],
            category['image'],
          );
        },
      ),
    );
  }

  // CATEGORY CARD
  Widget _buildCategoryCard(String label, String image) {
    return GestureDetector(
      onTap: () {
        print('Selected category: $label');
      },

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),

          child: Stack(
            children: [

              // IMAGE
              Positioned.fill(
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.brown[100],
                      child: Icon(
                        Icons.local_cafe_rounded,
                        size: 45,
                        color: Colors.brown[600],
                      ),
                    );
                  },
                ),
              ),

              // DARK GRADIENT
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.05),
                        Colors.black.withOpacity(0.75),
                      ],
                    ),
                  ),
                ),
              ),

              // COFFEE ICON
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(7),

                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.local_cafe_rounded,
                    size: 18,
                    color: Colors.brown,
                  ),
                ),
              ),

              // CATEGORY NAME
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,

                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // EMPTY STATE
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 70,
            color: Colors.grey[400],
          ),

          const SizedBox(height: 15),

          Text(
            'No categories found',
            style: TextStyle(
              fontSize: 17,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            'Categories will appear here',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}