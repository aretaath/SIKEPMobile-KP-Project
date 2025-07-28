import 'package:sikep/utils/captcha.dart';
import 'package:sikep/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final CaptchaUtil _captchaUtil;

  AuthService(this._captchaUtil);

  bool validateCaptcha(String input) {
    return input == _captchaUtil.getAnswer();
  }

  Future<UserModel?> login(String identifier, String password) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('nip', isEqualTo: identifier)
          .get();

      if (snapshot.docs.isEmpty) {
        final nikSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('nik', isEqualTo: identifier)
            .get();

        if (nikSnapshot.docs.isEmpty) return null;
        final data = nikSnapshot.docs.first.data();
        if (data['password'] == password) {
          return UserModel.fromMap(data);
        } else {
          return null;
        }
      } else {
        final data = snapshot.docs.first.data();
        if (data['password'] == password) {
          return UserModel.fromMap(data);
        } else {
          return null;
        }
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }
}
