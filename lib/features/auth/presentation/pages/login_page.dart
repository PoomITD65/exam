import 'package:flutter/material.dart';
import '../../../../common/widgets/text_link_button.dart';
import '../../../../app/app_theme.dart';

// เรียกหน้าที่อยู่โฟลเดอร์เดียวกันแบบตรง ๆ (ไม่พึ่ง AppRoutes)
import 'sign_up_page.dart';
import 'forgot_password_page.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController(text: 'pumipath1510@gmail.com');
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIconColor: kSubtle,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final h = c.maxHeight;

            const double sidePad      = 20;
            const double topGap       = 100;
            final  double logoSize    = (w * 0.44).clamp(130, 170).toDouble();
            const double titleToLink  = 5;
            const double linkToForm   = 10;
            const double fieldGap     = 10;
            const double formToForgot = 8;
            const double forgotToBtn  = 14;
            final  double bottomGap   = (h * 0.03).clamp(20, 32).toDouble();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: sidePad),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: h - 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: topGap),

                      // โลโก้
                      Image.asset(
                        'assets/images/logo.png',
                        height: logoSize,
                        fit: BoxFit.contain,
                      ),

                      const Text(
                        'ลงชื่อเข้าใช้บัญชี',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                      ),

                      const SizedBox(height: titleToLink),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('ยังไม่มีบัญชีใหม่? ', style: TextStyle(color: kSubtle)),
                          TextLinkButton(
                            'ลงทะเบียน',
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const SignUpPage()),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: linkToForm),
                      Form(
                        key: _form,
                        child: Column(
                          children: [
                            // อีเมล
                            Material(
                              elevation: 1.25,
                              shadowColor: Colors.black26,
                              borderRadius: BorderRadius.circular(12),
                              child: TextFormField(
                                controller: _email,
                                style: const TextStyle(color: Colors.black),
                                keyboardType: TextInputType.emailAddress,
                                decoration: _fieldDecoration('อีเมล')
                                    .copyWith(prefixIcon: const Icon(Icons.mail_outline)),
                              ),
                            ),
                            const SizedBox(height: fieldGap),

                            // รหัสผ่าน
                            Material(
                              elevation: 1.25,
                              shadowColor: Colors.black26,
                              borderRadius: BorderRadius.circular(12),
                              child: TextFormField(
                                controller: _password,
                                style: const TextStyle(color: Colors.black),
                                obscureText: _obscure,
                                decoration: _fieldDecoration('รหัสผ่าน').copyWith(
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscure ? Icons.visibility_off : Icons.visibility,
                                      color: kSubtle,
                                    ),
                                    onPressed: () => setState(() => _obscure = !_obscure),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: formToForgot),
                      Align(
                        alignment: Alignment.center,
                        child: TextLinkButton(
                          'ลืมรหัสผ่าน',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: forgotToBtn),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w800,
                              // ให้ตัวปุ่มใกล้เคียงดีไซน์
                            ),
                          ),
                          onPressed: () {
                            // สมมติผ่านตรวจสอบ แล้วพาไปหน้า Home โดยไม่ใช้ named route
                            if ((_form.currentState?.validate() ?? true) == true) {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const HomePage()),
                                (route) => false,
                              );
                            }
                          },
                          child: const Text('เข้าสู่ระบบ'),
                        ),
                      ),

                      SizedBox(height: bottomGap),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
