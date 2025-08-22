import 'package:flutter/material.dart';
import 'package:sikep/screens/home.dart';
import 'package:sikep/utils/captcha.dart';
import 'package:sikep/services/auth.dart';
import 'package:sikep/screens/forgot_password.dart';

//import 'package:sikep/models/user.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _nipController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();

  final _captchaUtil = CaptchaUtil();
  late final AuthService _authService;

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _authService = AuthService(_captchaUtil);
    _captchaUtil.generate();
  }

  void _refreshCaptcha() {
    setState(() {
      _captchaUtil.generate();
      _captchaController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.07),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SIKEP',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 64),
                  ),
                  Text(
                    'Selamat Datang',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Silakan Masuk Untuk Menggunakan\nAplikasi SIKEP Mobile",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                  SizedBox(height: 28),

                  // NIP/NIK
                  TextField(
                    controller: _nipController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_rounded),
                      hintText: 'NIP Atau NIK',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Password
                  TextField(
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                      suffixIcon: GestureDetector(
                        onTap: () =>
                            setState(() => _showPassword = !_showPassword),
                        child: Container(
                          alignment: Alignment.center,
                          width: 110,
                          child: Text(
                            _showPassword ? "Sembunyikan" : "Tampilkan",
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      hintText: 'Kata Sandi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Captcha Display
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 221, 239, 233),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _captchaUtil.getQuestion(),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      SizedBox(
                        height: 58,
                        width: 58,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: Color(0xff3cbb92),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _refreshCaptcha,
                          child: Icon(Icons.refresh, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Captcha Answer
                  TextField(
                    controller: _captchaController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Masukan Hasil Penjumlahan Diatas',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Tombol Masuk
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff3cbb92),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        final identifier = _nipController.text.trim();
                        final password = _passwordController.text.trim();

                        if (!_authService.validateCaptcha(
                          _captchaController.text,
                        )) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Captcha tidak sesuai, silakan coba lagi',
                              ),
                            ),
                          );
                          return;
                        }

                        _authService.login(identifier, password).then((user) {
                          if (user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(user: user),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Login gagal: NIP/NIK atau Password salah',
                                ),
                              ),
                            );
                          }
                        });
                      },

                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 18),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: Text(
                        "Lupa Password ?",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      'Copyright @ 2025',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
