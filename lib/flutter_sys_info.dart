import 'package:flutter/services.dart';
import 'package:flutter_sys_info/constants/enums/enums.dart';
import 'package:flutter_sys_info/helper/switch_memory_type.dart';
import 'package:flutter_sys_info/model/bluetooth_device.dart';
import 'flutter_sys_info_platform_interface.dart';

export 'constants/enums/enums.dart';

class FlutterSysInfoNetwork {
  Future<String?> getWifiSSID() {
    return FlutterSysInfoNetworkPlatform.instance.getWifiSSID();
  }

  Future<String?> getWifiBSSID() {
    return FlutterSysInfoNetworkPlatform.instance.getWifiBSSID();
  }

  Future<int?> getWifiNetworkSpeed() {
    return FlutterSysInfoNetworkPlatform.instance.getWifiNetworkSpeed();
  }

  Future<int?> getWifiIP() {
    return FlutterSysInfoNetworkPlatform.instance.getWifiIP();
  }

  Future<int?> getWifiRSSI() {
    return FlutterSysInfoNetworkPlatform.instance.getWifiRSSI();
  }
}

class FlutterSysInfo {

  static const EventChannel _bluetoothScanChannel =
      EventChannel('bluetooth_scan_stream');

  static const EventChannel _batteryLevelChannel =
      EventChannel('battery_level_stream');

  static const EventChannel _batteryTempChannel =
      EventChannel('battery_temp_stream');

  static const EventChannel _wifiRssiChannel = EventChannel('wifi_rssi_stream');

  static const EventChannel _wifiConnectionChannel =
      EventChannel('internet_connection_stream');


  Stream<BluetoothDevice> get bluetoothScanStream {
    return _bluetoothScanChannel
        .receiveBroadcastStream('bluetooth_scan_stream')
        .map((event) => BluetoothDevice.fromMap(event));
  }

  Stream<int> get batteryLevelStream {
    return _batteryLevelChannel
        .receiveBroadcastStream('battery_level_stream')
        .map((event) => event as int);
  }

  Stream<double> get batteryTemperatureStream {
    return _batteryTempChannel
        .receiveBroadcastStream('battery_temp_stream')
        .map((event) => event as double);
  }

  Stream<int> get wifiRssiStream {
    return _wifiRssiChannel
        .receiveBroadcastStream('wifi_rssi_stream')
        .map((event) => event as int);
  }

  Stream<bool> get wifiConnectionStream {
    return _wifiConnectionChannel
        .receiveBroadcastStream('internet_connection_stream')
        .map((event) => event as bool);
  }

  Future<double?> getBatteryTemperature() {
    return FlutterSysInfoPlatform.instance.getBatteryTemperature();
  }

  Future<String?> getPlatformVersion() {
    return FlutterSysInfoPlatform.instance.getPlatformVersion();
  }

  Future<int?> getBatteryLevel() {
    return FlutterSysInfoPlatform.instance.getBatteryLevel();
  }

  Future<String?> getDeviceModel() {
    return FlutterSysInfoPlatform.instance.getDeviceModel();
  }

  Future<int?> getSdkVersion() {
    return FlutterSysInfoPlatform.instance.getSdkVersion();
  }

  Future<int?> getTotalMemory({required MemoryUnit memoryUnit}) async {
    final int? memory = await FlutterSysInfoPlatform.instance.getTotalMemory();
    if (memory == null) return null;

    return switchMemoryType(memoryUnit, memory);
  }

  Future<int?> getStorageInfo({
    required StorageInfoType storageInfoType,
    required MemoryUnit memoryUnit,
  }) async {
    Map<Object?, Object?>? data =
        await FlutterSysInfoPlatform.instance.getStorageInfo();
    Object? value;

    if (data == null) return null;

    switch (storageInfoType) {
      case StorageInfoType.TOTAL:
        value = data[StorageInfoType.TOTAL.value];
        break;

      case StorageInfoType.AVAILABLE:
        value = data[StorageInfoType.AVAILABLE.value];
        break;
    }

    return switchMemoryType(memoryUnit, int.parse(value.toString()));
  }
}
//which enum name is the best explaining the purpose of the enum?
