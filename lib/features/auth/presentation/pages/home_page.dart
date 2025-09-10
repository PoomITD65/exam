import 'package:demo/features/auth/presentation/pages/calendar_page.dart';
import 'package:demo/features/auth/presentation/pages/edit_profile_page.dart';
import 'package:demo/features/auth/presentation/pages/scan_page.dart';
import 'package:demo/features/auth/presentation/pages/test_page.dart';
import 'package:demo/features/auth/presentation/pages/test_result_page.dart';
import 'package:demo/features/auth/presentation/pages/notification_page.dart';
import 'package:flutter/material.dart';
import '../../../../app/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const double _kBarHeight = 64;
  static const double _kScanSize = 48;
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: kBg,

      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              _HeaderCard(
                onBellTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const NotificationPage()),
                  );
                },
              ),
              const SizedBox(height: 12),
              const _HeroBanner(),      // ← แตะเพื่อไป CalendarPage
              const SizedBox(height: 12),
              const _StatsRow(),        // ← แตะการ์ดซ้ายเพื่อไป TestPage
              const SizedBox(height: 16),
              const _LatestExamsPanel(),// ← “ดูทั้งหมด” แตะเพื่อไป TestPage
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

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
                        onTap: () => setState(() => _tab = 0),
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

                    SizedBox(
                      width: _kScanSize + 24,
                      child: Center(
                        child: InkResponse(
                          radius: _kScanSize,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const ScanPage()),
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

                    Expanded(
                      child: _BarItem(
                        icon: Icons.calendar_month_rounded,
                        label: 'Calendar',
                        active: _tab == 2,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const CalendarPage()),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: _BarItem(
                        icon: Icons.person_rounded,
                        label: 'Profile',
                        active: _tab == 3,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const EditProfilePage()),
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

/// -------------------- Header --------------------
class _HeaderCard extends StatelessWidget {
  const _HeaderCard({this.onBellTap});
  final VoidCallback? onBellTap;

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
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onBellTap,
            child: Container(
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
          ),
        ],
      ),
    );
  }
}

/// -------------------- Hero Banner --------------------
class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () {
          // ส่งวันที่ 22 Aug 2025 ตามข้อความบนแบนเนอร์
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CalendarPage(
                initialSelected: DateTime(2025, 8, 22),
              ),
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: SizedBox(
            height: 108,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 14,
                  child: Image.asset(
                    'assets/images/cover_placeholder.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(
                      child: Icon(
                        Icons.image_rounded,
                        color: Colors.white70,
                        size: 40,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 11,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '22 AUGUST 2025',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                                letterSpacing: .2,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'กำหนดส่งข้อสอบ',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                height: 1.0,
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
      ),
    );
  }
}

/// -------------------- สถิติ --------------------
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.w700,
          height: 1.0,
        );
    final unitStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          height: 1.0,
        );

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'จำนวนชุดข้อสอบ',
            value: '5',
            unit: 'ชุด',
            labelStyle: labelStyle,
            unitStyle: unitStyle,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TestPage()),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            title: 'สถิติอื่น ๆ',
            value: '—',
            unit: '',
            labelStyle: labelStyle,
            unitStyle: unitStyle,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('สถิติอื่น ๆ (demo)')),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value, unit;
  final TextStyle? labelStyle, unitStyle;
  final VoidCallback? onTap;
  const _StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    this.labelStyle,
    this.unitStyle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: Colors.redAccent,
          fontWeight: FontWeight.w900,
          height: 1.0,
        );

    final child = Container(
      height: 82,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: labelStyle, textAlign: TextAlign.center),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: valueStyle),
              if (unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(unit, style: unitStyle),
              ],
            ],
          ),
        ],
      ),
    );

    return onTap == null
        ? child
        : Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onTap,
              child: child,
            ),
          );
  }
}

/// -------------------- ข้อสอบล่าสุด --------------------
class _LatestExamsPanel extends StatelessWidget {
  const _LatestExamsPanel();

  static const _items = <_ExamRow>[
    _ExamRow('ข้อสอบชุดที่ A', 'ปลายภาค', '18:27 – April 30'),
    _ExamRow('ข้อสอบชุดที่ B', 'แบบฝึกหัด', '18:27 – April 30'),
    _ExamRow('ข้อสอบชุดที่ C', 'กลางภาค', '18:27 – April 22'),
    _ExamRow('ข้อสอบชุดที่ D', 'กลางภาค', '18:27 – April 20'),
    _ExamRow('ข้อสอบชุดที่ E', 'แบบทดสอบ', '18:27 – April 10'),
  ];

  @override
  Widget build(BuildContext context) {
    final panelTitle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w900,
        );
    final seeAll = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        );

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF7F7F9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Column(
        children: [
          Row(
            children: [
              Text('ข้อสอบล่าสุด', style: panelTitle),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TestPage()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text('ดูทั้งหมด', style: seeAll),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            separatorBuilder: (_, __) => const Divider(height: 12, thickness: .6),
            itemBuilder: (context, i) {
              final e = _items[i];

              VoidCallback onTap;
              if (e.title == 'ข้อสอบชุดที่ A') {
                onTap = () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TestResultPage(
                        subject: 'วิชา วิทยาศาสตร์  ชั้นปี ม.1',
                        totalQuestions: 20,
                        passPercent: 60,
                      ),
                    ),
                  );
                };
              } else {
                onTap = () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('ยังไม่พร้อม: ${e.title}')),
                  );
                };
              }

              return _ExamTile(
                title: e.title,
                tag: e.tag,
                date: e.date,
                onTap: onTap,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ExamTile extends StatelessWidget {
  final String title, tag, date;
  final VoidCallback? onTap;
  const _ExamTile({
    super.key,
    required this.title,
    required this.tag,
    required this.date,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          height: 1.1,
        );
    final tagStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.black54,
          height: 1.0,
        );
    final dateStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.redAccent,
          fontWeight: FontWeight.w700,
          height: 1.0,
        );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 2.5,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: titleStyle),
                    const SizedBox(height: 2),
                    Text(tag, style: tagStyle),
                  ],
                ),
              ),
              Text(date, style: dateStyle),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExamRow {
  final String title, tag, date;
  const _ExamRow(this.title, this.tag, this.date);
}

/// -------------------- ปุ่มใน Bottom bar --------------------
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
