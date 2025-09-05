import 'package:flutter/material.dart';
import '../../../../app/app_theme.dart';

// นำไปลิ้งหน้าอื่นจากแถบล่างตามโปรเจ็กต์คุณ
import 'home_page.dart';
import 'test_page.dart';
import 'calendar_page.dart';
import 'edit_profile_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // bottom bar
  static const double _kBarHeight = 64;
  static const double _kScanSize = 48;
  int _tab = 0;

  // mock data: แจ้งเตือนเกี่ยวกับ “การตรวจข้อสอบ”
  final List<_Noti> _today = const [
    _Noti(
      title: 'เตรียมตรวจข้อสอบ!',
      message: 'มีคำตอบส่งมาจากห้อง ม.1 รอผลตรวจ',
      time: '17:00 – April 24',
      icon: Icons.notifications_active_outlined,
    ),
    _Noti(
      title: 'อัปโหลดข้อสอบชุด A',
      message: 'ไฟล์คำตอบถูกอัปโหลดแล้ว พร้อมตรวจ',
      time: '16:20 – April 24',
      icon: Icons.upload_file_rounded,
    ),
  ];

  final List<_Noti> _earlier = const [
    _Noti(
      title: 'ผลตรวจชุด A เสร็จแล้ว',
      message: 'เฉลี่ย 62% | ผ่าน 22 / ไม่ผ่าน 8',
      time: '14:05 – April 23',
      icon: Icons.fact_check_rounded,
    ),
    _Noti(
      title: 'เตือนกำหนดส่งข้อสอบ',
      message: 'ครบกำหนด 22 AUG 2025',
      time: '09:30 – April 23',
      icon: Icons.calendar_month_rounded,
    ),
    _Noti(
      title: 'Remind: ตรวจซ้ำ 3 ใบ',
      message: 'พบความคลาดเคลื่อนเล็กน้อยจากการสแกน',
      time: '08:10 – April 23',
      icon: Icons.warning_amber_rounded,
    ),
  ];

  void _scanPopup() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('กดหาพ่อง')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'การแจ้งเตือน',
          style: TextStyle(
            color: Color(0xFFE01C1C),
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_active_rounded, color: Colors.redAccent),
          )
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE01C1C),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(48), // โค้งขวาบนตามภาพ
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // วันนี้
              const _SectionHeader('วันนี้'),
              const SizedBox(height: 6),
              ..._today.map((e) => _NotiTile(n: e)).toList(),
              const SizedBox(height: 10),

              // เส้นแบ่งเบา ๆ
              Container(height: 1, color: Colors.white24),
              const SizedBox(height: 10),

              // เมื่อวาน
              const _SectionHeader('เมื่อวาน'),
              const SizedBox(height: 6),
              ..._earlier.map((e) => _NotiTile(n: e)).toList(),
            ],
          ),
        ),
      ),

      // bottom bar
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: _kBarHeight,
          decoration: const BoxDecoration(
            color: Color(0xFF0E1320),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, -4))],
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
                  },
                ),
              ),
              Expanded(
                child: _BarItem(
                  icon: Icons.assignment_rounded,
                  label: 'TEST',
                  active: _tab == 1,
                  onTap: () {
                    setState(() => _tab = 1);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const TestPage()));
                  },
                ),
              ),
              SizedBox(
                width: _kScanSize + 24,
                child: Center(
                  child: InkResponse(
                    radius: _kScanSize,
                    onTap: _scanPopup,
                    child: Container(
                      width: _kScanSize,
                      height: _kScanSize,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
                      ),
                      child: const Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF0E1320), size: 26),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _BarItem(
                  icon: Icons.calendar_month_rounded,
                  label: 'Calendar',
                  active: _tab == 2,
                  onTap: () {
                    setState(() => _tab = 2);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CalendarPage()));
                  },
                ),
              ),
              Expanded(
                child: _BarItem(
                  icon: Icons.person_rounded,
                  label: 'Profile',
                  active: _tab == 3,
                  onTap: () {
                    setState(() => _tab = 3);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const EditProfilePage()));
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

/* ---------- UI helpers ---------- */

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w900,
        fontSize: 16,
      ),
    );
  }
}

class _NotiTile extends StatelessWidget {
  final _Noti n;
  const _NotiTile({required this.n});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFCA1616), // แดงเข้มลงเล็กน้อยให้ contrast
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Icon(n.icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    )),
                const SizedBox(height: 2),
                Text(n.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, height: 1.1)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(n.time,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
        ],
      ),
    );
  }
}

class _Noti {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  const _Noti({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
  });
}

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
