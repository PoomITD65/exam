import 'package:demo/features/auth/presentation/pages/calendar_page.dart';
import 'package:flutter/material.dart';
import '../../../../app/app_theme.dart';

// ⬇️ ปรับ path ให้ตรงโปรเจกต์ของคุณ
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/pages/home_page.dart';
import '../../../auth/presentation/pages/test_page.dart';


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // ===== Bottom bar config =====
  static const double _kBarHeight = 64; // ความสูงแถบล่าง
  static const double _kScanSize  = 48; // เส้นผ่านศูนย์กลางปุ่มสแกน
  final int _tab = 3; // โปรไฟล์ = active

  // ===== ฟอร์ม =====
  final _name  = TextEditingController(text: 'Pumipath Muangthong');
  final _phone = TextEditingController(text: 'XXX-XXX-XXXX');
  final _email = TextEditingController(text: 'example@example.com');
  bool _noti = true;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  // สีหลักตามภาพ
  static const _red    = Color(0xFFE01C1C); // พื้นหลังการ์ดแดง
  static const _green  = Color(0xFF2ECC71); // ปุ่มอัปเดต
  static const _fieldBg = Colors.black;     // พื้น TextField ดำ
  static const _fieldFg = Colors.white;     // ตัวอักษรใน TextField

  InputDecoration _field(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: _fieldBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(), // ⬅️ กลับหน้าก่อนเข้า
        ),
        title: const Text(
          'Edit My Profile',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          children: [
            // การ์ดแดง + Avatar ซ้อนด้านบน
            Stack(
              alignment: Alignment.topCenter,
              children: [
                // การ์ดแดง
                Container(
                  margin: const EdgeInsets.only(top: 48),
                  padding: const EdgeInsets.fromLTRB(18, 70, 18, 18),
                  decoration: BoxDecoration(
                    color: _red,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ชื่อ / ID
                      const Center(
                        child: Column(
                          children: [
                            Text(
                              'Pumipath Muangthong',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                height: 1.1,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'ID: 25030024',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'ตั้งค่าบัญชีผู้ใช้',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),

                      const Text('ชื่อผู้ใช้',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _name,
                        style: const TextStyle(color: _fieldFg),
                        decoration: _field('ชื่อผู้ใช้'),
                      ),
                      const SizedBox(height: 14),

                      const Text('โทรศัพท์',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: _fieldFg),
                        decoration: _field('XXX-XXX-XXXX'),
                      ),
                      const SizedBox(height: 14),

                      const Text('ที่อยู่อีเมล',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: _fieldFg),
                        decoration: _field('example@example.com'),
                      ),
                      const SizedBox(height: 14),

                      // การแจ้งเตือน
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'การแจ้งเตือน',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Switch(
                            value: _noti,
                            onChanged: (v) => setState(() => _noti = v),
                            activeColor: Colors.white,
                            activeTrackColor: Colors.white54,
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.white24,
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // ปุ่มอัปเดตโปรไฟล์ ➜ ไปหน้า Home
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            textStyle: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const HomePage()),
                            );
                          },
                          child: const Text('อัปเดตโปรไฟล์'),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // ปุ่มออกจากระบบ ➜ ไปหน้า Login (ล้างสแตก)
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                            ),
                            textStyle: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const LoginPage()),
                              (route) => false,
                            );
                          },
                          child: const Text('ออกจากระบบ'),
                        ),
                      ),
                    ],
                  ),
                ),

                // Avatar กลม + ไอคอนกล้อง
                const SizedBox(
                  height: 96,
                  width: 96,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.black26,
                          child: Icon(Icons.person, size: 48, color: Colors.white),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: _CameraDot(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      // =================== Bottom Navigation (แท็บ Profile) ===================
      bottomNavigationBar: keyboardOpen
          ? const SizedBox.shrink()
          : SafeArea(
              top: false,
              child: Container(
                height: _kBarHeight,
                decoration: const BoxDecoration(
                  color: Color(0xFF0E1320),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Home
                    Expanded(
                      child: _BarItem(
                        icon: Icons.home_rounded,
                        label: 'Home',
                        active: _tab == 0,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        },
                      ),
                    ),
                    // Test
                    Expanded(
                      child: _BarItem(
                        icon: Icons.assignment_rounded,
                        label: 'Test',
                        active: _tab == 1,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const TestPage()),
                          );
                        },
                      ),
                    ),

                    // Scan (อยู่ในบาร์ ไม่ล้น)
                    SizedBox(
                      width: _kScanSize + 24,
                      child: Center(
                        child: InkResponse(
                          radius: _kScanSize,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('กดหาพ่อง')),
                            );
                          },
                          child: Container(
                            width: _kScanSize,
                            height: _kScanSize,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.qr_code_scanner_rounded,
                              color: Color(0xFF0E1320),
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Calendar
                    Expanded(
                      child: _BarItem(
                        icon: Icons.calendar_month_rounded,
                        label: 'Calendar',
                        active: _tab == 2,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const CalendarPage()),
                          );
                        },
                      ),
                    ),
                    // Profile (หน้านี้)
                    Expanded(
                      child: _BarItem(
                        icon: Icons.person_rounded,
                        label: 'Profile',
                        active: _tab == 3,
                        onTap: () {
                          // อยู่หน้าเดิม ไม่ต้องทำอะไร
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// จุดกล้องเล็ก ๆ บน Avatar
class _CameraDot extends StatelessWidget {
  const _CameraDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 28,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.photo_camera, size: 16, color: Colors.black87),
    );
  }
}

// ปุ่มย่อยใน bottom bar
class _BarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _BarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color  = active ? Colors.white : Colors.white70;
    final weight = active ? FontWeight.w700 : FontWeight.w500;

    return InkWell(
      onTap: onTap,
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color, fontSize: 12, fontWeight: weight),
            ),
          ],
        ),
      ),
    );
  }
}
