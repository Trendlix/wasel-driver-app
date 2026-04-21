import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/error_retry_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/domain/entity/terms_condition_entity.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/manager/settings_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/manager/settings_states.dart';
import 'package:wasel_driver/apps/driver_app/features/settings/presentation/widgets/legel_card_shimmer_widget.dart';

class WaselLegalScreen extends StatefulWidget {
  final bool isTerms;
  const WaselLegalScreen({super.key, this.isTerms = true});

  @override
  State<WaselLegalScreen> createState() => _WaselLegalScreenState();
}

class _WaselLegalScreenState extends State<WaselLegalScreen> {
  @override
  void initState() {
    super.initState();
    // Triggering the API call on screen initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsCubit>().getTermsCondition();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.isTerms ? 0 : 1,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Legal', style: TextStyle(color: Colors.white)),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: _buildTabBar(),
          ),
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: BlocBuilder<SettingsCubit, SettingsStates>(
            builder: (context, state) {
              // 1. Loading State
              if (state.getTermsConditionRequestStatus ==
                  RequestStatus.loading) {
                return const LegalShimmerLoading();
              }

              // 2. Error State
              if (state.getTermsConditionRequestStatus == RequestStatus.error) {
                return Center(
                  child: ErrorRetryWidget(
                    message:
                        state.getTermsConditionErrorMessage ??
                        'something went wrong',
                    onRetry: () {
                      context.read<SettingsCubit>().getTermsCondition();
                    },
                  ),
                );
              }

              // 3. Success State
              if (state.getTermsConditionRequestStatus ==
                  RequestStatus.success) {
                final data = state.termsCondition?.data;
                return TabBarView(
                  children: [
                    LegalContentList(type: "Terms", section: data?.terms),
                    LegalContentList(
                      type: "Privacy",
                      section: data?.privacyPolicy,
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: const Color(0xFF0D47A1),
        unselectedLabelColor: Colors.white,
        tabs: const [
          Tab(
            child: TabItem(icon: Icons.description_outlined, label: "Terms"),
          ),
          Tab(
            child: TabItem(icon: Icons.shield_outlined, label: "Privacy"),
          ),
        ],
      ),
    );
  }
}

class TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const TabItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(label)],
    );
  }
}

class LegalContentList extends StatelessWidget {
  final String type;
  final LegalSectionEntity? section;

  const LegalContentList({super.key, required this.type, this.section});

  @override
  Widget build(BuildContext context) {
    if (section == null) {
      return const Center(child: Text("No content available"));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      children: [
        // 1. Introduction Header (from Entity)
        _buildHeaderCard(
          type,
          section!.introduction.title,
          section!.introduction.description,
        ),

        const SizedBox(height: 10),

        // 2. Dynamic List of Points (from Entity)
        ...section!.points
            .map(
              (point) => _buildSectionCard(
                point.sortOrder.toString(),
                point.title,
                point.description,
              ),
            )
            .toList(),
      ],
    );
  }

  Widget _buildHeaderCard(String type, String title, String description) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  type == "Terms"
                      ? Icons.description_outlined
                      : Icons.shield_outlined,
                  color: Colors.blue[900],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        "Last updated: December 17, 2024",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: TextStyle(color: Colors.grey[700], height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    String sectionOrderNum,
    String title,
    String content,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "$sectionOrderNum . ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF0D47A1),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(color: Colors.grey[600], height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
