import 'package:sikep/utils/captcha.dart';

class AuthService {
  final CaptchaUtil _captchaUtil;

  AuthService(this._captchaUtil);

  bool validateCaptcha(String input) {
    return input == _captchaUtil.getAnswer();
  }
}
