import 'dart:convert';
import 'dart:math' as math;
import 'package:crypto/crypto.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';

class IdHandler {
  static String? _deviceId;

  static Future<String?> tryGetDeviceId() async {
    if (_deviceId != null) {
      return _deviceId;
    }
    final deviceId = await MobileDeviceIdentifier().getDeviceId();

    if (deviceId == null) return null;

    final base64Hash = _hashSHA256(deviceId);

    _deviceId = base64Hash.substring(0, math.min(base64Hash.length, 36));

    return _deviceId;
  }

  static Future<String> getDeviceId() async {
    final deviceId = await tryGetDeviceId();
    if (deviceId == null) {
      throw Exception('Device ID is null');
    }
    return deviceId;
  }

  static String _hashSHA256(String input) {
    var bytes = utf8.encode(input); // Convert to bytes
    var digest = sha256.convert(bytes); // Perform SHA-256 hash

    // Convert the hash to a Base64-encoded string
    String base64Hash = base64UrlEncode(digest.bytes);
    return base64Hash;
  }
}
