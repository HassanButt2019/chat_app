import 'package:encrypt/encrypt.dart' as en;
import 'package:encrypt/encrypt.dart';


class Aes{
  static final key = en.Key.fromLength(32);
  static final iv = en.IV.fromLength(16);
  static final encrypter = en.Encrypter(en.AES(key));
  
  static encrypt(String msg){
    final encrypted = encrypter.encrypt(msg , iv:iv);
    return encrypted.base64;
  }
  
  
  static decrypt(msg){
  final decrypted = encrypter.decrypt64(msg , iv:iv);
    return decrypted;
  }


}