import 'package:flutter/material.dart';
import '../../../../app/app_theme.dart';

class TestDetailPage extends StatelessWidget {
  const TestDetailPage({
    super.key,
    required this.studentName,
    required this.score,
    required this.total,
    required this.passScore,
    this.subject = 'ผลคะแนนจากข้อสอบ',
    this.studentId = 'XXXX',
    this.proofImageAsset = 'assets/images/proof_sample.png', // รูปหลักฐานเริ่มต้น
  });

  final String studentName;
  final int score;
  final int total;
  final int passScore;

  final String subject;        // หัวข้อรองใต้ชื่อหน้า
  final String studentId;      // รหัสนักเรียน
  final String proofImageAsset;

  static const _red = Color(0xFFE01C1C);

  @override
  Widget build(BuildContext context) {
    final bool pass = score >= passScore;
    final String proofFileName = proofImageAsset.split('/').last; // ชื่อไฟล์ภาพ

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
          'รายละเอียด',
          style: TextStyle(
            color: _red,
            fontWeight: FontWeight.w900,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Center(
              child: Text(
                subject,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          children: [
            // กล่องข้อมูลผู้เข้าสอบ
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF5F6368), // เทาแบบในภาพ
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow('ชื่อ-นามสกุล', studentName),
                  const SizedBox(height: 6),
                  _InfoRow('รหัสนักเรียน', studentId),
                  const SizedBox(height: 6),
                  _InfoRow('หลักฐานการตรวจ', proofFileName),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ภาพหลักฐาน (OMR/ใบตรวจ) — กดเพื่อดูเต็มจอ
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: GestureDetector(
                    onTap: () => _openFullImage(context),
                    child: Image.asset(
                      proofImageAsset,
                      fit: BoxFit.contain, // ไม่ครอปภาพ
                      filterQuality: FilterQuality.high,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.white,
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 48,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // สรุปผล
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF5F6368),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _scoreSummary(score, total),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Text('ผลสอบอยู่ในเกณฑ์ : ', style: TextStyle(color: Colors.white)),
                      Text(
                        pass ? 'ผ่าน' : 'ไม่ผ่าน',
                        style: TextStyle(
                          color: pass ? const Color(0xFF1DB954) : Colors.redAccent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ดูภาพเต็มจอแบบซูมได้
  void _openFullImage(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.9),
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  maxScale: 5,
                  child: Image.asset(
                    proofImageAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.white54,
                      size: 80,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// บรรทัดสรุปคะแนน: "คะแนนที่ได้ X คะแนนจากทั้งหมด Y"
  static Widget _scoreSummary(int score, int total) {
    const base = TextStyle(color: Colors.white);
    const bold = TextStyle(color: Colors.white, fontWeight: FontWeight.w900);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text('คะแนนที่ได้ ', style: base),
        Text('$score', style: bold),
        const Text(' คะแนนจากทั้งหมด ', style: base),
        Text('$total', style: bold),
      ],
    );
  }
}

/// แถวข้อมูลหัวเรื่อง : ค่า
class _InfoRow extends StatelessWidget {
  const _InfoRow(this.title, this.value, {super.key});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.white),
        children: [
          TextSpan(
            text: '$title :  ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
