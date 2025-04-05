import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:cerax_app_v1/core/models/sensor_data.dart';

class BLEService {
  static const String deviceName = "PlantMonitor";
  static final Guid serviceUuid = Guid("12345678-1234-1234-1234-1234567890ab");
  static final Guid characteristicUuid = Guid(
    "abcd0003-1234-1234-1234-1234567890ab",
  );

  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _characteristic;

  Future<void> connectToDevice() async {
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    final subscription = FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (r.device.platformName == deviceName) {
          _connectedDevice = r.device;
          await FlutterBluePlus.stopScan();
          await _connectedDevice!.connect(autoConnect: false);
          await _discoverServices(_connectedDevice!);
          break;
        }
      }
    });

    await Future.delayed(const Duration(seconds: 6));
    await FlutterBluePlus.stopScan();
    await subscription.cancel();

    if (_connectedDevice == null) {
      throw Exception("PlantMonitor device not found.");
    }
  }

  Future<void> _discoverServices(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      if (service.uuid == serviceUuid) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid == characteristicUuid) {
            _characteristic = characteristic;
            await _characteristic!.setNotifyValue(true);
          }
        }
      }
    }
  }

  Stream<SensorData> sensorDataStream() {
    if (_characteristic == null) {
      throw Exception("BLE characteristic not found.");
    }

    return _characteristic!.lastValueStream.map((data) {
      final jsonString = utf8.decode(data);
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return SensorData.fromJson(json);
    });
  }

  Future<void> disconnect() async {
    await _connectedDevice?.disconnect();
  }
}
