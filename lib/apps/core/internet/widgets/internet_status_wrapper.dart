import 'package:wasel_driver/apps/core/internet/widgets/no_internet_widget.dart';
import 'package:flutter/material.dart';
import 'package:wasel_driver/apps/core/internet/internet_service.dart';

class InternetStatusWrapper extends StatelessWidget {
  final Widget child;

  const InternetStatusWrapper({super.key, required this.child});

  static final internetService = InternetService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: internetService.onStatusChange,
      initialData: true,
      builder: (context, snapshot) {
        final hasInternet = snapshot.data ?? true;

        return hasInternet ? child : const NoInternetScreen();
      },
    );
  }
}
