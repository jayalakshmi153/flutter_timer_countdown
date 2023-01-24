import 'package:flutter/material.dart';


class NegativeOutlineButton extends StatelessWidget {
  final VoidCallback onPress;
  final text;

  const NegativeOutlineButton(
      {Key? key, required this.text, required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(

      onPressed: () {
        onPress();
      },
      style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          side: BorderSide(
            width: 1.0,
            color: Colors.blue,
            style: BorderStyle.solid,
          ),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(38))),
      child: Ink(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          height: 50,
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 46.0),
          // min sizes for Material buttons
          alignment: Alignment.center,
          child:  Text(
            '$text',
            style: TextStyle(
              color: Colors.blue,
              fontFamily: 'RedHatDisplay',
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 0.4,
              height: 0.9,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
