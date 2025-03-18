package com.example.flutter_sys_info

import androidx.annotation.NonNull
import android.content.Context

import android.os.BatteryManager

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import io.flutter.plugin.common.EventChannel
import android.content.BroadcastReceiver
import android.content.Intent
import android.content.IntentFilter


/** FlutterSysInfoPlugin */
class FlutterSysInfoPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context : Context
  //event channel

  private lateinit var eventHandler: SysInfoEventHandler
  private lateinit var methodHandler: SysInfoMethodHandler

  private lateinit var batteryLevelEventChannel: EventChannel
  private lateinit var batteryTempEventChannel: EventChannel
  private lateinit var wifiRssiEventChannel: EventChannel
  private lateinit var internetConnectionStream: EventChannel
  private lateinit var bluetoothScanStream: EventChannel
  


  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_sys_info")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext

    methodHandler = SysInfoMethodHandler(context)
    eventHandler = SysInfoEventHandler(context)

    batteryLevelEventChannel = EventChannel(flutterPluginBinding.binaryMessenger,"battery_level_stream")
    batteryLevelEventChannel.setStreamHandler(eventHandler)

    batteryTempEventChannel = EventChannel(flutterPluginBinding.binaryMessenger,"battery_temp_stream")
    batteryTempEventChannel.setStreamHandler(eventHandler)

    wifiRssiEventChannel = EventChannel(flutterPluginBinding.binaryMessenger,"wifi_rssi_stream")
    wifiRssiEventChannel.setStreamHandler(eventHandler)

    internetConnectionStream = EventChannel(flutterPluginBinding.binaryMessenger,"internet_connection_stream")
    internetConnectionStream.setStreamHandler(eventHandler)

    bluetoothScanStream = EventChannel(flutterPluginBinding.binaryMessenger,"bluetooth_scan_stream")
    bluetoothScanStream.setStreamHandler(eventHandler)

  }


  override fun onMethodCall(call: MethodCall, result: Result) {
    methodHandler.handleMethodCall(call,result)
  }



  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

}