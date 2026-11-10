import 'dart:async';
import 'package:flutter/material.dart';
import 'Detail_Page.dart';

class Homepage extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteItems;
  final void Function(Map<String, dynamic> product) onToggleFavorite;

  // FIX 1: Update callback signature to accept optional quantity and size
  final void Function(
      Map<String, dynamic> product, {
      int quantity,
      String size,
      }) onAddToCart;

  const Homepage({
    super.key,
    required this.favoriteItems,
    required this.onToggleFavorite,
    required this.onAddToCart,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool showAllCategories = false;
  bool showAllProducts = false;

  // === Banner switch auto matic
  late PageController _pageController;
  int _currentPage = 0;

  final List<String> banners = [
    'assets/images/Banner1.jpg',
    'assets/images/Banner2.jpg',
    'assets/images/Banner3.jpg',
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;

        if (_currentPage >= banners.length) {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
  // ====

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {"title": "Espresso", "icon": Icons.local_cafe},
      {"title": "Latte", "icon": Icons.coffee},
      {"title": "Cappuccino", "icon": Icons.coffee_maker},
      {"title": "Cold Brew", "icon": Icons.ac_unit},
      {"title": "Iced Coffee", "icon": Icons.icecream},
      {"title": "Pastry", "icon": Icons.bakery_dining},
    ];

    // Products Data
    final List<Map<String, dynamic>> products = [
      {
        "title": "Coffee Latte",
        "category": "Hot Coffee",
        "price": 4.50,
        "image": "assets/images/CaffeLatte.jpg",
      },
      {
        "title": "Caramel Macchiato",
        "category": "Cold Coffee",
        "price": 5.20,
        "image": "assets/images/CaramelMacchiato.jpg",
      },
      {
        "title": "Iced Americano",
        "category": "Cold Coffee",
        "price": 3.80,
        "image": "assets/images/IcedAmericano.jpg",
      },
      {
        "title": "Espresso Shot",
        "category": "Hot Coffee",
        "price": 2.99,
        "image": "assets/images/EspressoShot.jpg",
      },
      {
        "title": "Cappuccino",
        "category": "Hot Coffee",
        "price": 3.80,
        "image": "assets/images/Cappuccino.jpg",
      },
      {
        "title": "Matcha",
        "category": "Hot Coffee",
        "price": 2.99,
        "image": "assets/images/Matcha.jpg",
      },
      {
        "title": "Cold brew",
        "category": "Cold Coffee",
        "price": 3.80,
        "image": "assets/images/Cold_Brew.jpg",
      },
      {
        "title": "Dessert",
        "category": "Dessert",
        "price": 2.99,
        "image": "assets/images/Desserts.jpg",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        elevation: 0,
        title: const Text(
          'Coffee Shop',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: const [
          Icon(Icons.notifications_active_sharp, color: Colors.white),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 140,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: banners.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.asset(
                            banners[index],
                            width: double.infinity,
                            height: 140,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      banners.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 18 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.brown
                              : Colors.brown.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        showAllCategories = !showAllCategories;
                      });
                    },
                    child: SizedBox(
                      height: 30,
                      width: 70,
                      child: Center(
                        child: Text(
                          showAllCategories ? 'Show Less' : 'See All',
                          style: const TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              showAllCategories
                  ? GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(categories[index]["icon"], color: Colors.brown, size: 30),
                        const SizedBox(height: 6),
                        Text(categories[index]["title"], style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              )
                  : SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
                              ],
                            ),
                            child: Icon(categories[index]["icon"], color: Colors.brown),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            categories[index]["title"],
                            style: const TextStyle(fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Coffee',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        showAllProducts = !showAllProducts;
                      });
                    },
                    child: SizedBox(
                      height: 30,
                      width: 70,
                      child: Center(
                        child: Text(
                          showAllProducts ? 'Show Less' : 'See All',
                          style: const TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.86,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 18,
                ),
                itemCount: showAllProducts ? products.length : 4,
                itemBuilder: (context, index) {
                  final product = products[index];
                  final isItemFavorite = widget.favoriteItems.any((item) => item['title'] == product['title']);

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 1),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                      title: product["title"],
                                      category: product["category"],
                                      price: "\$${(product["price"] as double).toStringAsFixed(2)}",
                                      imagePath: product["image"],
                                      favoriteItems: widget.favoriteItems,
                                      onToggleFavorite: widget.onToggleFavorite,

                                      // FIX 2: Correctly pass quantity and size parameters
                                      onAddToCart: (prod, qty, size) {
                                        widget.onAddToCart(
                                          prod,
                                          quantity: qty,
                                          size: size,
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.asset(
                                  product["image"],
                                  height: 110,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () => widget.onToggleFavorite(product),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isItemFavorite ? Icons.favorite : Icons.favorite_border,
                                    size: 16,
                                    color: isItemFavorite ? Colors.red : Colors.brown,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product["title"],
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                product["category"],
                                style: const TextStyle(color: Colors.grey, fontSize: 11),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${product["price"]}',
                                    style: const TextStyle(
                                      color: Colors.brown,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  GestureDetector(
                                    // FIX 3: Specify default quantity and size for quick add button
                                    onTap: () => widget.onAddToCart(
                                      product,
                                      quantity: 1,
                                      size: 'Medium',
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.brown,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(Icons.add, color: Colors.white, size: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}