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

  final String subject; // หัวข้อรองใต้ชื่อหน้า
  final String studentId; // รหัสนักเรียน
  final String proofImageAsset;

  static const _red = Color(0xFFE01C1C);
  static const _card = Color(0xFF5F6368);

  @override
  Widget build(BuildContext context) {
    final bool pass = score >= passScore;
    final String proofFileName = proofImageAsset.split('/').last;
    final double ratio = (total == 0) ? 0 : (score / total).clamp(0, 1).toDouble();

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
            // ---------- ข้อมูลผู้เข้าสอบ ----------
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(icon: Icons.person_rounded, title: 'ชื่อ-นามสกุล', value: studentName),
                  const SizedBox(height: 8),
                  _InfoRow(icon: Icons.badge_rounded, title: 'รหัสนักเรียน', value: studentId),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.insert_drive_file_rounded,
                    title: 'หลักฐานการตรวจ',
                    value: proofFileName,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ---------- ภาพหลักฐาน (แตะเพื่อซูม) ----------
            _SectionCard(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      GestureDetector(
                        onTap: () => _openFullImage(context),
                        child: Image.asset(
                          proofImageAsset,
                          fit: BoxFit.contain,
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
                      // ไอคอนบอกใบ้ว่า “แตะเพื่อซูม”
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.55),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.zoom_in_rounded, size: 16, color: Colors.white),
                              SizedBox(width: 6),
                              Text('แตะเพื่อซูม', style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ---------- สรุปผล ----------
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // แถวตัวเลขใหญ่ + ชิปสถานะ
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(text: 'คะแนนที่ได้ ', style: TextStyle(color: Colors.white)),
                              TextSpan(
                                text: '$score',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                              ),
                              const TextSpan(text: ' / ', style: TextStyle(color: Colors.white)),
                              TextSpan(
                                text: '$total',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _ResultChip(pass: pass),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // แถบความคืบหน้าเปอร์เซ็นต์
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(pass ? const Color(0xFF1DB954) : _red),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // เกณฑ์/เปอร์เซ็นต์ย่อย
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'สัดส่วน ${(ratio * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        'เกณฑ์ผ่าน ${((passScore / (total == 0 ? 1 : total)) * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('ผลสอบอยู่ในเกณฑ์ : ', style: TextStyle(color: Colors.white)),
                      Text(
                        pass ? 'ผ่าน' : 'ไม่ผ่าน',
                        style: TextStyle(
                          color: pass ? const Color(0xFF1DB954) : _red,
                          fontWeight: FontWeight.w800,
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
}

/* ===================== Reusable Widgets ===================== */

/// การ์ดส่วนต่าง ๆ ให้สไตล์เดียวกัน
class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child, this.padding, this.color});
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color ?? TestDetailPage._card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

/// แถวข้อมูลหัวเรื่อง : ค่า + ไอคอนนำหน้า
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.title, required this.value});

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
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
          ),
        ),
      ],
    );
  }
}

/// ชิปสถานะผลสอบ
class _ResultChip extends StatelessWidget {
  const _ResultChip({required this.pass});
  final bool pass;

  @override
  Widget build(BuildContext context) {
    final bg = pass ? const Color(0xFF1DB954) : TestDetailPage._red;
    final text = pass ? 'ผ่าน' : 'ไม่ผ่าน';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
    );
  }
}
