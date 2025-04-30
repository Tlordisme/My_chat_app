import 'package:flutter/material.dart';

class LoginPrompt extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String title2;
  const LoginPrompt({
    super.key,
    required this.onTap,
    required this.title,
    required this.title2,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: RichText(
          text: TextSpan(
            text: title,
            style: TextStyle(color: Colors.grey),
            children: [
              TextSpan(
                text: title2,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
