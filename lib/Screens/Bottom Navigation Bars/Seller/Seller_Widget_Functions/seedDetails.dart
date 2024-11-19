import 'package:flutter/material.dart';

class SeedCards extends StatelessWidget {
  const SeedCards({super.key});

  // Map containing details for each card
  final Map<String, String> details = const {
    "Transplanting":
        "Transplanting refers to the process of moving a plant from one location to another. In agriculture, it typically involves moving seedlings from a nursery bed to the main field.\n\nKey Steps:\n Select healthy seedlings, prepare the soil, water the seedlings before moving, transplant in the cooler part of the day to avoid stress on plants.",
    "Seed selection":
        "Seed selection is the process of choosing seeds that are genetically superior and free from diseases to ensure high crop yields.\n\nKey Criteria:\n Seed purity, uniformity, viability (ability to germinate), and resistance to pests and diseases.",
    "Nursery Check":
        "A nursery check involves inspecting nursery beds to ensure seedlings are healthy and growing properly before being transplanted.\n\nKey Checks:\n Check for diseases, adequate spacing between plants, proper moisture levels, and pest infestations.",
    "Fertilizers":
        "Fertilizers are substances added to soil to provide nutrients necessary for plant growth, such as nitrogen (N), phosphorus (P), and potassium (K).\n\nTypes:\n Organic (compost, manure) and inorganic (chemical fertilizers like urea, ammonium nitrate).",
    "Irrigation":
        "Irrigation is the artificial application of water to soil to assist in growing crops when natural rainfall is insufficient.\n\nMethods:\n Drip irrigation, sprinkler irrigation, surface irrigation (furrow, basin).",
    "Sowing":
        "Definition: Sowing is the process of planting seeds in the soil, either directly in the field or in nursery beds.\n\nMethods:\n Broadcasting, drilling, dibbling, and transplanting.",
    "Seed disease":
        "Seed diseases are caused by pathogens like fungi, bacteria, and viruses that affect seeds before or after germination.\n\nCommon Diseases:\n Seed rot, damping-off, smut, and downy mildew. Seed treatment and using resistant varieties are common prevention methods."
  };

  // Function to show the bottom sheet
  void _showBottomSheet(BuildContext context, String title) {
    // Get the screen height dynamically
    final screenHeight = MediaQuery.of(context).size.height;

    showModalBottomSheet(
      backgroundColor: const Color(0XFFFFFFFF),
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Container(
          // Set the height to 52% of the screen height
          height: screenHeight * 0.52,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  details[title] ?? "No details available for this item.",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildSeedCard(context, "Transplanting",
              'assets/images/Research/Seed/Transplanting.jpg'),
          const SizedBox(width: 10),
          _buildSeedCard(context, "Seed selection",
              'assets/images/Research/Seed/Seed_Selection.jpg'),
          const SizedBox(width: 10),
          _buildSeedCard(context, "Nursery Check",
              'assets/images/Research/Seed/Nursery_Bed.jpg'),
          const SizedBox(width: 10),
          _buildSeedCard(context, "Fertilizers",
              'assets/images/Research/Seed/Fertilizers.jpg'),
          const SizedBox(width: 10),
          _buildSeedCard(context, "Irrigation",
              'assets/images/Research/Seed/Irrigation.jpg'),
          const SizedBox(width: 10),
          _buildSeedCard(
              context, "Sowing", 'assets/images/Research/Seed/Sowing.jpg'),
          const SizedBox(width: 10),
          _buildSeedCard(
              context, "Seed disease", 'assets/images/Research/Seed/Pest.jpg'),
        ],
      ),
    );
  }

  // Helper function to build each seed card with an onTap event
  Widget _buildSeedCard(BuildContext context, String title, String imagePath) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context, title),
      child: Container(
        width: 200,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(21.0),
              child: Image.asset(
                imagePath,
                width: 200,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            // Adding a semi-transparent black overlay for better readability
            ClipRRect(
              borderRadius: BorderRadius.circular(21.0),
              child: Container(
                width: 200,
                height: 300,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(22.0),
                    bottomRight: Radius.circular(22.0),
                  ),
                ),
                width: double.infinity,
                padding: const EdgeInsets.all(13.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: -0.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
