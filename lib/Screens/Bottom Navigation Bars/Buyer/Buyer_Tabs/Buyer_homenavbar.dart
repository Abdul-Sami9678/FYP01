import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Widgets_Functions/Fetch_posts.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Widgets_Functions/Greeting_Widget.dart';
import 'package:rice_application/Screens/Bottom%20Navigation%20Bars/Buyer/Buyer_Widgets_Functions/Search_Widget_Buyer.dart';

class BuyerHomenavbar extends StatefulWidget {
  const BuyerHomenavbar({super.key});

  @override
  State<BuyerHomenavbar> createState() => _BuyerHomenavbarState();
}

class _BuyerHomenavbarState extends State<BuyerHomenavbar> {
  // Realtime database reference for fetching posts
  final dbRef = FirebaseDatabase.instance.ref().child('Posts');
  final TextEditingController _searchController =
      TextEditingController(); // Searchbar Controller......
  String search = "";

  // Example list of random names
  final List<String> names = [
    'Basmati Rice',
    'Super Kernel',
    'Sella Rice',
    'Brown Rice',
    'Black Rice',
    'Long Grain',
    'IRRI-9',
    'IRRI-6',
    'PK-386',
    'D-98',
  ];

  // Corresponding descriptions for each name
  final List<String> descriptions = [
    "Basmati rice is a long-grain rice known for its fragrant aroma and delicate flavor. It's primarily grown in India and Pakistan and is often used in South Asian and Middle Eastern cuisines. Basmati grains remain separate and fluffy when cooked, making them ideal for pilafs, biryanis, and other rice dishes. The grains are slender, with a slightly nutty taste, and they elongate significantly during cooking. Basmati rice is prized for its light, airy texture and is often considered one of the finest rice varieties globally.",
    "Super Kernel is a premium quality rice variant, known for its exceptional taste and aroma. It is often used in gourmet dishes, where the quality of the rice is paramount. The grains are long, slender, and non-sticky, making them ideal for pilafs and biryanis. Super Kernel rice is highly sought after for its superior cooking properties. It is often considered one of the finest rice varieties in South Asia.",
    "Sella Rice is a type of parboiled rice that undergoes a unique processing method to retain more nutrients. The parboiling process makes the grains firm, less sticky, and richer in vitamins and minerals compared to regular white rice. Sella Rice is golden in color before cooking, but it turns white when cooked. It is highly valued in South Asian and Middle Eastern cuisines for its nutritional benefits and robust texture. This rice variety is perfect for dishes that require the grains to remain separate and fluffy.",
    "Brown Rice is a whole grain rice that retains the bran and germ, making it a nutritious option rich in fiber, vitamins, and minerals. The grains are slightly chewy with a nutty flavor, offering a more substantial and hearty texture compared to white rice. Brown Rice is often chosen for health-conscious diets due to its higher fiber content, which aids in digestion and helps maintain stable blood sugar levels. It takes longer to cook than white rice but is considered a healthier alternative. Brown Rice is versatile and can be used in a variety of dishes, from salads to stir-fries.",
    "Black Rice is a rare and ancient variety known for its deep black or purple color, which is due to its high anthocyanin content, a powerful antioxidant. Also called forbidden rice; it was once reserved for royalty in ancient China due to its health benefits and scarcity. When cooked, Black Rice turns a deep purple color and has a slightly sweet, nutty flavor with a chewy texture. It is rich in fiber, vitamins, and minerals, making it a nutritious choice. Black Rice is often used in desserts, salads, and as a striking visual element in gourmet dishes.",
    "Long Grain Rice is a popular rice variety characterized by its slender, elongated grains that remain separate and fluffy when cooked. It has a mild flavor, making it a versatile ingredient in various dishes, from pilafs to stir-fries. Long Grain Rice is less sticky compared to other rice types, making it ideal for dishes where distinct grains are desired. It is a staple in many households due to its adaptability to different cooking methods. This rice is commonly used in global cuisines, particularly in American, South Asian, and Middle Eastern cooking.",
    "IRRI-9 is a long-grain rice variety commonly grown in Pakistan, known for its slender grains and aromatic flavor. It is a versatile rice type, often used in everyday meals as well as special occasions. The grains of IRRI-9 rice cook to a soft and fluffy texture, making it ideal for a variety of dishes, including pilafs and steamed rice. It is highly valued in local and international markets for its quality and affordability. IRRI-9 rice is popular for its balance of taste, texture, and cost-effectiveness.",
    "IRRI-6 is a rice variety known for its short and thick grains, which make it ideal for a wide range of rice dishes. It is one of the most widely cultivated rice types in Pakistan due to its high yield and adaptability to different growing conditions. The grains of IRRI-6 are less sticky, making it suitable for dishes where a firmer texture is preferred. It is commonly used in everyday meals, especially in traditional South Asian cuisine. IRRI-6 rice is appreciated for its consistency in quality and affordability.",
    "PK-386 is a fine-quality long grain rice, prized for its delicate fragrance and flavor. The grains are long and slender, making it an excellent choice for dishes that require a light, fluffy texture. PK-386 is highly sought after in both local and international markets due to its premium quality. It is often used in gourmet recipes, where the aromatic and flavorful nature of the rice enhances the dish. PK-386 is considered a top-tier variety in the global rice market, particularly in South Asia.",
    "D-98 is a popular rice variety in Pakistan known for its distinctive taste and texture. It is a long-grain rice that cooks to a soft and fluffy consistency, making it ideal for traditional rice dishes like biryanis and pilafs. D-98 is favored for its consistent quality and reliable cooking properties, making it a staple in many households. The variety is known for its affordability and wide availability in local markets. D-98 rice is appreciated for its balance of taste, texture, and versatility in various culinary applications.",
  ];

  // Corresponding nutrients for each name
  final List<String> nutrients = [
    'Carbohydrates, Protein, Fiber',
    'Carbohydrates, Protein, Iron',
    'Carbohydrates, Protein, Magnesium',
    'Carbohydrates, Protein, Fiber, Manganese',
    'Carbohydrates, Protein, Antioxidants',
    'Carbohydrates, Protein, Fiber',
    'Carbohydrates, Protein, Fiber',
    'Carbohydrates, Protein, Fiber',
    'Carbohydrates, Protein, Fiber',
    'Carbohydrates, Protein, Fiber',
  ];

  // Corresponding vitamins for each name
  final List<String> vitamins = [
    'Vitamin B1, Vitamin B3, Vitamin B6',
    'Vitamin B1, Vitamin B3, Vitamin B6',
    'Vitamin B1, Vitamin B3, Vitamin B6',
    'Vitamin B1, Vitamin B3, Vitamin B6',
    'Vitamin B1, Vitamin B3, Vitamin E',
    'Vitamin B1, Vitamin B3, Vitamin B6',
    'Vitamin B1, Vitamin B3, Vitamin B6',
    'Vitamin B1, Vitamin B3, Vitamin B6',
    'Vitamin B1, Vitamin B3, Vitamin B6',
    'Vitamin B1, Vitamin B3, Vitamin B6',
  ];

  // Corresponding dishes for each name
  final List<String> dishes = [
    'Biryani, Pulao, Fried Rice',
    'Pulao, Biryani, Plain Rice',
    'Biryani, Pulao, Kheer',
    'Salads, Rice Bowls, Stir Fry',
    'Sushi, Rice Pudding, Salads',
    'Biryani, Pulao, Fried Rice',
    'Biryani, Pulao, Fried Rice',
    'Biryani, Pulao, Fried Rice',
    'Biryani, Pulao, Fried Rice',
    'Biryani, Pulao, Fried Rice',
  ];

  // Corresponding locations for each name
  final List<String> locations = [
    'Punjab, Pakistan',
    'Punjab, Pakistan',
    'Sindh, Pakistan',
    'Sindh, Pakistan',
    'KPK, Pakistan',
    'Punjab, Pakistan',
    'Punjab, Pakistan',
    'Punjab, Pakistan',
    'Sindh, Pakistan',
    'Sindh, Pakistan',
  ];

  // Corresponding image paths for each name
  final List<String> imagePaths = [
    'assets/images/Rice/basmati1.jpg',
    'assets/images/Rice/sk.jpg',
    'assets/images/Rice/Sella-Rice.jpg',
    'assets/images/Rice/Brown-Rice.jpg',
    'assets/images/Rice/Black-Rice.jpg',
    'assets/images/Rice/Long-Grain.jpg',
    'assets/images/Rice/IRRI-9.jpg',
    'assets/images/Rice/IRRI-6.jpg',
    'assets/images/Rice/pk.jpg',
    'assets/images/Rice/d98.jpg',
  ];

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  // Handle search query changes here
  void _onSearchChanged(String value) {
    setState(() {
      search = value;
    });
  }

//Browse Categories information...........
  void _showBottomSheet(
    String name,
    String description,
    String nutrients,
    String vitamins,
    String dishes,
    String location,
    String imagePath,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0XFFFFFFFF), // Set background color
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20), // Rounded corners for the bottom sheet
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                      20), // Rounded corners for the image
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 180,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Nutrients:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  nutrients,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Vitamins:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vitamins,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Dishes:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dishes,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Location:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

//Moved to Posts Info..............
  void _navigateToDetailsScreen(
    String name,
    String price,
    String description,
    String imagePath,
    String sid,
    String pid,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailsScreen(
          name: name,
          price: price,
          description: description,
          imagePath: imagePath,
          sellerUid: sid,
          postId: pid,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFFFFFFF),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: Colors.black,
        backgroundColor: const Color(0XFFFFFFFF),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15),
                  const GreetingWidget(),
                  const SizedBox(height: 22),
                  //Search Bar Logic.......
                  SearchBarBuyer(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                  ),
                  const Text(
                    "Browse Categories",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Sans',
                      letterSpacing: -0.2,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 29, 28, 28),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 75,
                    child: ListView.builder(
                      // To show posts...........
                      scrollDirection: Axis.horizontal,
                      itemCount: names.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextButton(
                            onPressed: () {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _showBottomSheet(
                                  names[index],
                                  descriptions[index],
                                  nutrients[index],
                                  vitamins[index],
                                  dishes[index],
                                  locations[index],
                                  imagePaths[index],
                                );
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    imagePaths[index],
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 80,
                                  ),
                                ),
                                Container(
                                  width: 150,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.black.withOpacity(0.32),
                                  ),
                                  child: Center(
                                    child: Text(
                                      names[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    "Recent Posts",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Sans',
                      letterSpacing: -0.2,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 29, 28, 28),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 350,
                    child: FirebaseAnimatedList(
                      query: dbRef
                          .child('Post List'), // Database refernce...........
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        if (snapshot.value is Map) {
                          final post = snapshot.value as Map;

                          // Filter by search query
                          String postTitle = post['pTitle'] ?? 'No Title';
                          if (search.isNotEmpty &&
                              !postTitle
                                  .toLowerCase()
                                  .contains(search.toLowerCase())) {
                            return const SizedBox(); // Don't show posts that don't match the search query
                          }

                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom:
                                    24.0), // Increased padding for more space between posts
                            child: GestureDetector(
                              onTap: () {
                                _navigateToDetailsScreen(
                                  post['pTitle'] ?? 'No Title',
                                  post['pDescription'] ?? 'No Description',
                                  post['pPrice'] ?? 'No Price',
                                  post['pImage'] ?? 'assets/images/default.jpg',
                                  post['postId'] ?? 'No Postid',
                                  post['sellerUid'] ?? 'Sellerid',
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          12), // Ensures image corners are rounded
                                      child: FadeInImage.assetNetwork(
                                        placeholder: 'assets/images/Post2.jpg',
                                        image: post['pImage'] ?? '',
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/error_image.png',
                                            width: double.infinity,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              post['pTitle'] ?? 'No Title',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                letterSpacing: -0.1,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow
                                                  .ellipsis, // Truncate if too long
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            post['pLocation'] ?? 'No Location',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              letterSpacing: -0.2,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Sans',
                                              color: Color.fromARGB(
                                                  136, 51, 50, 50),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const ListTile(
                            title: Text('Invalid Data'),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
