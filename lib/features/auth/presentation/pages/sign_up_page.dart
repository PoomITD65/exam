import 'package:flutter/material.dart';
// ลบ: import '../../../../common/widgets/app_logo.dart';
import '../../../../common/widgets/text_link_button.dart';
import '../../../../app/app_theme.dart';
import '../../../../app/app_routes.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'กรอกอีเมล';
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim());
    return ok ? null : 'รูปแบบอีเมลไม่ถูกต้อง';
  }

  String? _validateNotEmpty(String? v, String label) =>
      (v == null || v.trim().isEmpty) ? 'กรอก$label' : null;

  String? _validatePhone(String? v) {
    final s = (v ?? '').replaceAll(RegExp(r'\s|-'), '');
    return s.length >= 8 ? null : 'กรอกเบอร์โทรให้ถูกต้อง';
  }

  String? _validatePassword(String? v) =>
      (v == null || v.length < 6) ? 'รหัสผ่านอย่างน้อย 6 ตัวอักษร' : null;

  // ฟิลด์พื้นขาว ตัวอักษรดำ
  InputDecoration _fieldDecoration(String hint, IconData icon) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black45),
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: kSubtle),
      );

  static const TextStyle _fieldTextStyle = TextStyle(color: Colors.black87);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final h = c.maxHeight;

            const sidePad = 20.0;
            const topGap = 36.0;
            final double logoSize = (w * 0.50).clamp(140, 190).toDouble(); // ← ขนาดโลโก้ (ปรับได้)
            const titleToLink = 4.0;
            const linkToForm = 12.0;
            const fieldGap = 10.0;
            const formToButton = 16.0;
            final bottomGap = (h * 0.03).clamp(20.0, 32.0);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: sidePad),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: h - 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: topGap),

                      // ✅ โลโก้แบบเรียกตรง ๆ
                      Image.asset(
                        'assets/images/logo.png',
                        height: logoSize,
                        fit: BoxFit.contain,
                      ),

                      const Text(
                        'สร้างบัญชีผู้ใช้',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                        ),
                      ),

                      const SizedBox(height: titleToLink),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('มีบัญชีอยู่แล้ว? ', style: TextStyle(color: kSubtle)),
                          TextLinkButton(
                            'เข้าสู่ระบบ',
                            onTap: () => Navigator.popUntil(
                              context,
                              ModalRoute.withName(AppRoutes.login),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: linkToForm),

                      // ฟอร์ม (พื้นขาว/ตัวอักษรดำ)
                      Form(
                        key: _form,
                        child: Column(
                          children: [
                            Material(
                              color: Colors.transparent,
                              elevation: 1.1,
                              shadowColor: Colors.black26,
                              borderRadius: BorderRadius.circular(12),
                              child: TextFormField(
                                controller: _name,
                                textCapitalization: TextCapitalization.words,
                                style: _fieldTextStyle,
                                cursorColor: Colors.black,
                                decoration: _fieldDecoration('ชื่อ-นามสกุล', Icons.person_outline),
                                validator: (v) => _validateNotEmpty(v, 'ชื่อ-นามสกุล'),
                              ),
                            ),
                            const SizedBox(height: fieldGap),

                            Material(
                              color: Colors.transparent,
                              elevation: 1.1,
                              shadowColor: Colors.black26,
                              borderRadius: BorderRadius.circular(12),
                              child: TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                style: _fieldTextStyle,
                                cursorColor: Colors.black,
                                decoration: _fieldDecoration('อีเมล', Icons.mail_outline),
                                validator: _validateEmail,
                              ),
                            ),
                            const SizedBox(height: fieldGap),

                            Material(
                              color: Colors.transparent,
                              elevation: 1.1,
                              shadowColor: Colors.black26,
                              borderRadius: BorderRadius.circular(12),
                              child: TextFormField(
                                controller: _phone,
                                keyboardType: TextInputType.phone,
                                style: _fieldTextStyle,
                                cursorColor: Colors.black,
                                decoration: _fieldDecoration('เบอร์โทร', Icons.phone_outlined),
                                validator: _validatePhone,
                              ),
                            ),
                            const SizedBox(height: fieldGap),

                            Material(
                              color: Colors.transparent,
                              elevation: 1.1,
                              shadowColor: Colors.black26,
                              borderRadius: BorderRadius.circular(12),
                              child: TextFormField(
                                controller: _password,
                                obscureText: _obscure,
                                style: _fieldTextStyle,
                                cursorColor: Colors.black,
                                decoration: _fieldDecoration('รหัสผ่าน', Icons.lock_outline).copyWith(
                                  suffixIcon: IconButton(
                                    onPressed: () => setState(() => _obscure = !_obscure),
                                    icon: Icon(
                                      _obscure ? Icons.visibility_off : Icons.visibility,
                                      color: kSubtle,
                                    ),
                                  ),
                                ),
                                validator: _validatePassword,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: formToButton),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          onPressed: () {
                            if (_form.currentState?.validate() == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('สมัครสมาชิกสำเร็จ (ตัวอย่าง)')),
                              );
                              Navigator.popUntil(context, ModalRoute.withName(AppRoutes.login));
                            }
                          },
                          child: const Text('ลงทะเบียน'),
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
