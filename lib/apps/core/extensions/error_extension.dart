import 'package:wasel_driver/apps/core/widgets/custom_text_button_widget.dart';
import 'package:flutter/material.dart';

extension ErrorExtension on BuildContext {
  void showError({bool canPop = false, String? error, Widget? errorWidget}) {
    showDialog(
      context: this,
      barrierDismissible: canPop,
      builder: (context) {
        return PopScope(
          canPop: canPop,
          child:
              errorWidget ??
              AlertDialog.adaptive(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 5,
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 60),
                    const SizedBox(height: 10),
                    Text(error ?? 'Please Wait...'),
                    const SizedBox(height: 10),
                    CustomTextButtomWidget(
                      onClick: () {
                        hideError(context);
                      },
                      borderRaduisSize: 10,
                      borderColor: Colors.red,
                      borderWidth: 1,
                      buttonColor: Colors.red,
                      btnTitle: 'OK',
                      btnTitleSize: 16,
                      btnTitleColor: Colors.white,
                    ),
                  ],
                ),
              ),
        );
      },
    );
  }

  void hideError(BuildContext context) {
    Navigator.pop(context);
  }
}
