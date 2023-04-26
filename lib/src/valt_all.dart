import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:path_provider/path_provider.dart';

/// This class provides methods for storing and retrieving values from local storage. Values are encrypted
/// using AES encryption, and can be of type String, bool, int, double, or List<dynamic>. Values are
/// identified by a key, which is a unique string used to retrieve the stored value.
class Valt {
  static final _key = Uint8List.fromList(
      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
  static final _keyBytes = utf8.encode(String.fromCharCodes(_key));
  static final _encrypter =
      Encrypter(AES(Key(Uint8List.fromList(_keyBytes)), mode: AESMode.cbc));
  static Directory? _directory;

  /// Returns the local path of the app's documents directory as a Future<String>.
  static Future<String> get _localPath async {
    if (_directory != null) {
      return _directory!.path;
    }

    _directory = await getApplicationDocumentsDirectory();
    final dirPath = '${_directory!.path}'; // specify the folder name
    final dir = Directory(dirPath);
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  /// Returns a File object with the given key as part of its name as a Future<File>.
  static Future<File> _getFile(String key) async {
    final path = await _localPath;
    return File('$path/${_encryptKey(key)}valt_path.txt');
  }

  /// Stores a value of any data type to local storage with the given key using JSON encoding and encryption.
  /// Returns true if the operation was successful, and false otherwise.
  static Future<bool> set(String key, value) async {
    try {
      final file = await _getFile(key);
      final jsonString = jsonEncode(value);
      final encryptedValue = _encryptValue(jsonString);
      await file.writeAsString(encryptedValue);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the encrypted value associated with the given key from local storage using getString(),
  /// decodes it from base64, and returns the decoded value as an object of the specified data type.
  /// Returns null if the operation failed.
  static Future<dynamic> get(String key) async {
    try {
      final file = await _getFile(key);
      final contents = await file.readAsString();
      final decryptedValue = _decryptValue(contents);
      final dynamicValue = jsonDecode(decryptedValue);
      final typedValue = dynamicValue;
      return typedValue;
    } catch (e) {
      return null;
    }
  }

  /// Encrypts the given value using AES encryption and saves it to local storage with the given key.
  /// Returns true if the operation was successful, and false otherwise.
  static Future<bool> setString(String key, String value) async {
    try {
      final file = await _getFile(key);
      final encryptedValue = _encryptValue(value);
      await file.writeAsString(encryptedValue);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the value with the given key from local storage and decrypts it using AES encryption.
  /// Returns the decrypted value as a String, or null if the operation failed.
  static Future<String?> getString(String key) async {
    try {
      final file = await _getFile(key);
      final contents = await file.readAsString();
      return _decryptValue(contents);
    } catch (e) {
      return null;
    }
  }

  /// Converts the given bool value to a ByteData object and calls setInt() to save it to local storage
  /// with the given key. Returns true if the operation was successful, and false otherwise.
  static Future<bool> setBool(String key, bool value) async {
    final byteData = ByteData(1);
    byteData.setUint8(0, value ? 1 : 0);
    final boolValue = byteData.getUint8(0);
    return await setInt(key, boolValue);
  }

  /// Retrieves the int value associated with the given key from local storage using getInt() and
  /// returns it as a bool value. If the int value is 0, returns false. If the int value is 1,
  /// returns true. Otherwise, returns null if the operation failed.
  static Future<bool?> getBool(String key) async {
    final intValue = await getInt(key);
    if (intValue != null && (intValue == 0 || intValue == 1)) {
      return intValue == 1;
    }
    return null;
  }

  /// Converts the given Map<String, dynamic> value to a JSON-encoded string, encrypts it using AES encryption,
  /// and saves it to local storage with the given key. Returns true if the operation was successful,
  /// and false otherwise.
  static Future<bool> setMap(String key, Map<String, dynamic> value) async {
    try {
      final file = await _getFile(key);
      final jsonString = jsonEncode(value);
      final encryptedValue = _encryptValue(jsonString);
      await file.writeAsString(encryptedValue);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the encrypted value associated with the given key from local storage using getString(),
  /// decodes it from base64, and returns the decoded value as a Map<String, dynamic>. Returns null if the operation failed.
  static Future<Map<String, dynamic>?> getMap(String key) async {
    try {
      final file = await _getFile(key);
      final contents = await file.readAsString();
      final decryptedValue = _decryptValue(contents);
      final dynamicMap = jsonDecode(decryptedValue) as Map<String, dynamic>;
      return dynamicMap;
    } catch (e) {
      return null;
    }
  }

  static Future<double?> getDouble(String key) async {
    final encodedValue = await getString(key);

    if (encodedValue != null) {
      final decodedValue = base64Url.decode(encodedValue);
      final value = ByteData.view(decodedValue.buffer).getFloat64(0);
      return value;
    }
    return null;
  }

  static Future<bool> setDouble(String key, double value) async {
    final bytes = ByteData(8);
    bytes.setFloat64(0, value);
    final encodedValue = base64Url.encode(bytes.buffer.asUint8List());
    return await setString(key, encodedValue);
  }

  /// Retrieves the encrypted value associated with the given key from local storage using getString(),
  /// decodes it from base64, and returns the decoded value as a List<dynamic>. Returns null if the operation failed.
  static Future<bool> setList(String key, List<dynamic> values) async {
    try {
      final file = await _getFile(key);
      final jsonString = jsonEncode(values);
      final encryptedValue = _encryptValue(jsonString);
      await file.writeAsString(encryptedValue);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Converts the given List<dynamic> value to a JSON-encoded string, encrypts it using AES encryption,
  /// and saves it to local storage with the given key. Returns true if the operation was successful,
  /// and false otherwise.
  static Future<List<dynamic>?> getList(String key) async {
    try {
      final file = await _getFile(key);
      final contents = await file.readAsString();
      final decryptedValue = _decryptValue(contents);
      final dynamicList = jsonDecode(decryptedValue) as List<dynamic>;
      return dynamicList;
    } catch (e) {
      return null;
    }
  }

  /// Encrypts the given key using AES encryption and returns the encrypted value as a Int.
  static Uint8List _encryptInt(int value) {
    final iv = IV.fromLength(16);
    final encrypted = _encrypter.encrypt(value.toRadixString(16), iv: iv);
    return encrypted.bytes;
  }

  /// Decrypts the given key using AES encryption and returns the encrypted value as a Int.
  static int? _decryptInt(Uint8List encryptedValue) {
    final hexString =
        _encrypter.decrypt(Encrypted(encryptedValue), iv: IV.fromLength(16));
    return int.tryParse(hexString, radix: 16);
  }

  /// Converts the given int value to a ByteData object and calls setInt() to save it to local storage
  /// with the given key. Returns true if the operation was successful, and false otherwise.
  static Future<bool> setInt(String key, int value) async {
    try {
      final file = await _getFile(key);
      final encryptedValue = _encryptInt(value);
      await file.writeAsBytes(encryptedValue);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Retrieves the encrypted value associated with the given key from local storage using getString(),
  /// decrypts it using AES encryption, converts it to an int using int.parse(), and returns the int value.
  /// Returns null if the operation failed.
  static Future<int?> getInt(String key) async {
    try {
      final file = await _getFile(key);
      final contents = await file.readAsBytes();
      return _decryptInt(contents);
    } catch (e) {
      return null;
    }
  }

  /// Encrypts the given key using AES encryption and returns the encrypted value as a String.
  static String _encryptKey(String key) {
    final hmac = Hmac(sha256, _keyBytes);
    final digest = hmac.convert(utf8.encode(key));
    return base64Url.encode(digest.bytes);
  }

  /// Encrypts the given value using AES encryption and returns the encrypted value as a String.
  static String _encryptValue(String value) {
    final iv = IV.fromLength(16);
    final encrypted = _encrypter.encrypt(value, iv: iv);
    return base64Url.encode(encrypted.bytes);
  }

  static Future<bool> clear() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final dirPath = directory.path;
      final dir = Directory('$dirPath');
      final contents = dir.listSync();
      for (var fileOrDir in contents) {
        if (fileOrDir is File && fileOrDir.path.endsWith('valt_path.txt')) {
          await fileOrDir.delete();
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Decrypts the given encrypted value using AES encryption and returns the decrypted value as a String.
  static String _decryptValue(String encryptedValue) {
    final decodedValue = base64Url.decode(encryptedValue);
    final iv = IV.fromLength(16);
    final decrypted = _encrypter.decrypt(Encrypted(decodedValue), iv: iv);
    return decrypted;
  }

  /// method for delete specific key from the repsonse
  static Future<bool> delete(String key) async {
    try {
      final file = await _getFile(key);
      await file.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}
