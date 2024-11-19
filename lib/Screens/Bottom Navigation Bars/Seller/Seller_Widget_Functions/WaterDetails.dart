import 'package:flutter/material.dart';

class WaterCards extends StatelessWidget {
  const WaterCards({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Crop Type Card
          GestureDetector(
            onTap: () => _showInfoBottomSheet(context, "Crop Type",
                "What to Do:\n For each crop, particularly rice, you need to tailor the water schedule to the specific growth stage. During the seedling stage, apply frequent, light watering to establish the roots. As the crop progresses to the vegetative stage, ensure a consistent water supply to encourage healthy growth. At the reproductive stage (flowering), water demand is at its peak, so provide more water to avoid stress. As the crop approaches the maturation stage, reduce the water supply since the plant requires less.\n\nWhat to Avoid:\nAvoid a one-size-fits-all approach for different stages. Do not overwater during the early seedling stage as this could lead to root rot. Similarly, under-watering during the reproductive stage can drastically reduce yield."),
            child: waterCard(
                'assets/images/Research/Water/CropType.jpg', "Crop Type"),
          ),
          const SizedBox(width: 10),

          // Watering Card
          GestureDetector(
            onTap: () => _showInfoBottomSheet(context, "Watering Frequency",
                "What to Do:\nSet a watering schedule based on the crop's growth stage and current climate conditions. For example, water rice daily or every other day during the vegetative and reproductive stages. Adjust watering schedules based on the weather, increasing the frequency during dry spells and reducing it during wet periods.\n\nWhat to Avoid:\nAvoid inflexible schedules that don't consider environmental factors. Overwatering in cool, wet climates can lead to fungal diseases, while under-watering in hot conditions can cause the crop to wilt and stunt its growth."),
            child: waterCard(
                'assets/images/Research/Water/Watering.jpg', "Watering"),
          ),
          const SizedBox(width: 10),

          // Water Volume Card
          GestureDetector(
            onTap: () => _showInfoBottomSheet(context, "Water Volume",
                "What to Do:\nFor crops like rice, fields often need to be flooded, particularly during the reproductive stage, with around 3-5 cm of standing water. For other stages, such as seedling growth, shallow flooding is sufficient. Ensure that water penetrates deeply enough to reach the root zone but not too much that it leads to waterlogging.\n\nWhat to Avoid:\nDon’t flood fields excessively during non-critical stages. Overflooding can deplete oxygen in the soil, harming the roots. Similarly, don't allow water to dry out too much, as dry periods can cause stress, especially in sensitive growth stages."),
            child: waterCard(
                'assets/images/Research/Water/WaterVolume.jpg', "Water Volume"),
          ),
          const SizedBox(width: 10),

          // Soil Moisture Card
          GestureDetector(
            onTap: () => _showInfoBottomSheet(
                context,
                "Soil Moisture Monitoring",
                "Soil Moisture: How to monitor and maintain proper soil moisture using manual checks or moisture meters. Manage moisture based on soil type and crop stage."),
            child: waterCard('assets/images/Research/Water/SoilMoisture.jpg',
                "Soil Moisture"),
          ),
          const SizedBox(width: 10),

          // Climate Card
          GestureDetector(
            onTap: () => _showInfoBottomSheet(
                context,
                "Climate and Seasonal Factors",
                "Climate: Adjust the watering schedule based on seasonal weather patterns. For example, reduce irrigation during monsoon or increase it during dry spells."),
            child: waterCard('assets/images/Research/Water/C1.jpg', "Climate"),
          ),
          const SizedBox(width: 10),

          // Impacts Card
          GestureDetector(
            onTap: () => _showInfoBottomSheet(context, "Impact of Watering",
                "Impacts: How watering impacts crop yield and quality. Proper watering leads to better yields, whereas improper watering (over or under-watering) can cause losses."),
            child:
                waterCard('assets/images/Research/Water/Impact.png', "Impacts"),
          ),
          const SizedBox(width: 10),

          // Irrigation Card
          GestureDetector(
            onTap: () => _showInfoBottomSheet(context, "Irrigation Techniques",
                "What to Do:\nUse tools like calendars, mobile apps, or weather-based irrigation systems to help farmers manage their watering schedules. These tools can remind users when to water their crops and can adjust irrigation based on upcoming weather conditions. Introduce tools like soil moisture sensors for more precise irrigation management.\n\nWhat to Avoid:\nAvoid manual or inconsistent scheduling, especially for large fields where human error can lead to missed watering cycles. Don’t rely solely on memory or random schedules for irrigation as this can lead to inconsistent results."),
            child: waterCard(
                'assets/images/Research/Water/Water.jpg', "Irrigation"),
          ),
          const SizedBox(width: 10),

          // Government Guidelines Card
          GestureDetector(
            onTap: () => _showInfoBottomSheet(context, "Government Guidelines",
                "What to Do:\nFollow local agricultural guidelines provided by government departments. This can include best practices for water management and updates on crop-specific irrigation techniques. Check for government programs offering support or subsidies for improved irrigation technologies, and provide contact information or links to farmers.\n\nWhat to Avoid:\nAvoid ignoring these official recommendations. Government guidelines are often tailored to local conditions and can help avoid common irrigation mistakes. Also, don’t miss out on government support programs that could provide cost-effective solutions for water management."),
            child: waterCard(
                'assets/images/Research/Water/Government.jpg', "Government"),
          ),
          const SizedBox(width: 10),

          // Management Card
          GestureDetector(
            onTap: () => _showInfoBottomSheet(context, "Water Management",
                "What to Do:\nManage your water resources based on availability in the region. If you are near a canal irrigation system, utilize it efficiently. In regions that rely on tube wells, consider groundwater conservation techniques. Water-scarce areas may benefit from practices like rainwater harvesting.\n\nWhat to Avoid:\nDon’t use water inefficiently, especially in areas with limited resources. Avoid over-relying on tube wells without proper groundwater management. Excessive use of groundwater can lead to long-term depletion of this resource."),
            child:
                waterCard('assets/images/Research/Water/C1.jpg', "Management"),
          ),
        ],
      ),
    );
  }

  // Function to create a reusable water card
  Widget waterCard(String imagePath, String title) {
    return Container(
      width: 220,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                letterSpacing: -0.1,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to show the bottom sheet with detailed information
  void _showInfoBottomSheet(
      BuildContext context, String title, String content) {
    showModalBottomSheet(
      backgroundColor: const Color(0XFFFFFFFF),
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height *
              0.6, // 50% of the screen height
          padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    content,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
