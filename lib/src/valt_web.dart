import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:universal_html/html.dart';

/// This class provides methods for storing and retrieving values from local storage. Values are encrypted
/// using AES encryption, and can be of type String, bool, int, double, or List<dynamic>. Values are
/// identified by a key, which is a unique string used to retrieve the stored value.
class Valt {
  static final _key = Uint8List.fromList(
      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
  static final _keyBytes = utf8.encode(String.fromCharCodes(_key));
  static final _encrypter =
      Encrypter(AES(Key(Uint8List.fromList(_keyBytes)), mode: AESMode.cbc));

  /// Encrypts the given value using AES encryption and returns the encrypted value as a string.
  static String _encryptValue(String value) {
    final iv = IV.fromLength(16);
    final encrypted = _encrypter.encrypt(value, iv: iv);
    return base64Url.encode(encrypted.bytes);
  }

  /// Decrypts the given value using AES encryption and returns the decrypted value as a string.
  static String _decryptValue(String encryptedValue) {
    final decodedValue = base64Url.decode(encryptedValue);
    final iv = IV.fromLength(16);
    final decrypted = _encrypter.decrypt(Encrypted(decodedValue), iv: iv);
    return decrypted;
  }

  /// Encrypts the given key using AES encryption and returns the encrypted value as a String.
  static String _encryptKey(String key) {
    final hmac = Hmac(sha256, _keyBytes);
    final digest = hmac.convert(utf8.encode(key));
    return base64Url.encode(digest.bytes);
  }

  /// Stores a value of any data type to local storage with the given key using JSON encoding and encryption.
  /// Returns true if the operation was successful, and false otherwise.
  static bool set(String key, value) {
    try {
      final jsonString = jsonEncode(value);
      final encryptedValue = _encryptValue(jsonString);
      window.localStorage[_encryptKey(key)] = encryptedValue;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the encrypted value associated with the given key from local storage using getString(),
  /// decodes it from base64, and returns the decoded value as an object of the specified data type.
  /// Returns null if the operation failed.
  static dynamic get(String key) {
    try {
      final encryptedValue = window.localStorage[_encryptKey(key)];
      final decryptedValue = _decryptValue(encryptedValue!);
      final dynamicValue = jsonDecode(decryptedValue);
      final typedValue = dynamicValue;
      return typedValue;
    } catch (e) {
      return null;
    }
  }

  /// Encrypts the given value using AES encryption and saves it to local storage with the given key.
  /// Returns true if the operation was successful, and false otherwise.
  static bool setString(String key, String value) {
    try {
      final encryptedValue = _encryptValue(value);
      window.localStorage[_encryptKey(key)] = encryptedValue;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the value with the given key from local storage and decrypts it using AES encryption.
  /// Returns the decrypted value as a String, or null if the operation failed.
  static String? getString(String key) {
    try {
      final encryptedValue = window.localStorage[_encryptKey(key)];
      final decryptedValue = _decryptValue(encryptedValue!);
      return decryptedValue;
    } catch (e) {
      return null;
    }
  }

  /// Encrypts the given value using AES encryption and saves it to local storage with the given key.
  /// Returns true if the operation was successful, and false otherwise.
  static Future<bool> setBool(String key, bool value) async {
    try {
      final byteData = ByteData(1);
      byteData.setUint8(0, value ? 1 : 0);
      final boolValue = byteData.getUint8(0);
      return setInt(key, boolValue);
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the value with the given key from local storage and decrypts it using AES encryption.
  /// Returns the decrypted value as a bool, or null if the operation failed.
  static Future<bool?> getBool(String key) async {
    final intValue = getInt(key);
    if (intValue != null && (intValue == 0 || intValue == 1)) {
      return intValue == 1;
    }
    return null;
  }

  /// Encrypts the given value using AES encryption and saves it to local storage with the given key.
  /// Returns true if the operation was successful, and false otherwise.
  static bool setInt(String key, int value) {
    try {
      final encryptedValue = _encryptValue(value.toString());
      window.localStorage[_encryptKey(key)] = encryptedValue;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the value with the given key from local storage and decrypts it using AES encryption.
  /// Returns the decrypted value as an int, or null if the operation failed.
  static int? getInt(String key) {
    try {
      final encryptedValue = window.localStorage[_encryptKey(key)];
      final decryptedValue = _decryptValue(encryptedValue!);
      return int.parse(decryptedValue);
    } catch (e) {
      return null;
    }
  }

  /// Encrypts the given value using AES encryption and saves it to local storage with the given key.
  /// Returns true if the operation was successful, and false otherwise.
  static bool setDouble(String key, double value) {
    try {
      final encryptedValue = _encryptValue(value.toString());
      window.localStorage[_encryptKey(key)] = encryptedValue;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the value with the given key from local storage and decrypts it using AES encryption.
  /// Returns the decrypted value as a double, or null if the operation failed.
  static double? getDouble(String key) {
    try {
      final encryptedValue = window.localStorage[_encryptKey(key)];
      final decryptedValue = _decryptValue(encryptedValue!);
      return double.parse(decryptedValue);
    } catch (e) {
      return null;
    }
  }

  /// Encrypts the given value using AES encryption and saves it to local storage with the given key.
  /// Returns true if the operation was successful, and false otherwise.
  static bool setList(String key, List<dynamic> value) {
    try {
      final jsonString = jsonEncode(value);
      final encryptedValue = _encryptValue(jsonString);
      window.localStorage[_encryptKey(key)] = encryptedValue;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the value with the given key from local storage and decrypts it using AES encryption.
  /// Returns the decrypted value as a List<dynamic>, or null if the operation failed.
  static List<dynamic>? getList(String key) {
    try {
      final encryptedValue = window.localStorage[_encryptKey(key)];
      final decryptedValue = _decryptValue(encryptedValue!);
      final dynamicList = jsonDecode(decryptedValue);
      final typedList = dynamicList as List<dynamic>;
      return typedList;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> setMap(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      final encryptedValue = _encryptValue(jsonString);
      window.localStorage[_encryptKey(key)] = encryptedValue;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the encrypted value associated with the given key from local storage using getString(),
  /// decodes it from base64, and returns the decoded value as a Map<String, dynamic>. Returns null if the operation failed.
  static Future<Map<String, dynamic>?> getMap(String key) async {
    try {
      final encryptedValue = window.localStorage[_encryptKey(key)];
      final decryptedValue = _decryptValue(encryptedValue!);
      final dynamicList = jsonDecode(decryptedValue);
      final typedList = dynamicList as Map<String, dynamic>;
      return typedList;
    } catch (e) {
      return null;
    }
  }
}
