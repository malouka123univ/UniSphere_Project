/// ---------------------------------------------------------
/// مدير الأذونات - الأسبوع الرابع
/// المسؤولية: طلب وفحص الأذونات في وقت التشغيل
/// مفهوم OS: Runtime Permission Model
/// ---------------------------------------------------------

import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  /// طلب إذن الكاميرا
  static Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// طلب إذن المعرض (الصور)
  static Future<bool> requestPhotos() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  /// طلب إذن الموقع
  static Future<bool> requestLocation() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  /// فحص إذا كان الإذن مرفوض نهائياً
  static Future<bool> isPermanentlyDenied(Permission permission) async {
    return await permission.isPermanentlyDenied;
  }

  /// فتح إعدادات التطبيق (عند الرفض النهائي)
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}