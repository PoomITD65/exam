import 'package:demo/features/auth/presentation/pages/calendar_page.dart';
import 'package:flutter/material.dart';
import '../../../../app/app_theme.dart';
import '../../presentation/pages/home_page.dart';
import '../../presentation/pages/test_page.dart';
import '../../presentation/pages/edit_profile_page.dart';
// ⬇️ เพิ่ม import หน้ารายละเอียด/หลักฐาน
import '../../presentation/pages/test_detail_page.dart';

class TestResultPage extends StatefulWidget {
  const TestResultPage({
    super.key,
    this.subject = 'วิชา วิทยาศาสตร์  ชั้นปี ม.1',
    this.totalQuestions = 20,
    this.passPercent = 60, // เกณฑ์ผ่าน 60%
  });

  final String subject;
  final int totalQuestions;
  final int passPercent;

  @override
  State<TestResultPage> createState() => _TestResultPageState();
}

class _TestResultPageState extends State<TestResultPage> {
  // bottom bar config
  static const double _kBarHeight = 64;
  static const double _kScanSize = 48;
  int _tab = 1; // TEST active

  // สีตามดีไซน์
  static const _red = Color(0xFFE01C1C);

  late final int _passScore =
      ((widget.totalQuestions * widget.passPercent) / 100).round();

  // ตัวอย่างข้อมูล
  final List<_ScoreRow> _rows = const [
    _ScoreRow('Jane Cooper', 20),
    _ScoreRow('Wade Warren', 14),
    _ScoreRow('Esther Howard', 11),
    _ScoreRow('Cameron Williamson', 12),
    _ScoreRow('Brooklyn Simmons', 12),
    _ScoreRow('Leslie Alexander', 14),
    _ScoreRow('ทำดี ได้ดี', 9),
    _ScoreRow('Guy Hawkins', 14),
    _ScoreRow('Rob Fox', 10),
    _ScoreRow('Jacob Jones', 13),
    _ScoreRow('Kristin Watson', 8),
    _ScoreRow('Cody Fisher', 11),
    _ScoreRow('Savannah Nguyen', 13),
    _ScoreRow('Albert Flores', 10),
    _ScoreRow('Ralph Edwards', 14),
    _ScoreRow('Devon Lane', 12),
    _ScoreRow('Darrell Steward', 13),
    _ScoreRow('Marvin McKinney', 11),
    _ScoreRow('Eleanor Pena', 12),
    _ScoreRow('Jerome Bell', 19),
    _ScoreRow('Theresa Webb', 8),
    _ScoreRow('Arlene McCoy', 12),
    _ScoreRow('Courtney Henry', 16),
    _ScoreRow('Jenny Wilson', 10),
    _ScoreRow('Floyd Miles', 14),
    _ScoreRow('Darlene Robertson', 9),
    _ScoreRow('Kathryn Murphy', 12),
    _ScoreRow('Ronald Richards', 15),
    _ScoreRow('Cody Fisher', 10),
  ];

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: const Text(
          'ผลคะแนน',
          style: TextStyle(
            color: _red,
            fontWeight: FontWeight.w900,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(34),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Text(
              widget.subject,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ),

      // ทำให้ตารางกินพื้นที่ที่เหลือและเลื่อนภายในได้
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Column(
          children: [
            Expanded(
              child: _ScoreTable(
                subject: widget.subject,            // ⬅️ ส่งชื่อวิชาไปด้วย
                rows: _rows,
                passScore: _passScore,
                total: widget.totalQuestions,
              ),
            ),
          ],
        ),
      ),

      // ==== Bottom Navigation (ปุ่มสแกนอยู่ในบาร์) ====
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
                        active: _tab == 3,
                        onTap: () {
                          setState(() => _tab = 3);
                          Navigator.pushReplacement(
                            context,
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

/* ---------------- Table Section ---------------- */

class _ScoreTable extends StatelessWidget {
  const _ScoreTable({
    required this.subject,      // ⬅️ รับ subject ไว้ส่งต่อหน้า detail
    required this.rows,
    required this.passScore,
    required this.total,
  });

  final String subject;
  final List<_ScoreRow> rows;
  final int passScore;
  final int total;

  static const _red = Color(0xFFE01C1C);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: const Color(0xFF10151E),
        child: Column(
          children: [
            // header
            Container(
              color: _red,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: const Row(
                children: [
                  _Cell('ลำดับ', flex: 10, bold: true, center: true, color: Colors.white),
                  _Cell('รายชื่อ', flex: 40, bold: true, color: Colors.white),
                  _Cell('คะแนนที่ได้', flex: 20, bold: true, center: true, color: Colors.white),
                  _Cell('เกณฑ์', flex: 20, bold: true, center: true, color: Colors.white),
                ],
              ),
            ),

            // list (เลื่อนลงได้)
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: rows.length,
                  separatorBuilder: (_, __) =>
                      Container(height: .7, color: const Color(0xFFE9E9EE)),
                  itemBuilder: (context, i) {
                    final r = rows[i];
                    final pass = r.score >= passScore;

                    return InkWell(
                      onTap: () {
                        // ⬇️ ลิ้งไปหน้า “รายละเอียด/หลักฐาน”
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TestDetailPage(
                              studentName: r.name,
                              score: r.score,
                              total: total,
                              passScore: passScore,
                              subject: subject,
                              // proofImageAsset: 'assets/images/proof_${i+1}.png', // ถ้าจะ map รายภาพต่อคน
                            ),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: Row(
                          children: [
                            _Cell('${i + 1}', flex: 10, center: true),
                            _Cell(r.name, flex: 40),
                            _Cell('${r.score}', flex: 20, center: true),
                            _Cell(
                              pass ? 'ผ่าน' : 'ไม่ผ่าน',
                              flex: 20,
                              center: true,
                              color: pass ? Colors.black87 : Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // เกณฑ์แถบล่าง
            Container(
              color: Colors.white,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(
                'เกณฑ์  ${((passScore / total) * 100).round()} %  จากทั้งหมด $total คะแนน',
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(
    this.text, {
    super.key,
    required this.flex,
    this.center = false,
    this.bold = false,
    this.color,
  });

  final String text;
  final int flex;
  final bool center;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: color ?? Colors.black87,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      fontSize: 12,
      height: 1.0,
    );
    return Expanded(
      flex: flex,
      child: Align(
        alignment: center ? Alignment.center : Alignment.centerLeft,
        child: Text(text, style: style, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class _ScoreRow {
  final String name;
  final int score;
  const _ScoreRow(this.name, this.score);
}

/* ---------------- Bottom Bar Small Item ---------------- */

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
