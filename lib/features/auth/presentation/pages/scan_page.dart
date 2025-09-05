// lib/features/auth/presentation/pages/scan_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app/app_theme.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  // ===== ข้อมูลชุดข้อสอบ =====
  static const _sets = <String>[
    'ข้อสอบชุดที่ A',
    'ข้อสอบชุดที่ B',
    'ข้อสอบชุดที่ C',
    'ข้อสอบชุดที่ D',
    'ข้อสอบชุดที่ E',
  ];
  String _selectedSet = _sets.first;

  // ===== กล้อง =====
  CameraController? _camera;
  Future<void>? _initCam;
  XFile? _pickedFromGallery;
  XFile? _lastShot;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cams = await availableCameras();
      final back = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cams.first,
      );
      final controller = CameraController(
        back,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      _camera = controller;
      _initCam = controller.initialize();
      await _initCam;
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera init error: $e');
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _camera?.dispose();
    super.dispose();
  }

  // ===== Actions =====
  Future<void> _takePhoto() async {
    if (_camera == null || !_camera!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถเปิดกล้องได้')),
      );
      return;
    }
    try {
      final shot = await _camera!.takePicture();
      setState(() => _lastShot = shot);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('สแกน (demo) – $_selectedSet')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('ถ่ายไม่สำเร็จ: $e')));
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final x = await picker.pickImage(source: ImageSource.gallery);
      if (x != null) {
        setState(() => _pickedFromGallery = x);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เลือกภาพจากแกลเลอรี (demo) – $_selectedSet')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('เปิดแกลเลอรีไม่สำเร็จ: $e')));
    }
  }

  void _chooseSet() async {
    final chosen = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF111827),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              const Text('เลือกชุดข้อสอบ',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16)),
              const SizedBox(height: 8),
              for (final s in _sets)
                RadioListTile<String>(
                  value: s,
                  groupValue: _selectedSet,
                  onChanged: (v) => Navigator.pop(context, v),
                  title: Text(s, style: const TextStyle(color: Colors.white)),
                  activeColor: Colors.redAccent,
                ),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
    if (chosen != null && chosen != _selectedSet) {
      setState(() => _selectedSet = chosen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,

      // ===== AppBar =====
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'ตรวจข้อสอบ',
          style: TextStyle(
            color: Color(0xFFE01C1C),
            fontWeight: FontWeight.w900,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(46),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Row(
              children: [
                const Text('โปรดเลือกชุดข้อสอบ',
                    style: TextStyle(color: Colors.white70)),
                const Spacer(),
                // ปุ่มไอคอนเปิด bottom sheet
                Material(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: _chooseSet,
                    borderRadius: BorderRadius.circular(10),
                    child: const SizedBox(
                      height: 32,
                      width: 36,
                      child: Icon(Icons.list_alt_rounded,
                          color: Colors.white70, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ===== พื้นที่พรีวิว + มุมไกด์ =====
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _buildPreview(),
                        const _CornerGuides(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ===== แถบควบคุมล่าง: ชัตเตอร์กลางจอ + แกลเลอรีขวา =====
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 110,
          decoration: const BoxDecoration(
            color: Color(0xFF1C2028),
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
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ✅ ปุ่มชัตเตอร์ “กึ่งกลางจริงๆ”
              GestureDetector(
                onTap: _takePhoto,
                child: Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Center(
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // ปุ่มแกลเลอรีด้านขวา กึ่งกลางแนวตั้ง
              Positioned(
                right: 16,
                child: GestureDetector(
                  onTap: _pickFromGallery,
                  child: Container(
                    width: 50,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: const Icon(
                      Icons.photo_library_rounded,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== พรีวิวลอจิก =====
  Widget _buildPreview() {
    if (_pickedFromGallery != null) {
      return Image.file(File(_pickedFromGallery!.path), fit: BoxFit.contain);
    }

    final cam = _camera;
    if (cam != null) {
      return FutureBuilder(
        future: _initCam,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.done &&
              cam.value.isInitialized) {
            return CameraPreview(cam);
          }
          if (snap.hasError) {
            return _fallback();
          }
          return Container(color: const Color(0xFFF4F4F4));
        },
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return Container(
      color: const Color(0xFFF4F4F4),
      alignment: Alignment.center,
      child: Image.asset(
        'assets/images/proof_sample.png',
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.image_not_supported_outlined,
          size: 48,
          color: Colors.black45,
        ),
      ),
    );
  }
}

/// วาด “มุมไกด์” 4 มุมแบบ L สีเทาอ่อน
class _CornerGuides extends StatelessWidget {
  const _CornerGuides();

  @override
  Widget build(BuildContext context) {
    const len = 56.0;
    const thick = 3.0;
    const color = Color(0xFFCDCDCD);

    Widget corner({required Alignment align}) {
      return Align(
        alignment: align,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: SizedBox(
            width: len,
            height: len,
            child: Stack(children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(width: len, height: thick, color: color),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(width: thick, height: len, color: color),
              ),
            ]),
          ),
        ),
      );
    }

    Widget cornerTR() {
      return Align(
        alignment: Alignment.topRight,
        child: Transform.rotate(
          angle: 1.5708, // 90deg
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: SizedBox(
              width: len,
              height: len,
              child: Stack(children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(width: len, height: thick, color: color),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(width: thick, height: len, color: color),
                ),
              ]),
            ),
          ),
        ),
      );
    }

    Widget cornerBR() {
      return Align(
        alignment: Alignment.bottomRight,
        child: Transform.rotate(
          angle: 3.14159, // 180deg
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: SizedBox(
              width: len,
              height: len,
              child: Stack(children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(width: len, height: thick, color: color),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(width: thick, height: len, color: color),
                ),
              ]),
            ),
          ),
        ),
      );
    }

    Widget cornerBL() {
      return Align(
        alignment: Alignment.bottomLeft,
        child: Transform.rotate(
          angle: -1.5708, // -90deg
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: SizedBox(
              width: len,
              height: len,
              child: Stack(children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(width: len, height: thick, color: color),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(width: thick, height: len, color: color),
                ),
              ]),
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        corner(align: Alignment.topLeft),
        cornerTR(),
        cornerBR(),
        cornerBL(),
      ],
    );
  }
}
