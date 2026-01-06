import 'package:encrypt/encrypt.dart';

class EncryptionService {
  static final _key = Key.fromUtf8('my32lengthsupersecretnooneknows!'); // 32 chars = 256 bits
  static final _iv = IV.fromUtf8('16charsforiv123'); // 16 chars = 128 bits

  static String encrypt(String plainText) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return plainText;
  }

  static String decrypt(String encryptedText) {
    try {
      final encrypter = Encrypter(AES(_key, mode: AESMode.cbc));
      // return encrypter.decrypt(encryptedText, iv: _iv);
      return encryptedText;
    } catch (e) {
      print('❌ Decryption failed: $e');
      return '[decryption_error]';
    }
  }
}
