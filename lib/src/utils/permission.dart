import 'package:permission_handler/permission_handler.dart';

extension PermissionExtension on Permission {
  String get arName {
    String permissionName = '';
    switch (this) {
      case Permission.calendar:
        permissionName = 'التقويم';
        break;
      case Permission.calendarWriteOnly:
        permissionName = 'التقويم';
      case Permission.calendarFullAccess:
        permissionName = 'التقويم';
        break;
      case Permission.camera:
        permissionName = 'الكاميرا';
        break;
      case Permission.contacts:
        permissionName = 'جهات الاتصال';
        break;
      case Permission.location:
        permissionName = 'الموقع';
        break;
      case Permission.locationAlways:
        permissionName = 'الموقع - دائماً';
        break;
      case Permission.locationWhenInUse:
        permissionName = 'الموقع - عند الاستخدام';
        break;
      case Permission.mediaLibrary:
        permissionName = 'مكتبة الوسائط';
        break;
      case Permission.microphone:
        permissionName = 'الميكروفون';
        break;
      case Permission.phone:
        permissionName = 'الهاتف';
        break;
      case Permission.photos:
        permissionName = 'الصور';
        break;
      case Permission.photosAddOnly:
        permissionName = 'الصور - إضافة فقط';
        break;
      case Permission.reminders:
        permissionName = 'التذكيرات';
        break;
      case Permission.sensors:
        permissionName = 'الحساسات';
        break;
      case Permission.sms:
        permissionName = 'الرسائل النصية';
        break;
      case Permission.speech:
        permissionName = 'الكلام';
        break;
      case Permission.storage:
        permissionName = 'التخزين';
        break;
      case Permission.ignoreBatteryOptimizations:
        permissionName = 'تجاهل تحسينات البطارية';
        break;
      case Permission.notification:
        permissionName = 'الإشعارات';
        break;
      case Permission.accessMediaLocation:
        permissionName = 'وصول إلى موقع وسائط';
        break;
      case Permission.activityRecognition:
        permissionName = 'الكشف عن النشاط';
        break;
      case Permission.bluetooth:
        permissionName = 'البلوتوث';
        break;
      case Permission.manageExternalStorage:
        permissionName = 'إدارة التخزين الخارجي';
        break;
      case Permission.systemAlertWindow:
        permissionName = 'نافذة التنبيهات النظامية';
        break;
      case Permission.requestInstallPackages:
        permissionName = 'طلب تثبيت التطبيقات';
        break;
      case Permission.appTrackingTransparency:
        permissionName = 'تتبع التطبيق';
        break;
      case Permission.criticalAlerts:
        permissionName = 'تنبيهات حرجة';
        break;
      case Permission.accessNotificationPolicy:
        permissionName = 'وصول إلى سياسة الإشعارات';
        break;
      case Permission.bluetoothScan:
        permissionName = 'فحص البلوتوث';
        break;
      case Permission.bluetoothAdvertise:
        permissionName = 'الإعلان عن البلوتوث';
        break;
      case Permission.bluetoothConnect:
        permissionName = 'الاتصال بالبلوتوث';
        break;
      case Permission.nearbyWifiDevices:
        permissionName = 'أجهزة الواي فاي القريبة';
        break;
      case Permission.videos:
        permissionName = 'مقاطع الفيديو';
        break;
      case Permission.audio:
        permissionName = 'الصوت';
        break;
      case Permission.scheduleExactAlarm:
        permissionName = 'جدولة المنبهات الدقيقة';
        break;
      case Permission.sensorsAlways:
        permissionName = 'الحساسات - دائماً';
        break;
      case Permission.unknown:
        permissionName = 'غير معروف';
        break;
    }
    return permissionName;
  }
}
