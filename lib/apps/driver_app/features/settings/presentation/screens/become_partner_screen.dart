import 'package:flutter/material.dart';
import 'package:wasel_driver/apps/core/services/store_redirect_service.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_images.dart';

class BecomePartnerScreen extends StatelessWidget {
  const BecomePartnerScreen({super.key});

  final Color primaryBlue = AppColors.primary;
  final Color accentYellow = AppColors.secondary;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Become a Partner",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. Header Card (Blue)
            _buildHeaderCard(),
            const SizedBox(height: 20),

            // 2. Have a Truck Section (Yellow)
            _buildPartnerSection(
              headerColor: accentYellow,
              icon: Icons.local_shipping_outlined,
              title: "Have a Truck?",
              subtitle: "Start earning today",
              features: [
                "Flexible working hours",
                "Competitive earnings",
                "Weekly payouts",
              ],
            ),
            const SizedBox(height: 20),

            // 3. Have Storage Section (Blue Accent)
            _buildPartnerSection(
              headerColor: const Color(0xFF3269D1),
              icon: Icons.store_outlined,
              title: "Have Storage?",
              subtitle: "List your facility",
              features: [
                "Maximize occupancy",
                "Digital contracts",
                "Secure payments",
              ],
              isDarkIcon: false,
            ),
            const SizedBox(height: 20),

            // 4. Questions Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Join Wasel Today",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "Partner with Wasel and grow your business. Connect with thousands of customers looking for transportation and storage services.",
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ويدجت الأقسام (Truck & Storage)
  Widget _buildPartnerSection({
    required Color headerColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<String> features,
    bool isDarkIcon = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          // Header of Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                  child: Icon(icon, color: headerColor, size: 28),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDarkIcon ? Colors.black87 : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isDarkIcon ? Colors.black54 : Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Features List
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ...features
                    .map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: primaryBlue,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              f,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                const SizedBox(height: 10),
                // Buttons
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.open_in_new,
                      size: 18,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Login to Web Portal",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (StoreRedirectService.isAndroid()) {
                            StoreRedirectService.redirectToStore();
                          }
                        },
                        child: Image.asset(AppImages.googleBadge, height: 45),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (StoreRedirectService.isIOS()) {
                            StoreRedirectService.redirectToStore();
                          }
                        },
                        child: Image.asset(AppImages.iosBadge, height: 45),
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
  }

  // ويدجت التذييل (Footer)
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Questions?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            "Our partnership team is here to help. Contact us for more information about becoming a Wasel partner.",
            style: TextStyle(color: Colors.black, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.email_outlined, color: primaryBlue),
            label: Text(
              "partners@wasel.com",
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
