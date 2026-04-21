import 'package:flutter/material.dart';

class RegistrationStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<bool> completedSteps;

  const RegistrationStepper({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.completedSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        // Even indexes = step circles, Odd indexes = connectors
        if (index.isOdd) return _buildConnector(index ~/ 2);
        final stepIndex = index ~/ 2;
        return _buildStepCircle(stepIndex);
      }),
    );
  }

  Widget _buildStepCircle(int stepIndex) {
    final isCompleted = completedSteps[stepIndex];
    final isActive = stepIndex == currentStep;

    Color bgColor;
    Widget child;

    if (isCompleted) {
      bgColor = const Color(0xFF22C55E); // green
      child = const Icon(Icons.check, color: Colors.white, size: 14);
    } else if (isActive) {
      bgColor = const Color(0xFF1A3A6B); // primary blue
      child = Text(
        '${stepIndex + 1}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      );
    } else {
      bgColor = const Color(0xFFE0E0E0); // inactive grey
      child = Text(
        '${stepIndex + 1}',
        style: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 28,
      height: 28,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _buildConnector(int stepIndex) {
    final isCompleted = completedSteps[stepIndex];

    return Expanded(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 2,
        color: isCompleted ? const Color(0xFF22C55E) : const Color(0xFFE0E0E0),
      ),
    );
  }
}
