import 'package:flutter/material.dart';

class CustomTextButtomWidget extends StatelessWidget {
  final void Function()? onClick;
  final double borderRaduisSize, borderWidth, btnTitleSize;
  final Color borderColor, buttonColor, btnTitleColor;
  final String btnTitle;
  final bool isLoading;
  const CustomTextButtomWidget({
    required this.onClick,
    required this.borderRaduisSize,
    required this.borderColor,
    required this.borderWidth,
    required this.buttonColor,
    required this.btnTitle,
    required this.btnTitleSize,
    required this.btnTitleColor,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // or button color
      child: InkWell(
        onTap: onClick,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRaduisSize),
            border: Border.all(color: borderColor, width: borderWidth),
            color: buttonColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: isLoading
              ? LoadingBtnWidget()
              : Text(
                  btnTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: btnTitleSize,
                    color: btnTitleColor,
                  ),
                ),
        ),
      ),
    );
  }
}

class LoadingBtnWidget extends StatelessWidget {
  const LoadingBtnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: 25,
      child: const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    );
  }
}
