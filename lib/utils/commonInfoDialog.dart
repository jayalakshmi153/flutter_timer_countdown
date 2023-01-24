import 'package:flutter/material.dart';
import '../Buttons/NegativeOutlineButton.dart';
import '../Buttons/SubmitButton.dart';

commonInfoDialog(context, title,
    {isIconEnable: false,
      dismissible: false,
      isBtnEnabled: false,
      isCancelBtnEnabled :false,
      String positiveBtnText: "Ok",
      negativeBtnText: "Cancel",
      positiveBtnOnClick,
      negativeBtnOnClick,
      cancelBtnOnClick :Function}) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: dismissible,
    barrierColor: Colors.black.withOpacity(0.7),
    transitionDuration: Duration(milliseconds: 300),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height:isIconEnable||!isCancelBtnEnabled? 230:260,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Visibility(
                visible: isIconEnable,
                child: Column(
                  children: [
                    Icon(
                      Icons.assignment_turned_in_outlined,
                      size: 50,
                      color: Colors.cyan,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Material(
                  color: Colors.white,
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'RedHatDisplay',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      letterSpacing: 0.4,
                      height: 0.9,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: NegativeOutlineButton(
                            onPress: () {
                              negativeBtnOnClick();
                            }, text: negativeBtnText),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: SubmitButton(onPress: () {
                          positiveBtnOnClick();
                        }, text: positiveBtnText),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible:isCancelBtnEnabled,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                  child: NegativeOutlineButton(
                      onPress: () {
                        cancelBtnOnClick();
                      }, text: "Cancel"),
                ),
              ),

            ],
          ),
          margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isIconEnable?40:30),
          ),
        ),
      );
    },
  );
}
