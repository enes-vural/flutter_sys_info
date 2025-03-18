import 'package:flutter/material.dart';

final class BluetoothDevice {
  final String? deviceName;
  final String? deviceAddress;
  final int? rssi;

  const BluetoothDevice({
    this.deviceName = "N/A",
    required this.deviceAddress,
    required this.rssi,
  });

  factory BluetoothDevice.fromMap(Map<Object?, dynamic> map) {
    debugPrint(map.toString());
    return BluetoothDevice(
      deviceName: map['deviceName'] ?? "N/A",
      deviceAddress: map['deviceAddress'],
      rssi: map['rssi'],
    );
  }
}
