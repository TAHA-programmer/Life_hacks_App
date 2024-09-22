import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LifeHacks extends StatefulWidget {
  const LifeHacks({super.key});

  @override
  State<LifeHacks> createState() => _LifeHacksState();
}

class _LifeHacksState extends State<LifeHacks> {
  List items = [];
  Map<String, List> categorizedItems = {};

  @override
  void initState() {
    super.initState();
    readJson();
  }

  Future<void> readJson() async {
    final String response = await rootBundle.loadString("assets/json/alltrics.json");
    final data = json.decode(response);

    setState(() {
      items = data;
      categorizedItems = {};
      for (var item in items) {
        String category = item['category'] ?? 'Uncategorized';
        if (!categorizedItems.containsKey(category)) {
          categorizedItems[category] = [];
        }
        categorizedItems[category]!.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> categoryNames = {
      '100': 'Life Hacks',
      '200': 'Health Hacks',
      '300': 'Technology Hacks',
      '400': 'Money-Saving Hacks',
      '500': 'Home Hacks',
      '600': 'Food Hacks',
      '700': 'Productivity Hacks',
      '800': 'Travel Hacks',
      '900': 'Emergency Hacks',
      '1000': 'Miscellaneous',
    };

    Map<String, String> categoryImages = {
      '100': 'assets/images/life_tips.png',
      '200': 'assets/images/health_tips.jpg',
      '300': 'assets/images/tech_tips.jpg',
      '400': 'assets/images/money-saving.webp',
      '500': 'assets/images/home_hacks.jpg',
      '600': 'assets/images/food_hacks.jpg',
      '700': 'assets/images/productivity_hacks.png',
      '800': 'assets/images/travel_hacks.jpg',
      '900': 'assets/images/emergency_hacks.jpg',
      '1000': 'assets/images/miscellaneous_hacks.webp',
    };

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Center(
            child:  Text(
              'Life Hacks',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: categorizedItems.keys.map((category) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryDetailPage(
                        categoryName: categoryNames[category] ?? category,
                        items: categorizedItems[category]!,
                        backgroundImage: categoryImages[category] ?? 'assets/images/default.jpg',
                      ),
                    ),
                  );
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                        categoryImages[category] ?? 'assets/images/default.jpg',
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.5),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        color: Colors.black54,
                        padding:const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            categoryNames[category] ?? 'Unknown Category',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CategoryDetailPage extends StatefulWidget {
  final String categoryName;
  final List items;
  final String backgroundImage;

  const CategoryDetailPage({
    super.key,
    required this.categoryName,
    required this.items,
    required this.backgroundImage,
  });

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
 PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.categoryName),
      ),
      backgroundColor: Colors.black26,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.jpg",
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: SizedBox(
                              width: 300,
                              height: 350,
                              child: Card(
                                color: Colors.white,
                                child: Center(
                                  child: ListTile(
                                    title: Text(
                                      item['tricks'] ?? 'No Trick',
                                      style:const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      'Hack Number: ${item['id']}',
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Logo with rounded borders positioned
                        Positioned(
                          top: 80, // Adjust as needed to position the logo
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0), // Rounded borders
                            child: SizedBox(
                              width: 100, // Reduced width
                              height: 100, // Reduced height
                              child: Image.asset(
                                'assets/images/logo.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                color: Colors.black.withOpacity(0.7),
                padding:const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon:const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        if (_pageController.page != 0) {
                          _pageController.previousPage(
                            duration:const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon:const Icon(Icons.arrow_forward, color: Colors.white),
                      onPressed: () {
                        if (_pageController.page != widget.items.length - 1) {
                          _pageController.nextPage(
                            duration:const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LifeHacks(),
  ));
}
