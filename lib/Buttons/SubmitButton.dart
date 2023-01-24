import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {


  final VoidCallback onPress;
  final text;

  SubmitButton({required this.onPress,
    required this.text});


  @override
  _SubmitButtonState createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: ()  {
        print('Click dispatched');
        widget.onPress();
      },
      style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(38))),
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Colors.cyan,
              Colors.blue
            ],
          ),
          borderRadius:
          BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          height: 50,
          constraints: const BoxConstraints(
              minWidth: 88.0, minHeight: 46.0),
          // min sizes for Material buttons
          alignment: Alignment.center,
          child: Text(
            '${widget.text}',
            style: TextStyle(
              color: Colors.white,
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
