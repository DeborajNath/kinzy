import 'package:authentication_firebase/constants/index.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool enabled;

  const GradientButton({
    super.key,
    required this.onTap,
    required this.text,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: enabled ? primaryColor : grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: cardBackgrround,
            ),
          ),
        ),
      ),
    );
  }
}
