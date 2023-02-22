

import 'dart:async';
import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';

class TimerController{
  Timer? _timer;

  void startTimer({required int startTime, required Function(int time) onTimeChanged}){
    int time = startTime;
    if(_timer != null) {
      _timer!.cancel();
      _timer = null;
      return;
    }
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      onTimeChanged(time++);
    });
  }


  void stopTimer({required VoidCallback onTimerStopped}){
    if(_timer != null){
      _timer!.cancel();
      _timer = null;
      onTimerStopped.call();
      return;
    }
  }

  void onDispose(){
    _timer!.cancel();
  }

}