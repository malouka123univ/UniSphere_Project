/// ------------------------------- --------------------------
/// صفحة إضافة حدث - الأسبوع الرابع
/// المسؤولية: إضافة حدث جديد مع صورة من الكاميرا أو المعرض
/// مفهوم OS: Camera/Gallery Integration + Runtime Permissions
/// ---------------------------------------------------------

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/permissions.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  File? _selectedImage;

  /// اختيار صورة من الكاميرا
  Future<void> _pickFromCamera() async {
    final hasPermission = await PermissionManager.requestCamera();

    if (!hasPermission) {
      _showPermissionDenied('Camera');
      return;
    }

    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  /// اختيار صورة من المعرض
  Future<void> _pickFromGallery() async {
    final hasPermission = await PermissionManager.requestPhotos();

    if (!hasPermission) {
      _showPermissionDenied('Photos');
      return;
    }

    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  /// عرض رسالة عند رفض الإذن
  void _showPermissionDenied(String feature) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('$feature Permission Required'),
        content: Text('Please allow access to $feature in app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              PermissionManager.openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Event')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Event Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            /// عرض الصورة المختارة
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

            const SizedBox(height: 16),

            /// أزرار اختيار الصورة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                ElevatedButton.icon(
                  onPressed: _pickFromGallery,
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}