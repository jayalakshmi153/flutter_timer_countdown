library flutter_timer_countdown;

import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timer_countdown/utils/commonInfoDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

import 'Buttons/NegativeOutlineButton.dart';
import 'Buttons/RoundButton.dart';
import 'Buttons/SubmitButton.dart';


void main() {
  runApp(MyApp(duration: 10,));
}

class MyApp extends StatefulWidget {
  int? duration = 10;
  MyApp(
      {required this.duration});

  @override
  _MyAppState createState() =>
      _MyAppState();
}

class _MyAppState
    extends State<MyApp>
    with TickerProviderStateMixin {
  var _isPlaying = false;
  var currentTime = 0;
  var counter = 0;
  bool _isDialogShown = false;
  bool isextended = false;
  int spedntime = 0;
  final service = FlutterBackgroundService();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  var _isTimerStarted = false;
  Timer? timer, notificationUpdateTimer;
  var _playEnabled = true;
  Duration pauseTime = Duration(seconds: 0);
  DateTime startTime = DateTime.now();


  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    service.on('update');
    service.invoke("setAsForeground");
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isPlaying && _isTimerStarted) {
        pauseTime += Duration(seconds: 1);
      }
    });

    Wakelock.enable();
  }

  // to ensure this is executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
  bool onIosBackground(ServiceInstance service) {
    WidgetsFlutterBinding.ensureInitialized();
    print('FLUTTER BACKGROUND FETCH');

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _commonInfo(),
      child: MaterialApp(
        home: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _isDialogShown = true;
                    debugPrint('_isDialogShown11 : $_isDialogShown');
                  }),
              title: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  'TIMER',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'RedHatDisplay',
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    letterSpacing: 1,
                    height: 0.9,
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 36.0,
                  width: 241,
                  child: Container(
                    child: Center(
                      child: Text(
                        'Therapy Duration - ${widget.duration} Minutes',
                      ),
                    ),
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        formatedTime(timeInSecond: currentTime),
                        style:
                        TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_playEnabled) {
                              setState(() => _playEnabled = false);
                              Timer(Duration(seconds: 1),
                                      () => setState(() => _playEnabled = true));
                              if (!_isPlaying) {
                                startTimer();
                                print("counter val: $counter");
                                Duration durationMin =
                                Duration(minutes: widget.duration!);
                                DateTime now = DateTime.now().add(durationMin);
                                if (counter == 0) {
                                  //first time start
                                  startTime = DateTime.now();
                                  Duration durationMin =
                                  Duration(minutes: widget.duration!);
                                  DateTime now = DateTime.now().add(durationMin);
                                  // _pushNotification(now);
                                } else {
                                  //unpause
                                  Duration durMin =
                                  Duration(minutes: widget.duration!);
                                  DateTime endMin = startTime.add(durMin);
                                  // _pushNotification(endMin.add(pauseTime));
                                }
                              } else {
                                pauseTimer();
                              }
                            }
                          },
                          child: RoundButton(
                            icon: _isPlaying == true
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _pop_for_validation(
                                'The therapy duration is ${widget.duration} minutes, this therapy session will not be considered as valid. Are you sure to end the session?');
                          },
                          child: Visibility(
                            visible: _isTimerStarted,
                            child: RoundButton(
                              icon: Icons.stop,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        builder: EasyLoading.init(),
      ),
    );
  }

  _commonInfo() {
    _isDialogShown = true;
    commonInfoDialog(context,
        "Therapy will be terminated.Are you sure you want to exit the page?",
        positiveBtnText: "NO",
        negativeBtnText: "YES, EXIT", negativeBtnOnClick: () {
          _isDialogShown = false;
        }, positiveBtnOnClick: () {
          Navigator.of(context).pop(false);
        });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      print(t.tick);
      setState(() {
        if (counter == 0) {
        }
        counter++;
        currentTime = counter;
        if (counter >= widget.duration! * 60) {
          _isPlaying = false;
          timer!.cancel();
          _pop_for_timeup();
        } else {
          _isPlaying = true;
          _isTimerStarted = true;
        }
      });
    });
  }

  void pauseTimer() {
    setState(() {
      counter = currentTime;
      _isPlaying = false;
      if (timer!.isActive) timer!.cancel();
    });
  }

  String formatedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }


  _pop_for_timeup() {
    if (_isDialogShown)
      Navigator.of(context, rootNavigator: true).pop('dialog');
    _isDialogShown = true;
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return MaterialApp(
          home: Container(
            height: 270,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Text(
                    'The therapy duration is ${widget.duration} minutes, do you want to extend the duration?',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: NegativeOutlineButton(
                              text: 'No',
                              onPress: () {
                                _isDialogShown = false;
                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                                // stopBackgroundService();
                              }),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        Expanded(
                            flex: 1,
                            child: SubmitButton(
                              onPress: () async {

                              },
                              text: 'Yes',
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _pop_for_validation(String msg) {
    _isDialogShown = true;
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Container(
          height: 270,
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 24,
                ),
                Text(msg,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: NegativeOutlineButton(
                            text: 'Yes',
                            onPress: () {
                              _isDialogShown = false;
                              // _deleteNotification(widget.duration!);
                              // stopBackgroundService();
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');

                            }),
                      ),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                          flex: 1,
                          child: SubmitButton(
                            onPress: () {
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            },
                            text: 'No',
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString("hello", "world");

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
}

