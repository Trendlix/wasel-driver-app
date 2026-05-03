import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter/services.dart';

class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({super.key});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _pulse = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _PulsingIcon(pulse: _pulse),
              const SizedBox(height: 36),
              _buildBadge(),
              const SizedBox(height: 20),
              const Text(
                "You're offline",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1B2E),
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Check your Wi-Fi or mobile data\nand try again.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF8B8FA8),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              _buildPrimaryButton(),
              const SizedBox(height: 12),
              //  _buildSecondaryButton(),
              const SizedBox(height: 24),
              _buildFooterHint(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD4D5F5)),
      ),
      child: const Text(
        'CONNECTION LOST',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6366F1),
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () =>
            AppSettings.openAppSettings(type: AppSettingsType.wifi),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6366F1),
          foregroundColor: Colors.white,
          shadowColor: const Color(0xFF6366F1).withOpacity(0.25),
          elevation: 8,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Open Settings',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // Widget _buildSecondaryButton() {
  //   return SizedBox(
  //     width: double.infinity,
  //     child: OutlinedButton(
  //       onPressed: () {
  //         // trigger your connectivity re-check here
  //       },
  //       style: OutlinedButton.styleFrom(
  //         backgroundColor: Colors.white,
  //         foregroundColor: const Color(0xFF6B6E85),
  //         padding: const EdgeInsets.symmetric(vertical: 15),
  //         side: const BorderSide(color: Color(0xFFE2E4F0)),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //       ),
  //       child: const Text('Try Again', style: TextStyle(fontSize: 14)),
  //     ),
  //   );
  // }

  Widget _buildFooterHint() {
    return const Text(
      'Your data is safe and will sync once you\'re back online.',
      style: TextStyle(fontSize: 12, color: Colors.black),
      textAlign: TextAlign.center,
    );
  }
}

class _PulsingIcon extends StatelessWidget {
  final Animation<double> pulse;

  const _PulsingIcon({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (_, __) {
        return SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _Ring(
                size: 120,
                opacity: 0.14 + (pulse.value * 0.08),
                color: const Color(0xFF6366F1),
              ),
              _Ring(
                size: 88,
                opacity: 0.22 + (pulse.value * 0.1),
                color: const Color(0xFF6366F1),
              ),
              _Ring(
                size: 58,
                opacity: 0.32 + (pulse.value * 0.12),
                color: const Color(0xFF6366F1),
              ),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E4F0)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.10),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.wifi_rounded,
                      color: Color(0xFFC5C7E0),
                      size: 26,
                    ),
                    Transform.rotate(
                      angle: math.pi / 4,
                      child: Container(
                        width: 2,
                        height: 34,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color(0xFFEF4444),
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Ring extends StatelessWidget {
  final double size;
  final double opacity;
  final Color color;

  const _Ring({required this.size, required this.opacity, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(opacity), width: 1),
      ),
    );
  }
}
