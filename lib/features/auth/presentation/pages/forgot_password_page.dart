import 'package:flutter/material.dart';
import '../../../../app/app_theme.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'กรอกอีเมล';
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim());
    return ok ? null : 'อีเมลไม่ถูกต้อง';
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // เว้นระยะหัวข้อกับพาเนลแบบสัดส่วน (ยิ่งมากยิ่ง “ต่ำ”)
    const double panelTopPercent = 0.15;
    // ขยายพื้นสีน้ำเงิน “ขึ้นบน” โดยไม่เลื่อนเนื้อหา
    const double expandBlueUp = 22;
    // padding ด้านบนภายในพาเนล เพื่อดันเนื้อหาลงเท่าที่ขยายขึ้น
    const double innerTopPad = 18 + expandBlueUp; // ✅ const เพื่อลด lint

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
        left: false,
        right: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // คำนวณช่องว่างเหนือพาเนล
            final double baseGap = (constraints.maxHeight * panelTopPercent)
                .clamp(12.0, 140.0)
                .toDouble();
            final double gapTop =
                (baseGap - expandBlueUp).clamp(0.0, 140.0).toDouble();

            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'ลืมรหัสผ่าน',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(height: gapTop),

                // พื้นสีน้ำเงิน: ชิดขอบซ้าย-ขวา, โค้งเฉพาะด้านบน
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: kAccent,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(36)),
                    ),
                    child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.fromLTRB(20, innerTopPad, 20, 28),
                      child: Form(
                        key: _form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'รีเซ็ตรหัสผ่าน?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'บอกอีเมลให้เราเถิด แล้วกดปุ่มด้านล่าง\n'
                              'เพื่อรับลิงก์ตั้งรหัสผ่านใหม่กลับเข้าสู่บัญชีอีกครั้ง',
                              style:
                                  TextStyle(color: Colors.white70, height: 1.4),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'กรอกที่อยู่อีเมล',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.black),
                              validator: _validateEmail,
                              decoration: InputDecoration(
                                hintText: 'example@example.com',
                                hintStyle:
                                    const TextStyle(color: Color(0xFF9AA0A6)),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(28),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size.fromHeight(44),
                                    shape: const StadiumBorder(),
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w900),
                                  ),
                                  onPressed: () {
                                    if (_form.currentState?.validate() ==
                                        true) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'ส่งลิงก์รีเซ็ตรหัสผ่านแล้ว (ตัวอย่าง)'),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('ยืนยัน'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
