import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sys_info/flutter_sys_info.dart';
import 'package:flutter_sys_info_example/bluetooth/bluetooth_page.dart';
import 'package:flutter_sys_info_example/stream_page.dart';

//import 'package:permission_handler/permission_handler.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    //Permission.location.request(); need for wifi ssid

    return MaterialApp(home: MethodPage());
  }
}

class MethodPage extends StatefulWidget {
  const MethodPage({super.key});

  @override
  State<MethodPage> createState() => _MethodPageState();
}

class _MethodPageState extends State<MethodPage> {
  String? _platformVersion = 'Unknown';
  int? storageInfo;
  int? totalMemory;
  int? sdkVersion;
  String? deviceModel;
  String? wifiSSID;
  String? wifiBSSID;
  int? wifiNetworkSpeed;
  int? wifiRSSI;
  int? wifiIP;
  double? batteryTemp;
  String? cpuTemp;
  
  final _flutterSysInfoPlugin = FlutterSysInfo();
  final _flutterSysInfoNetwork = FlutterSysInfoNetwork();

  int? batteryLevel;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    getBatteryLevel();
    getInfos();
  }


  Future<void> initPlatformState() async {
    _platformVersion = await _flutterSysInfoPlugin.getPlatformVersion() ??
        'Unknown platform version';
    debugPrint("Platform version: $_platformVersion");
    setState(() {});
  }

  Future<void> getBatteryLevel() async {
    int? battery = await _flutterSysInfoPlugin.getBatteryLevel();
    batteryLevel = battery;

    debugPrint('Battery level: $batteryLevel');
    setState(() {});
  }

  Future<void> getInfos() async {
    deviceModel = await _flutterSysInfoPlugin.getDeviceModel();
    sdkVersion = await _flutterSysInfoPlugin.getSdkVersion();
    totalMemory =
        await _flutterSysInfoPlugin.getTotalMemory(memoryUnit: MemoryUnit.MB);
    storageInfo = await _flutterSysInfoPlugin.getStorageInfo(
      storageInfoType: StorageInfoType.AVAILABLE,
      memoryUnit: MemoryUnit.GB,
    );

    wifiSSID = await _flutterSysInfoNetwork.getWifiSSID();
    wifiBSSID = await _flutterSysInfoNetwork.getWifiBSSID();
    wifiNetworkSpeed = await _flutterSysInfoNetwork.getWifiNetworkSpeed();
    wifiRSSI = await _flutterSysInfoNetwork.getWifiRSSI();
    wifiIP = await _flutterSysInfoNetwork.getWifiIP();
    batteryTemp = await _flutterSysInfoPlugin.getBatteryTemperature();

    debugPrint('Device model: $deviceModel');
    debugPrint('SDK version: $sdkVersion');
    debugPrint('Total memory: $totalMemory');
    debugPrint('Storage info: $storageInfo');
    debugPrint("Wifi SSID: $wifiSSID");
    debugPrint("Wifi BSSID: $wifiBSSID");
    debugPrint("Wifi network speed: $wifiNetworkSpeed");
    debugPrint("Wifi RSSI: $wifiRSSI");
    debugPrint("Wifi IP: $wifiIP");
    debugPrint("Battery temperature: $batteryTemp");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Positioned(
            bottom: 80,
            right: 20,
            child: FloatingActionButton(
              heroTag: 'stream',
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const StreamPage(),
                    transitionDuration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Icon(Icons.data_array_outlined),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              heroTag: 'bluetooth',
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const BluetoothPage(),
                    transitionDuration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Icon(Icons.bluetooth),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Running on: $_platformVersion\n'),
            Text("Battery : %$batteryLevel\n"),
            Text("Device model: $deviceModel\n"),
            Text("SDK version: $sdkVersion\n"),
            Text("Total memory: $totalMemory\n"),
            Text("Storage info: $storageInfo\n"),
            Text("Wifi SSID: $wifiSSID\n"),
            Text("Wifi BSSID: $wifiBSSID\n"),
            Text("Wifi network speed: $wifiNetworkSpeed\n"),
            Text("Wifi RSSI: $wifiRSSI\n"),
            Text("Wifi IP: $wifiIP\n"),
            Text("Battery temperature: $batteryTemp\n"),
          ],
        ),
      ),
    );
  }
}

  

