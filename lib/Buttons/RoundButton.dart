import 'package:flutter/material.dart';
class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    required this.icon,
  }) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(blurRadius: 10, color: Colors.grey[300]!, spreadRadius: 5)],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 30,
        child: Icon(
          icon,
          size: 36,
          color: Colors.green,
        ),
      ),
    );
  }
}