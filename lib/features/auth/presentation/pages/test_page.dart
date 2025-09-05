import 'package:demo/features/auth/presentation/pages/calendar_page.dart';
import 'package:demo/features/auth/presentation/pages/edit_profile_page.dart';
import 'package:demo/features/auth/presentation/pages/home_page.dart';

import 'package:flutter/material.dart';
import '../../../../app/app_theme.dart';

// ⬇️ เพิ่ม import หน้าแสดงผลคะแนน (ปรับ path ให้ตรงโปรเจ็กต์ถ้าจำเป็น)
import 'test_result_page.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // ตั้งค่าให้แท็บ Test เป็น active ตอนเริ่มต้น
  int _tab = 1;

  // ขนาดแถบล่าง/ปุ่มสแกน ให้ตรงกับหน้า Home
  static const double _kBarHeight = 64;
  static const double _kScanSize  = 48;

  // ตัวอย่างข้อมูล
  static const _items = [
    _TestItem(code: 'A', subject: 'วิชา วิทยาศาสตร์  ชั้นปี ม. 1', total: 20, pass: 60),
    _TestItem(code: 'B', subject: 'วิชา คณิตศาสตร์  ชั้นปี ม. 2', total: 20, pass: 60),
    _TestItem(code: 'C', subject: 'วิชา ภาษาไทย  ชั้นปี ม. 1', total: 20, pass: 60),
    _TestItem(code: 'D', subject: 'วิชา สังคมศึกษา  ชั้นปี ม. 3', total: 20, pass: 60),
    _TestItem(code: 'E', subject: 'วิชา อังกฤษ  ชั้นปี ม. 2',   total: 20, pass: 60),
  ];

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: kBg,

      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 12),
              decoration: const BoxDecoration(
                color: Color(0xFF141A26),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'ข้อสอบทั้งหมด',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('เพิ่มข้อสอบใหม่ (demo)')),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) {
                  final t = _items[i];
                  return _TestCard(
                    item: t,
                    onTap: () {
                      // ⬇️ เปลี่ยนเฉพาะชุด A ให้ไปหน้าแสดงผลคะแนน
                      if (t.code == 'A') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TestResultPage(
                              subject: t.subject,
                              totalQuestions: t.total,
                              passPercent: t.pass,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('เปิดข้อสอบชุดที่ ${t.code} (demo)')),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ------- Bottom Navigation แบบเดียวกับหน้า Home -------
      
      // Bottom bar โค้งบน + ปุ่มสแกนอยู่ "ในบาร์" ตำแหน่งคงที่เสมอ
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
                    Expanded(
                      child: _BarItem(
                        icon: Icons.home_rounded,
                        label: 'Home',
                        active: _tab == 0,
                        onTap: () {
                          setState(() => _tab = 0);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const HomePage()),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: _BarItem(
                        icon: Icons.assignment_rounded,
                        label: 'Test',
                        active: _tab == 1,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const TestPage()),
                          );
                        },
                      ),
                    ),

                    // ปุ่มสแกน (อยู่ในบาร์ ไม่ลอย)
                    SizedBox(
                      width: _kScanSize + 24, // เผื่อขอบซ้าย-ขวา
                      child: Center(
                        child: InkResponse(
                          radius: _kScanSize,
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

                    // ขวา 2 ปุ่ม
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
                    Expanded(
                      child: _BarItem(
                        icon: Icons.person_rounded,
                        label: 'Profile',
                        active:
                            _tab == 3, // จะคงไว้หรือจะเปลี่ยนเป็น false ก็ได้
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const EditProfilePage()),
                          );
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

// ----------------- Card + Model -----------------
class _TestCard extends StatelessWidget {
  final _TestItem item;
  final VoidCallback onTap;
  const _TestCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black87, width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.description_outlined, size: 28, color: Colors.black87),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ข้อสอบชุดที่ ${item.code}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14.5,
                          color: Colors.black,
                          height: 1.1,
                        )),
                    const SizedBox(height: 4),
                    Text(item.subject, style: const TextStyle(color: Colors.black87, fontSize: 12.5)),
                    Text('จำนวน ${item.total} ข้อ', style: const TextStyle(color: Colors.black87, fontSize: 12.5)),
                    Text('เกณฑ์  ${item.pass} %  จากทั้งหมด',
                        style: const TextStyle(color: Colors.black87, fontSize: 12.5)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestItem {
  final String code;
  final String subject;
  final int total;
  final int pass;
  const _TestItem({
    required this.code,
    required this.subject,
    required this.total,
    required this.pass,
  });
}

// ----------------- ปุ่มใน Bottom bar -----------------
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
    final color = active ? Colors.white : Colors.white70;
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
