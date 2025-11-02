// lib/auth_utils.dart
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

String _bytesToBase64(List<int> bytes) => base64Encode(bytes);

List<int> _base64ToBytes(String b64) => base64Decode(b64);

/// Generate salt acak 16 byte (base64)
String generateSalt({int length = 16}) {
  final rand = Random.secure();
  final bytes = List<int>.generate(length, (_) => rand.nextInt(256));
  return _bytesToBase64(bytes);
}

/// Hash = SHA256( salt + password ) → base64
String hashPassword(String password, String saltB64) {
  final saltBytes = _base64ToBytes(saltB64);
  final passBytes = utf8.encode(password);
  final combined = <int>[...saltBytes, ...passBytes];
  final digest = sha256.convert(combined);
  return _bytesToBase64(digest.bytes);
}
