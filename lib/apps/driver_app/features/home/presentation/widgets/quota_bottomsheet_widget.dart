import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_driver/apps/core/di/app_service_locator.dart';
import 'package:wasel_driver/apps/core/enums/request_status.dart';
import 'package:wasel_driver/apps/core/utils/constants/app_colors.dart';
import 'package:wasel_driver/apps/core/widgets/custom_dialog_widget.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/cubit/home_states.dart';
import 'package:wasel_driver/apps/driver_app/features/home/presentation/widgets/quoto_sent_bottomsheet_widget.dart';

enum _PriceOption { user, recommended, custom }

class SendQuoteBottomSheet extends StatefulWidget {
  final double? price, suggestedPrice;
  final int requestId;
  final double locationLat, locationLong;
  const SendQuoteBottomSheet({
    super.key,
    required this.price,
    required this.suggestedPrice,
    required this.requestId,
    required this.locationLat,
    required this.locationLong,
  });

  static void show(
    BuildContext context,
    double price,
    double suggestedPrice,
    int requestId,
    double locationLat,
    double locationLong,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SendQuoteBottomSheet(
        price: price,
        suggestedPrice: suggestedPrice,
        requestId: requestId,
        locationLat: locationLat,
        locationLong: locationLong,
      ),
    );
  }

  @override
  State<SendQuoteBottomSheet> createState() => _SendQuoteBottomSheetState();
}

class _SendQuoteBottomSheetState extends State<SendQuoteBottomSheet> {
  _PriceOption _selected = _PriceOption.recommended;
  final TextEditingController _customPriceController = TextEditingController();
  int _selectedChipIndex = 1; // 0 = below, 1 = wasel price, 2 = above

  @override
  void dispose() {
    _customPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<HomeCubit>(),
      child: BlocListener<HomeCubit, HomeStates>(
        listener: (context, state) {
          if (state.sendDriverOfferStatus == RequestStatus.error) {
            showError(
              context,
              state.sendDriverOfferErrorMessage ?? 'something went wrong',
            );
          }
          if (state.sendDriverOfferStatus == RequestStatus.success) {
            showSuccess(context, 'offer sent successfully');
            Navigator.pop(context);
            QuoteSentBottomSheet.show(context);
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Builder(
            builder: (innerContext) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Header ─────────────────────────────────────────────
                    _buildHeader(),
                    const SizedBox(height: 20),

                    const Text(
                      'Select Your Price Option',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── User Price ─────────────────────────────────────────
                    _buildOptionCard(
                      option: _PriceOption.user,
                      icon: Icons.attach_money_rounded,
                      iconColor: const Color(0xFF6B7280),
                      title: 'User Price',
                      subtitle: 'The lowest acceptable price for this trip',
                      price: '${widget.price} EGP',
                      priceColor: const Color(0xFF1A1A2E),
                      badge: null,
                      extraLabel: null,
                    ),
                    const SizedBox(height: 10),

                    // ── Recommended Price ──────────────────────────────────
                    _buildOptionCard(
                      option: _PriceOption.recommended,
                      icon: Icons.trending_up_rounded,
                      iconColor: const Color(0xFFE8A020),
                      title: 'Recommended Price',
                      subtitle: 'Balanced price with higher win rate',
                      price: '${widget.suggestedPrice} EGP',
                      priceColor: const Color(0xFFE8A020),
                      badge: 'BEST VALUE',
                      extraLabel: '+5% above minimum',
                    ),
                    const SizedBox(height: 10),

                    // ── Custom Price ───────────────────────────────────────
                    _buildCustomOption(),

                    const SizedBox(height: 24),

                    // ── Buttons ────────────────────────────────────────────
                    _buildButtons(innerContext),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send Your Quote',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1A1A2E),
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Request #TRK-1785075574712',
              style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Icon(
              Icons.close_rounded,
              size: 16,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
      ],
    );
  }

  // ── Price Option Card ────────────────────────────────────────────────────────

  Widget _buildOptionCard({
    required _PriceOption option,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String price,
    required Color priceColor,
    required String? badge,
    required String? extraLabel,
  }) {
    final isSelected = _selected == option;

    return GestureDetector(
      onTap: () => setState(() {
        _selected = option;
        _customPriceController.clear();
        _customPriceController.text = price;
        print("the price is $price");
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8A020),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: priceColor,
                    ),
                  ),
                  if (extraLabel != null)
                    Text(
                      extraLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                ],
              ),
            ),

            // Radio
            _buildRadio(isSelected),
          ],
        ),
      ),
    );
  }

  // ── Custom Price Option ──────────────────────────────────────────────────────

  Widget _buildCustomOption() {
    final isSelected = _selected == _PriceOption.custom;
    final priceBefore = (widget.price ?? 0) - 500;
    final priceAfter = (widget.price ?? 0) + 500;

    return GestureDetector(
      onTap: () => setState(() => _selected = _PriceOption.custom),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 20,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Custom Price',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      Text(
                        'Set your own competitive price',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildRadio(isSelected),
              ],
            ),

            // Expanded when selected
            if (isSelected) ...[
              const SizedBox(height: 14),

              // Suggested price blue box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wasel Suggested Price',
                      style: TextStyle(fontSize: 11, color: Colors.white60),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${widget.price} EGP',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Based on distance, truck type, and current demand',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white60,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Your offer price',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 8),

              // Price input field
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE8A020).withOpacity(0.4),
                  ),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Icon(
                        Icons.attach_money_rounded,
                        size: 18,
                        color: Color(0xFFE8A020),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _customPriceController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                        decoration: const InputDecoration(
                          hintText: '0',
                          hintStyle: TextStyle(color: Color(0xFFD1D5DB)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'EGP',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              const Text(
                "Drivers will see your offer and can accept or counter offer",
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 12),

              // Quick price chips
              Row(
                children: [
                  _buildPriceChip(
                    '$priceBefore EGP',
                    _selectedChipIndex == 0,
                    onTap: () => setState(() {
                      _selectedChipIndex = 0;
                      _customPriceController.text = priceBefore.toStringAsFixed(
                        0,
                      );
                    }),
                  ),
                  const SizedBox(width: 5),
                  _buildPriceChip(
                    '${widget.price} EGP',
                    _selectedChipIndex == 1,
                    onTap: () => setState(() {
                      _selectedChipIndex = 1;
                      _customPriceController.text = (widget.price ?? 0)
                          .toStringAsFixed(0);
                    }),
                  ),
                  const SizedBox(width: 5),
                  _buildPriceChip(
                    '$priceAfter EGP',
                    _selectedChipIndex == 2,
                    onTap: () => setState(() {
                      _selectedChipIndex = 2;
                      _customPriceController.text = priceAfter.toStringAsFixed(
                        0,
                      );
                    }),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRadio(bool isSelected) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : const Color(0xFFD1D5DB),
          width: 2,
        ),
      ),
      child: isSelected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildPriceChip(String label, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primary : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  // ── Bottom Buttons ───────────────────────────────────────────────────────────

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () {
              final rawText = _customPriceController.text
                  .replaceAll('EGP', '') // remove currency label
                  .trim(); // remove whitespace

              final price = double.parse(
                rawText,
              ).toInt(); // handle decimals safely

              context.read<HomeCubit>().sendDriverOffer(
                widget.requestId,
                price,
                widget.locationLat,
                widget.locationLong,
              );
            },
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: BlocBuilder<HomeCubit, HomeStates>(
                builder: (context, state) {
                  if (state.sendDriverOfferStatus == RequestStatus.loading) {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                  return const Text(
                    'Send Quote',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
