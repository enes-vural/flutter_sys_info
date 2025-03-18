import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sys_info/flutter_sys_info.dart';
import 'package:flutter_sys_info/model/bluetooth_device.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  final FlutterSysInfo _flutterSysInfoPlugin = FlutterSysInfo();

  Stream<dynamic>? bluetoothScanStream;
  StreamSubscription<dynamic>? _bluetoothScanStreamSubscription;
  List<BluetoothDevice> bluetoothDevices = [];

  Future<void> initBluetoothStreams() async {
    bluetoothScanStream = _flutterSysInfoPlugin.bluetoothScanStream;

    if (bluetoothScanStream != null) {
      _bluetoothScanStreamSubscription = bluetoothScanStream?.listen((event) {
        debugPrint('Bluetooth scan stream: $event');
        bluetoothDevices.add(event);
        setState(() {});
      });
    } else {
      debugPrint('Bluetooth stream is null');
    }
  }

  void cancelBluetoothStreams() {
    _bluetoothScanStreamSubscription?.cancel();
    _bluetoothScanStreamSubscription = null;
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> checkBluetoothPermissions() async {
    if (!await Permission.bluetooth.isGranted) {
      await Permission.bluetooth.request();
    }
    if (!await Permission.bluetoothScan.isGranted) {
      await Permission.bluetoothScan.request();
    }
    if (!await Permission.bluetoothConnect.isGranted) {
      await Permission.bluetoothConnect.request();
    }
    if (!await Permission.location.isGranted) {
      await Permission.location.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Page'),
        actions: [
          IconButton(
              onPressed: () => cancelBluetoothStreams(),
              icon: Icon(Icons.cancel_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await checkBluetoothPermissions().then((_) => initBluetoothStreams());
        },
        child: const Icon(Icons.bluetooth),
      ),
      body: ListView.builder(
        itemCount: bluetoothDevices.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => debugPrint(
                'Tapped on ${bluetoothDevices[index].deviceAddress}'),
            child: ListTile(
              title: Text(bluetoothDevices[index].deviceName ?? "N/A"),
              subtitle: Text(bluetoothDevices[index].deviceAddress.toString()),
              trailing: Text(bluetoothDevices[index].rssi.toString()),
            ),
          );
        },
      ),
    );
  }
}
