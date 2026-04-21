import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart'; // New Import
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/routes/app_route_names.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/faq_type_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/manager/settings_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/manager/settings_states.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().getFaqs();
  }

  Future<void> _launchExternalApp(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalNonBrowserApplication);
    } else {
      String webUrl = urlString.replaceAll(
        'whatsapp://send?phone=',
        'https://wa.me/',
      );
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: _buildAppBar(),
      body: BlocBuilder<SettingsCubit, SettingsStates>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SectionHeader(title: 'Contact Support'),
              const SizedBox(height: 12),
              _buildSupportCards(),
              const SizedBox(height: 24),
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildFaqContent(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFaqContent(SettingsStates state) {
    // 1. Shimmer Loading State
    if (state.getFaqsRequestStatus == RequestStatus.loading) {
      return const FAQShimmerList();
    }

    // 2. Error State
    if (state.getFaqsRequestStatus == RequestStatus.error) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            state.getFaqsErrorMessage ?? "Failed to load FAQs",
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // 3. Success State
    if (state.faqs != null && state.faqs!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _groupFaqsByCategory(state.faqs!),
      );
    }

    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text("No FAQs found."),
      ),
    );
  }

  List<Widget> _groupFaqsByCategory(List<FaqEntity> faqs) {
    List<Widget> children = [];
    Map<String, List<FaqEntity>> grouped = {};
    for (var faq in faqs) {
      String category = faq.faqType.name;
      grouped.putIfAbsent(category, () => []).add(faq);
    }

    grouped.forEach((categoryName, items) {
      children.add(FAQCategory(title: categoryName));
      children.addAll(
        items.map((faq) => FAQTile(question: faq.question, answer: faq.answer)),
      );
    });

    return children;
  }

  Widget _buildSupportCards() {
    return Column(
      children: [
        SupportCard(
          title: 'WhatsApp Chat',
          subtitle: 'Available 24/7',
          icon: Icons.chat_bubble_outline,
          iconColor: Colors.green,
          onTap: () => _launchExternalApp("whatsapp://send?phone=201234567890"),
        ),
        SupportCard(
          title: 'Hotline',
          subtitle: '+20 123 456 7890',
          icon: Icons.phone_outlined,
          iconColor: Colors.blueAccent,
          onTap: () => _launchExternalApp('tel:+201234567890'),
        ),
        SupportCard(
          title: 'Submit Ticket',
          subtitle: 'Response within 24h',
          icon: Icons.email_outlined,
          iconColor: Colors.purple,
          onTap: () =>
              Navigator.of(context).pushNamed(AppRouteNames.submitTicketScreen),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: const BackButton(color: Colors.white),
      title: const Text('Help Center', style: TextStyle(color: Colors.white)),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for help...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Shimmer Loading Widgets ---

class FAQShimmerList extends StatelessWidget {
  const FAQShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Simulated Category Title
          Container(
            width: 120,
            height: 16,
            margin: const EdgeInsets.only(top: 20, bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          // List of Simulated Cards
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                height: 56,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// --- Reusable UI Widgets ---

class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}

class SupportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final void Function()? onTap;

  const SupportCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}

class FAQCategory extends StatelessWidget {
  final String title;
  const FAQCategory({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class FAQTile extends StatelessWidget {
  final String question;
  final String? answer;

  const FAQTile({super.key, required this.question, this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        shape: const Border(),
        title: Text(
          question,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        children: [
          if (answer != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer!,
                style: const TextStyle(color: Colors.black87, height: 1.5),
              ),
            ),
        ],
      ),
    );
  }
}
