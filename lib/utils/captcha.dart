import 'dart:math';

class CaptchaUtil {
  int _num1 = 0;
  int _num2 = 0;

  void generate() {
    final rand = Random();
    _num1 = rand.nextInt(10) + 1;
    _num2 = rand.nextInt(10) + 1;
  }

  String getQuestion() => "$_num1 + $_num2";
  String getAnswer() => (_num1 + _num2).toString();
}
