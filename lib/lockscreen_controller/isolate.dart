import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/services.dart';
import 'lockscreen_controller.dart';
import 'lockscreen_data_model.dart';

void myIsolate(IsolateArgs isolateArgs) {
  BackgroundIsolateBinaryMessenger.ensureInitialized(
      isolateArgs.rootIsolateToken);
  final ReceivePort sendPort = ReceivePort();
  isolateArgs.receivePort.send(sendPort.sendPort);

  final LockscreenController lockscreenController =
      LockscreenController(channelKey: 'DI');

  int counter = 0;
  int duration = 0;
  int currentSet = 1;
  int indexTime = 0;
  bool isPaused = false;
  bool stop = false;
  late List<dynamic> time;
  late int sets;

  Timer.periodic(const Duration(seconds: 1), (timer) {
    duration++;

    if (stop) {
      timer.cancel();
      lockscreenController.stopLiveActivity();
    }

    if (counter == 1) {
      if (indexTime == 1 && sets == currentSet) {
        timer.cancel();
      }
      if (indexTime == 1) {
        ++currentSet;
      }
      indexTime = indexTime == 1 ? 0 : 1;
      counter = time[indexTime] + 1;
    } else if (counter > 0 && !isPaused) {
      lockscreenController.updateLiveActivity(
        jsonData: LockscreenDataModel(
          elapsedSeconds: --counter,
        ).toMap(),
      );

      print(counter);
    }
  });

  sendPort.listen((message) {
    if (message['stop'] != null) {
      stop = true;
    } else if (message["indexTime"] != null) {
      indexTime = message["indexTime"];
      counter = message["counter"];
      currentSet = message["currentSet"];
    } else if (message['time'] != null) {
      time = message['time'];
      sets = message['sets'];
      counter = time[indexTime] - 1;
      lockscreenController.startLiveActivity(
        jsonData: LockscreenDataModel(elapsedSeconds: counter).toMap(),
      );
    } else if (message["isPaused"] != null) {
      isPaused = message["isPaused"];
    } else if (message['resumed'] != null) {
      isolateArgs.receivePort.send({
        'duration': duration,
        "currentSet": currentSet,
        "indexTime": indexTime,
        "counter": counter
      });
    }
  });
}

class IsolateArgs {
  final RootIsolateToken rootIsolateToken;
  final SendPort receivePort;
  IsolateArgs(this.rootIsolateToken, this.receivePort);
}

Future<SendPort> initializeSendPort(ReceivePort receivePort) async {
  Completer completer = Completer<SendPort>();
  receivePort.listen((data) {
    if (data is SendPort) {
      SendPort sendPort = data;
      completer.complete(sendPort);
    }
  });

  return completer.future as Future<SendPort>;
}
