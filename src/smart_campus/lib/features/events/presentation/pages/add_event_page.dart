import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/utils/permissions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/announcement_bloc.dart';
import '../../../../blocs/announcement_event.dart';
import '../../../../entities/announcement_entity.dart';

// المحطة الثالثة: استيراد خدمة التنبيهات
import '../../../../../../services/notification_service.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  File? _selectedImage;

  // اختيار صورة من الكاميرا
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

  // اختيار صورة من المعرض
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
        child: SingleChildScrollView(
          // أضفنا هذا لتجنب مشاكل المساحة عند ظهور الكيبورد
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              // عرض الصورة المختارة
              if (_selectedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

              const SizedBox(height: 16),

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

              const SizedBox(height: 32),

              // زر الحفظ وإرسال التنبيه
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (_titleController.text.isNotEmpty &&
                        _bodyController.text.isNotEmpty) {
                      // 1. إنشاء كائن الإعلان
                      final newAnnouncement = AnnouncementEntity(
                        id: DateTime.now().millisecondsSinceEpoch,
                        title: _titleController.text,
                        body: _bodyController.text,
                      );

                      // 2. المحطة الرابعة: إرسال الإعلان للـ Bloc لتحديث الواجهة
                      context.read<AnnouncementBloc>().add(
                        AddAnnouncement(newAnnouncement),
                      );

                      // 3. المحطة الخامسة (OS Service): إرسال تنبيه فوري للنظام
                      await NotificationService.showInstantNotification(
                        "New Event Posted!",
                        _titleController.text,
                      );

                      if (mounted) {
                        Navigator.pop(context); // العودة للشاشة الرئيسية

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Announcement added and Notification sent!',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                    }
                  },
                  child: const Text(
                    'Save & Post Event',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
