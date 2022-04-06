import 'package:flutter/material.dart';
import 'package:seeq_business/utils/constants.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {required this.onTap, this.color, this.textColor, required this.title});

  final VoidCallback onTap;
  final Color? color;
  final Color? textColor;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: color ?? kPrimaryColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: textColor ?? kWhiteColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
