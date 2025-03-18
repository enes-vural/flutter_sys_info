import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sys_info/flutter_sys_info.dart';

class StreamPage extends StatefulWidget {
  const StreamPage({super.key});

  @override
  State<StreamPage> createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  final FlutterSysInfo _flutterSysInfoPlugin = FlutterSysInfo();

  Stream<int>? batteryLevelStream;
  Stream<double>? batteryTemperatureStream;
  Stream<int>? wifiRssiStream;
  Stream<bool>? wifiConnectionStream;

  StreamSubscription<int>? _batteryLevelStreamSubscription;
  StreamSubscription<double>? _batteryTemperatureStreamSubscription;
  StreamSubscription<int>? _wifiRssiStreamSubscription;
  StreamSubscription<bool>? _wifiConnectionStreamSubscription;

  String batteryLevel = 'Unknown';
  String batteryTemperature = 'Unknown';
  String wifiRssi = 'Unknown';
  String wifiConnection = 'Unknown';

  Future<void> initStreams() async {
    batteryLevelStream = _flutterSysInfoPlugin.batteryLevelStream;
    _batteryLevelStreamSubscription = batteryLevelStream?.listen((event) {
      debugPrint('Battery level stream: $event');
      batteryLevel = event.toString();
      setState(() {});
    });

    batteryTemperatureStream = _flutterSysInfoPlugin.batteryTemperatureStream;
    _batteryTemperatureStreamSubscription =
        batteryTemperatureStream?.listen((event) {
      debugPrint('Battery temperature stream: $event');
      batteryTemperature = event.toString();
      setState(() {});
    });

    wifiRssiStream = _flutterSysInfoPlugin.wifiRssiStream;
    _wifiRssiStreamSubscription = wifiRssiStream?.listen((event) {
      debugPrint('Wifi RSSI stream: $event');
      wifiRssi = event.toString();
      setState(() {});
    });

    wifiConnectionStream = _flutterSysInfoPlugin.wifiConnectionStream;
    _wifiConnectionStreamSubscription = wifiConnectionStream?.listen((event) {
      debugPrint('Wifi connection stream: $event');
      wifiConnection = event.toString();
      setState(() {});
    });
  }

  void cancelSubscriptions() {
    _batteryLevelStreamSubscription?.cancel();
    _batteryLevelStreamSubscription = null;

    _batteryTemperatureStreamSubscription?.cancel();
    _batteryTemperatureStreamSubscription = null;

    _wifiRssiStreamSubscription?.cancel();
    _wifiRssiStreamSubscription = null;

    _wifiConnectionStreamSubscription?.cancel();
    _wifiConnectionStreamSubscription = null;
  }

  @override
  void initState() {
    super.initState();

    initStreams();
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cancelSubscriptions();
        },
        child: const Icon(Icons.cancel),
      ),
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Battery level: $batteryLevel"),
          Text("Battery temperature: $batteryTemperature"),
          Text("Wifi RSSI: $wifiRssi"),
          Text("Wifi connection: $wifiConnection"),
        ],
      ),
    );
  }
}
