// lib/features/auth/presentation/pages/calendar_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
        imagePath: 'assets/images/cover_placeholder.jpg',
        detail:
            'Som is the CEO of Heyopp and looking for someone who do the redesign of his product.',
      ),
    ],
    DateUtils.dateOnly(DateTime(2025, 8, 19)): [
      const _Event(
        title: 'Internal review & planning',
        timeRange: '09:30 - 10:30',
        imagePath: 'assets/images/cover_placeholder.jpg',
        detail: 'Weekly check-in with the team, define next sprint scope.',
      ),
    ],
    DateUtils.dateOnly(DateTime(2025, 8, 22)): [
      const _Event(
        title: 'Internal review & planning',
        timeRange: '09:30 - 10:30',
        imagePath: 'assets/images/cover_placeholder.jpg',
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

  // === แปลง/ตรวจเวลา & ตรวจชนกัน ===
  int _toMin(TimeOfDay t) => t.hour * 60 + t.minute;

  (TimeOfDay?, TimeOfDay?) _parseTimeRange(String range) {
    try {
      final parts = range.split('-');
      if (parts.length != 2) return (null, null);
      TimeOfDay toTime(String s) {
        final t = s.trim();
        final hhmm = t.split(':');
        return TimeOfDay(hour: int.parse(hhmm[0]), minute: int.parse(hhmm[1]));
      }
      return (toTime(parts[0]), toTime(parts[1]));
    } catch (_) {
      return (null, null);
    }
  }

  bool _hasOverlap(
    DateTime day,
    TimeOfDay start,
    TimeOfDay end, {
    int? ignoreIndex,
  }) {
    final key = DateUtils.dateOnly(day);
    final list = _events[key] ?? const <_Event>[];
    final s1 = _toMin(start);
    final e1 = _toMin(end);
    for (var i = 0; i < list.length; i++) {
      if (ignoreIndex != null && DateUtils.isSameDay(day, _selected) && i == ignoreIndex) {
        continue; // ข้ามตัวที่กำลังแก้บนวันเดิม
      }
      final (st, en) = _parseTimeRange(list[i].timeRange);
      if (st == null || en == null) continue;
      final s2 = _toMin(st);
      final e2 = _toMin(en);
      // ทับซ้อนถ้า s1 < e2 และ s2 < e1
      if (s1 < e2 && s2 < e1) return true;
    }
    return false;
  }

  int _compareEventByStart(_Event a, _Event b) {
    final (sa, _) = _parseTimeRange(a.timeRange);
    final (sb, _) = _parseTimeRange(b.timeRange);
    final ma = sa == null ? 1 << 30 : _toMin(sa);
    final mb = sb == null ? 1 << 30 : _toMin(sb);
    return ma.compareTo(mb);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selected,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        // ทำ theme ให้เข้มกลืนกับแอป (หลบ deprecated)
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme:
                const DialogThemeData(backgroundColor: Color(0xFF111827)),
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

  // ---------- เพิ่มกิจกรรม (รองรับแนบรูป) ----------
  Future<void> _addEventSheet() async {
    final titleCtrl = TextEditingController();
    final detailCtrl = TextEditingController();
    TimeOfDay? start;
    TimeOfDay? end;
    XFile? pickedImage;

    String fmt(TimeOfDay t) {
      final h = t.hour.toString().padLeft(2, '0');
      final m = t.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }

    Future<TimeOfDay?> pick(TimeOfDay init) async {
      return showTimePicker(
        context: context,
        initialTime: init,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: const TimePickerThemeData(
                dialBackgroundColor: Color(0xFF111827),
                dayPeriodColor: Color(0xFF111827),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.redAccent,
                brightness: Brightness.dark,
              ),
            ),
            child: child!,
          );
        },
      );
    }

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 12,
          ),
          child: StatefulBuilder(
            builder: (context, setS) {
              Future<void> _pickFromGallery() async {
                final x = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (x != null) setS(() => pickedImage = x);
              }

              Future<void> _pickFromCamera() async {
                final x = await ImagePicker().pickImage(source: ImageSource.camera);
                if (x != null) setS(() => pickedImage = x);
              }

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('เพิ่มกิจกรรมในปฏิทิน',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        )),
                    const SizedBox(height: 12),
                    // Title
                    TextField(
                      controller: titleCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: _fieldDeco('หัวข้อกิจกรรม'),
                    ),
                    const SizedBox(height: 10),
                    // Time range row
                    Row(
                      children: [
                        Expanded(
                          child: _PickButton(
                            label: 'เริ่ม',
                            value: start == null ? '--:--' : fmt(start!),
                            onTap: () async {
                              final init = start ?? const TimeOfDay(hour: 9, minute: 0);
                              final t = await pick(init);
                              if (t != null) setS(() => start = t);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _PickButton(
                            label: 'สิ้นสุด',
                            value: end == null ? '--:--' : fmt(end!),
                            onTap: () async {
                              final init = end ?? const TimeOfDay(hour: 10, minute: 0);
                              final t = await pick(init);
                              if (t != null) setS(() => end = t);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Detail
                    TextField(
                      controller: detailCtrl,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: _fieldDeco('รายละเอียด (ไม่บังคับ)'),
                    ),
                    const SizedBox(height: 12),
                    // แนบรูป: แกลเลอรี + กล้อง + พรีวิว
                    Row(
                      children: [
                        _IconSquareBtn(
                          icon: Icons.photo_library_rounded,
                          onTap: _pickFromGallery,
                        ),
                        const SizedBox(width: 8),
                        _IconSquareBtn(
                          icon: Icons.photo_camera_rounded,
                          onTap: _pickFromCamera,
                        ),
                        const SizedBox(width: 10),
                        if (pickedImage != null)
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white24),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.file(
                              File(pickedImage!.path),
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.broken_image_rounded,
                                color: Colors.white54,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        onPressed: () {
                          final title = titleCtrl.text.trim();
                          if (title.isEmpty || start == null || end == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('กรอกหัวข้อ และเลือกเวลาเริ่ม–สิ้นสุด')),
                            );
                            return;
                          }
                          if (_toMin(start!) >= _toMin(end!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('ช่วงเวลาไม่ถูกต้อง (เวลาเริ่มต้องน้อยกว่าเวลาสิ้นสุด)')),
                            );
                            return;
                          }
                          final key = DateUtils.dateOnly(_selected);
                          if (_hasOverlap(key, start!, end!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('ช่วงเวลาชนกับกิจกรรมอื่นในวันเดียวกัน')),
                            );
                            return;
                          }

                          final timeRange = '${fmt(start!)} - ${fmt(end!)}';
                          final list = _events.putIfAbsent(key, () => []);
                          list.add(_Event(
                            title: title,
                            timeRange: timeRange,
                            imagePath: pickedImage?.path ?? 'assets/images/cover_placeholder.jpg',
                            detail: detailCtrl.text.trim(),
                          ));
                          Navigator.pop(context, true);
                        },
                        child: const Text('บันทึกกิจกรรม'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (saved == true && mounted) {
      // จัดเรียงตามเวลา
      final key = DateUtils.dateOnly(_selected);
      _events[key]?.sort(_compareEventByStart);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เพิ่มกิจกรรมแล้ว')),
      );
    }
  }

  // ---------- แก้ไข/ลบ/ย้ายวัน ของกิจกรรม ----------
  Future<void> _editEventSheet(int index) async {
    final keyOld = DateUtils.dateOnly(_selected);
    final listOld = _events[keyOld]!;
    final cur = listOld[index];

    final titleCtrl = TextEditingController(text: cur.title);
    final detailCtrl = TextEditingController(text: cur.detail);
    final times = _parseTimeRange(cur.timeRange);
    TimeOfDay? start = times.$1;
    TimeOfDay? end = times.$2;
    String imagePath = cur.imagePath;
    DateTime targetDate = keyOld;

    String fmt(TimeOfDay t) {
      final h = t.hour.toString().padLeft(2, '0');
      final m = t.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }

    Future<TimeOfDay?> pick(TimeOfDay init) async {
      return showTimePicker(
        context: context,
        initialTime: init,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: const TimePickerThemeData(
                dialBackgroundColor: Color(0xFF111827),
                dayPeriodColor: Color(0xFF111827),
              ),
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.redAccent,
                brightness: Brightness.dark,
              ),
            ),
            child: child!,
          );
        },
      );
    }

    final saved = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16, right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 12,
          ),
          child: StatefulBuilder(
            builder: (context, setS) {
              Future<void> _pickFromGallery() async {
                final x = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (x != null) setS(() { imagePath = x.path; });
              }

              Future<void> _pickFromCamera() async {
                final x = await ImagePicker().pickImage(source: ImageSource.camera);
                if (x != null) setS(() { imagePath = x.path; });
              }

              Future<void> _pickEditDate() async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: targetDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        dialogTheme: const DialogThemeData(
                            backgroundColor: Color(0xFF111827)),
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
                if (d != null) setS(() => targetDate = DateUtils.dateOnly(d));
              }

              Widget _previewThumb() {
                if (imagePath.startsWith('assets/')) {
                  return Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.white54),
                  );
                }
                return Image.file(
                  File(imagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_rounded, color: Colors.white54),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 38, height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text('แก้ไขกิจกรรม',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        )),
                    const SizedBox(height: 12),

                    // เลือกวัน
                    Material(
                      color: const Color(0xFF0E1320),
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: _pickEditDate,
                        child: Container(
                          height: 42,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today_rounded, color: Colors.white54, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                '${targetDate.day} ${_monthNames[targetDate.month]} ${targetDate.year}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                              ),
                              const Spacer(),
                              const Icon(Icons.edit_calendar_rounded, color: Colors.white54, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Title
                    TextField(
                      controller: titleCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: _fieldDeco('หัวข้อกิจกรรม'),
                    ),
                    const SizedBox(height: 10),

                    // Time range
                    Row(
                      children: [
                        Expanded(
                          child: _PickButton(
                            label: 'เริ่ม',
                            value: start == null ? '--:--' : '${start!.hour.toString().padLeft(2, '0')}:${start!.minute.toString().padLeft(2, '0')}',
                            onTap: () async {
                              final init = start ?? const TimeOfDay(hour: 9, minute: 0);
                              final t = await pick(init);
                              if (t != null) setS(() => start = t);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _PickButton(
                            label: 'สิ้นสุด',
                            value: end == null ? '--:--' : '${end!.hour.toString().padLeft(2, '0')}:${end!.minute.toString().padLeft(2, '0')}',
                            onTap: () async {
                              final init = end ?? const TimeOfDay(hour: 10, minute: 0);
                              final t = await pick(init);
                              if (t != null) setS(() => end = t);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Detail
                    TextField(
                      controller: detailCtrl,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: _fieldDeco('รายละเอียด (ไม่บังคับ)'),
                    ),
                    const SizedBox(height: 12),

                    // แนบรูป: แกลเลอรี + กล้อง + พรีวิว
                    Row(
                      children: [
                        _IconSquareBtn(icon: Icons.photo_library_rounded, onTap: _pickFromGallery),
                        const SizedBox(width: 8),
                        _IconSquareBtn(icon: Icons.photo_camera_rounded, onTap: _pickFromCamera),
                        const SizedBox(width: 10),
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _previewThumb(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ปุ่มบันทึก / ลบ
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white24),
                              foregroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              textStyle: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            onPressed: () => Navigator.pop(context, 'delete'),
                            icon: const Icon(Icons.delete_forever_rounded),
                            label: const Text('ลบกิจกรรม'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              textStyle: const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            onPressed: () {
                              final title = titleCtrl.text.trim();
                              if (title.isEmpty || start == null || end == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('กรอกหัวข้อ และเลือกเวลาเริ่ม–สิ้นสุด')),
                                );
                                return;
                              }
                              if (_toMin(start!) >= _toMin(end!)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('ช่วงเวลาไม่ถูกต้อง (เวลาเริ่มต้องน้อยกว่าเวลาสิ้นสุด)')),
                                );
                                return;
                              }
                              final sameDay = DateUtils.isSameDay(targetDate, keyOld);
                              if (_hasOverlap(targetDate, start!, end!, ignoreIndex: sameDay ? index : null)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('ช่วงเวลาชนกับกิจกรรมอื่นในวันเดียวกัน')),
                                );
                                return;
                              }

                              final timeRange =
                                  '${start!.hour.toString().padLeft(2, '0')}:${start!.minute.toString().padLeft(2, '0')} - '
                                  '${end!.hour.toString().padLeft(2, '0')}:${end!.minute.toString().padLeft(2, '0')}';
                              Navigator.pop(
                                context,
                                'save|$title|$timeRange|$imagePath|${detailCtrl.text.trim()}|${targetDate.millisecondsSinceEpoch}',
                              );
                            },
                            icon: const Icon(Icons.save_rounded),
                            label: const Text('บันทึก'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (!mounted) return;

    if (saved == 'delete') {
      // ลบ
      listOld.removeAt(index);
      if (listOld.isEmpty) _events.remove(keyOld);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ลบกิจกรรมแล้ว')));
      return;
    }

    if (saved != null && saved.startsWith('save|')) {
      final parts = saved.split('|');
      // parts: [save, title, timeRange, imagePath, detail, epoch]
      final newTitle = parts[1];
      final newTime = parts[2];
      final newImage = parts[3];
      final newDetail = parts[4];
      final newDate = DateTime.fromMillisecondsSinceEpoch(int.parse(parts[5]));
      final keyNew = DateUtils.dateOnly(newDate);

      final updated = _Event(
        title: newTitle,
        timeRange: newTime,
        imagePath: newImage,
        detail: newDetail,
      );

      if (keyNew == keyOld) {
        // อัปเดตบนวันเดิม
        listOld[index] = updated;
        listOld.sort(_compareEventByStart);
      } else {
        // ย้ายวัน: เอาออกจากวันเดิมแล้วไปใส่วันใหม่
        listOld.removeAt(index);
        if (listOld.isEmpty) _events.remove(keyOld);
        final listNew = _events.putIfAbsent(keyNew, () => []);
        listNew.add(updated);
        listNew.sort(_compareEventByStart);
        // เปลี่ยน selected ไปวันใหม่เพื่อ “เห็น” รายการที่ย้ายมา
        _selected = keyNew;
      }

      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('บันทึกการแก้ไขแล้ว')));
    }
  }

  Future<void> _confirmDelete(int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('ลบกิจกรรม?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        content: const Text('คุณต้องการลบกิจกรรมนี้หรือไม่?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('ยกเลิก')),
          TextButton(
            onPressed: () => Navigator.pop(c, true),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: const Text('ลบ'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      final key = DateUtils.dateOnly(_selected);
      final list = _events[key]!;
      list.removeAt(index);
      if (list.isEmpty) _events.remove(key);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ลบกิจกรรมแล้ว')));
    }
  }

  InputDecoration _fieldDeco(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF0E1320),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    // ✅ จัดเรียงลิสต์ของวันปัจจุบันก่อนแสดงผล
    final key = DateUtils.dateOnly(_selected);
    _events[key]?.sort(_compareEventByStart);

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            // -------- Header บนเหมือนในภาพ --------
            const _HeaderCard(),

            // -------- แถบเลือกวัน + ปุ่มเลื่อนซ้ายขวา + ปุ่มเพิ่มกิจกรรม --------
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
                  const SizedBox(width: 6),
                  // ✅ ปุ่มเพิ่มกิจกรรม
                  _RoundIconBtn(
                    icon: Icons.add_rounded,
                    onTap: _addEventSheet,
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
                          // ปุ่มแยกด้านล่างของการ์ด
                          onEdit: () => _editEventSheet(i),
                          onDelete: () => _confirmDelete(i),
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

/// ปุ่มกลมสำหรับเลื่อนวัน/เพิ่มกิจกรรม
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
          child: Icon(icon, color: Colors.black87, size: 18),
        ),
      ),
    );
  }
}

/// ปุ่มไอคอนสี่เหลี่ยม (ใช้ในแผ่นเพิ่ม/แก้ไขกิจกรรม: แกลเลอรี/กล้อง)
class _IconSquareBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconSquareBtn({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0E1320),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: SizedBox(
          height: 42,
          width: 42,
          child: Icon(icon, color: Colors.white70, size: 20),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final _Event event;
  final DateTime day;
  final String daysLeftText;
  final VoidCallback? onEdit;   // ปุ่มแก้ไข (นอกการ์ด)
  final VoidCallback? onDelete; // ปุ่มลบ (นอกการ์ด)
  const _EventCard({
    required this.event,
    required this.day,
    required this.daysLeftText,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final month = _CalendarPageState._monthNames[day.month].toUpperCase();

    Widget _buildImage() {
      final p = event.imagePath;
      if (p.startsWith('assets/')) {
        return Image.asset(
          p,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Center(child: Icon(Icons.image, color: Colors.white70)),
        );
      } else {
        return Image.file(
          File(p),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Center(child: Icon(Icons.broken_image_rounded, color: Colors.white70)),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 160,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white.withValues(alpha: 0.06),
            ),
            clipBehavior: Clip.antiAlias,
            child: Row(
              children: [
                // === ภาพแบบ "ดึงสุดพื้นที่" ===
                Expanded(
                  flex: 11,
                  child: Stack(children: [Positioned.fill(child: _buildImage())]),
                ),
                // แพเนลขวา (วันที่ใหญ่)
                Expanded(
                  flex: 9,
                  child: Stack(
                    children: [
                      Container(
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                          ),
                        ),
                        child: Align(
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
        const SizedBox(height: 8),
        // แถวปุ่มแอ็กชันแยกชัดเจน (อยู่นอกการ์ด)
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: onEdit,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white24),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text('แก้ไข'),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: onDelete,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
              label: const Text('ลบ', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700)),
            ),
          ],
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
  final String imagePath; // รองรับทั้ง asset และไฟล์ที่เลือก
  final String detail;
  const _Event({
    required this.title,
    required this.timeRange,
    required this.imagePath,
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

class _PickButton extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  const _PickButton({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF0E1320),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Text(label, style: const TextStyle(color: Colors.white70)),
              const Spacer(),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              const Icon(Icons.access_time, color: Colors.white54, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
