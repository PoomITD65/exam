// lib/features/auth/presentation/pages/calendar_page.dart
import 'package:flutter/material.dart';
import '../../../../app/app_theme.dart';

// ถ้าจะลิ้งไปหน้าอื่นๆ เหมือนหน้าที่เหลือ ให้ import เหล่านี้ด้วย
import 'home_page.dart';
import 'test_page.dart';
import 'edit_profile_page.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // ---- Bottom bar config ----
  static const double _kBarHeight = 64;
  static const double _kScanSize = 48;
  int _tab = 2; // Calendar active

  // ---- State วันปัจจุบัน + อีเวนต์ตัวอย่าง ----
  DateTime _selected = DateUtils.dateOnly(DateTime.now());

  // เก็บอีเวนต์แบบ Map โดย "คีย์ต้องเป็น dateOnly" เสมอ
  final Map<DateTime, List<_Event>> _events = {
    DateUtils.dateOnly(DateTime(2025, 8, 18)): [
      const _Event(
        title: 'First meeting about a new potential design project.',
        timeRange: '11:00 - 14:00',
        imageAsset: 'assets/images/cover_placeholder.jpg',
        detail:
            'Som is the CEO of Heyopp and looking for someone who do the redesign of his product.',
      ),
    ],
    DateUtils.dateOnly(DateTime(2025, 8, 19)): [
      const _Event(
        title: 'Internal review & planning',
        timeRange: '09:30 - 10:30',
        imageAsset: 'assets/images/cover_placeholder.jpg',
        detail: 'Weekly check-in with the team, define next sprint scope.',
      ),
    ],
  };

  // -------- popup ปุ่มสแกน --------
  void _showScanPopup() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF0E1320),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: const Text(
          'กดหาพ่อง',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text('ปิด')),
        ],
      ),
    );
  }

  // ---------------- helpers ----------------
  List<_Event> get _eventsOfSelected =>
      _events[DateUtils.dateOnly(_selected)] ?? const [];

  String _formatDate(DateTime d) =>
      '${d.day} ${_monthNames[d.month]}  ${d.year}';

  static const _monthNames = [
    '',
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  String _daysLeftText(DateTime day) {
    final now = DateUtils.dateOnly(DateTime.now());
    final diff = day.difference(now).inDays;
    if (diff == 0) return 'today';
    if (diff > 0) return '$diff day${diff == 1 ? '' : 's'} left';
    final ago = diff.abs();
    return '$ago day${ago == 1 ? '' : 's'} ago';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selected,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        // ทำ theme ให้เข้มกลืนกับแอป
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: const Color(0xFF111827),
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.redAccent,
              brightness: Brightness.dark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selected = DateUtils.dateOnly(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            // -------- Header บนเหมือนในภาพ --------
            const _HeaderCard(),

            // -------- แถบเลือกวัน + ปุ่มเลื่อนซ้ายขวา --------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Row(
                children: [
                  // ปุ่มกดเปิด date picker (โชว์วัน/เดือน/ปี ปัจจุบัน)
                  Expanded(
                    child: InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _formatDate(_selected),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _RoundIconBtn(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => setState(() {
                      _selected = DateUtils.dateOnly(
                        _selected.subtract(const Duration(days: 1)),
                      );
                    }),
                  ),
                  const SizedBox(width: 6),
                  _RoundIconBtn(
                    icon: Icons.arrow_forward_ios_rounded,
                    onTap: () => setState(() {
                      _selected =
                          DateUtils.dateOnly(_selected.add(const Duration(days: 1)));
                    }),
                  ),
                ],
              ),
            ),

            // -------- ลิสต์อีเวนต์ของวันนั้น --------
            Expanded(
              child: _eventsOfSelected.isEmpty
                  ? const _EmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: _eventsOfSelected.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, i) {
                        final e = _eventsOfSelected[i];
                        return _EventCard(
                          event: e,
                          day: _selected,
                          daysLeftText: _daysLeftText(_selected),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      // -------- Bottom Navigation (เหมือนหน้าก่อน ๆ ) --------
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
                          setState(() => _tab = 1);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const TestPage()),
                          );
                        },
                      ),
                    ),
                    // ปุ่มสแกน (อยู่ในบาร์)
                    SizedBox(
                      width: _kScanSize + 24,
                      child: Center(
                        child: InkResponse(
                          radius: _kScanSize,
                          onTap: _showScanPopup,
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
                    Expanded(
                      child: _BarItem(
                        icon: Icons.calendar_month_rounded,
                        label: 'Calendar',
                        active: _tab == 2,
                        onTap: () => setState(() => _tab = 2),
                      ),
                    ),
                    Expanded(
                      child: _BarItem(
                        icon: Icons.person_rounded,
                        label: 'Profile',
                        active: _tab == 3,
                        onTap: () {
                          setState(() => _tab = 3);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfilePage(),
                            ),
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

/* ==================== Widgets ==================== */

class _HeaderCard extends StatelessWidget {
  const _HeaderCard();

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.redAccent,
          fontWeight: FontWeight.w900,
          height: 1.0,
        );
    final nameStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          height: 1.0,
        );

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(top: 6, left: 16, right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ยินดีต้อนรับ', style: titleStyle),
                const SizedBox(height: 2),
                Text('Pumipath Muangthong', style: nameStyle),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}

/// ปุ่มกลมสำหรับเลื่อนวัน (แก้ให้ใช้ไอคอนที่ส่งเข้ามา)
class _RoundIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          height: 38,
          width: 38,
          child: Icon(icon, color: Colors.black87, size: 18), // ← ใช้ icon ที่ส่งมา
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final _Event event;
  final DateTime day;
  final String daysLeftText;
  const _EventCard({
    required this.event,
    required this.day,
    required this.daysLeftText,
  });

  @override
  Widget build(BuildContext context) {
    final month = _CalendarPageState._monthNames[day.month].toUpperCase();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // การ์ดภาพซ้าย + แพเนลขวา (กำหนดความสูงคงที่ให้ซ้าย-ขวาเสมอกัน)
        SizedBox(
          height: 160,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white.withOpacity(.06),
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                // ภาพ
                Expanded(
                  flex: 11,
                  child: Image.asset(
                    event.imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.black26,
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.white70),
                      ),
                    ),
                  ),
                ),
                // แพเนลขวา (วันที่ใหญ่)
                Expanded(
                  flex: 9,
                  child: Container(
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${day.day}',
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$month ${day.year}',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                daysLeftText,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        // ชิปเวลาที่มุมขวาล่าง
                        Positioned(
                          right: 10,
                          bottom: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              event.timeRange,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        // คำอธิบาย
        Text(
          event.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          event.detail,
          style: const TextStyle(color: Colors.white70, height: 1.25),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: const [
        Icon(Icons.event_busy_rounded, color: Colors.white54, size: 40),
        SizedBox(height: 8),
        Text('ไม่มีกิจกรรมในวันนี้', style: TextStyle(color: Colors.white70)),
      ]),
    );
  }
}

class _Event {
  final String title;
  final String timeRange;
  final String imageAsset;
  final String detail;
  const _Event({
    required this.title,
    required this.timeRange,
    required this.imageAsset,
    required this.detail,
  });
}

/* -------- ปุ่มใน Bottom bar (เหมือนเดิม) -------- */
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
