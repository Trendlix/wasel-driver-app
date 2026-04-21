import 'package:flutter/material.dart';

extension LoadingExtension on BuildContext {
  static bool _isLoadingVisible = false;

  void showLoading({
    bool canPop = false,
    String? message,
    Widget? loadingWidget,
  }) {
    if (!_isLoadingVisible) {
      _isLoadingVisible = true;
      showDialog(
        context: this,
        barrierDismissible: canPop,
        useRootNavigator: true,
        builder: (context) {
          return PopScope(
            canPop: canPop,
            child:
                loadingWidget ??
                AlertDialog.adaptive(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(message ?? 'Please Wait...'),
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(),
                    ],
                  ),
                ),
          );
        },
      );
    }
  }

  void hideLoading() {
    if (_isLoadingVisible && Navigator.canPop(this)) {
      _isLoadingVisible = false;
      Navigator.of(this, rootNavigator: true).pop();
    }
  }
}
