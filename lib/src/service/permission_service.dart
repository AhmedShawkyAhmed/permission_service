import 'dart:io';

import '../utils/permission.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

export 'package:permission_handler/permission_handler.dart';

enum StoragePermissionTypes { all, gallery, photos, videos, audio }

/// [confirmBeforeRequestDialogue] method is used to show a dialogue that notifies the user with every permission before requesting it. <br>
/// It takes should return [true] if he agrees to grant permission.
class PermissionService {
  static late final int repeatPermissionRequestCount;
  static late final String Function(Permission permission, bool fromSettings)?
      customMessage;
  static late final Future<bool> Function(String message)
      confirmBeforeRequestDialogue;

  static Future<bool> _defaultConfirmationBehavior(String message) async =>
      true;
  static late final int _androidSdkVersionInt;
  static late final String _iosSystemVersion;

  PermissionService._();

  static void init(
      {String Function(Permission permission, bool fromSettings)?
          messageBuilder,
      required Future<bool> Function(String message)? showConfirmDialogue,
      int repeatPermissionRequestCount = 3,

      /// This variable is used to check if the storage permission is separated from android >= 13 && sdk >= 33.
      ///
      /// Get this value from [device_info_plus] library, androidInfo.version.sdkInt
      required int androidSdkVersionInt,

      /// This variable is used to check if the storage permission is separated from ios >= 14
      ///
      /// Get this value from [device_info_plus] library, iosInfo.systemVersion = "14.0"
      required String iosSystemVersion}) {
    PermissionService.customMessage = messageBuilder;
    PermissionService.confirmBeforeRequestDialogue =
        showConfirmDialogue ?? _defaultConfirmationBehavior;
    PermissionService.repeatPermissionRequestCount =
        repeatPermissionRequestCount;
    PermissionService._androidSdkVersionInt = androidSdkVersionInt;
    PermissionService._iosSystemVersion = iosSystemVersion;
  }

  /// Make sure the required permissions is granted with a dialogue that notifies the user with every permission before requesting it.
  ///
  /// returning [true] if all permissions was granted.
  static Future<bool> checkPermission(List<Permission> permissions) async {
    // replace storage permissions with the media permissions for android >= 13 & ios >= 14
    int storagePermissionIndex = permissions.indexWhere(
        (permission) => permission.value == Permission.storage.value);
    if (storagePermissionIndex != -1) {
      permissions.removeAt(storagePermissionIndex);
      permissions.insertAll(
          storagePermissionIndex, await getStoragePermission());
    }
    List<PermissionStatus> statuses = [];
    for (var permission in permissions) {
      statuses.add(await permission.request());
    }
    for (var i = 0; i < statuses.length; i++) {
      var permission = permissions[i];
      if (statuses[i].isGranted || statuses[i].isLimited) continue;
      if (statuses[i].isDenied) {
        int deniedCount = 0;
        bool isPermanent() =>
            statuses[i].isPermanentlyDenied ||
            deniedCount >= repeatPermissionRequestCount;
        do {
          if (!isPermanent()) {
            statuses[i] = await permission.request();
            if (statuses[i].isDenied) deniedCount++;
          } else if (isPermanent() &&
              await confirmBeforeRequestDialogue(_getPermissionRequestMessage(
                  permission,
                  fromSettings: isPermanent()))) {
            if (isPermanent()) {
              await openMediaPermissionSettings(permission);
              statuses[i] = await permission.status;
            } else {
              statuses[i] = await permission.request();
              if (statuses[i].isDenied) deniedCount++;
            }
          } else {
            break;
          }
        } while (statuses[i].isDenied || statuses[i].isPermanentlyDenied);
      } else {
        if (await confirmBeforeRequestDialogue(
            _getPermissionRequestMessage(permission, fromSettings: true))) {
          await openMediaPermissionSettings(permission);
          statuses[i] = await permission.status;
        } else {
          continue;
        }
        return false;
      }
    }
    bool isAllPermissionsGranted = statuses
            .where((status) => status.isGranted || status.isLimited)
            .length ==
        permissions.length;
    return isAllPermissionsGranted;
  }

  /// Returns storage permission for android >= 13 & ios >= 14
  static Future<List<Permission>> getStoragePermission(
      {StoragePermissionTypes type = StoragePermissionTypes.gallery}) async {
    if (Platform.isIOS) type = StoragePermissionTypes.photos;
    List<Permission> separatedPermissions() {
      switch (type) {
        case StoragePermissionTypes.all:
          return [Permission.photos, Permission.videos, Permission.audio];
        case StoragePermissionTypes.gallery:
          return [Permission.photos, Permission.videos];
        case StoragePermissionTypes.photos:
          return [Permission.photos];
        case StoragePermissionTypes.videos:
          return [Permission.videos];
        case StoragePermissionTypes.audio:
          return [Permission.audio];
      }
    }

    List<Permission> storagePermission = [Permission.storage];
    if (Platform.isAndroid) {
      if (_androidSdkVersionInt >= 33) {
        return separatedPermissions();
      }
    } else if (Platform.isIOS) {
      List<String> versionParts = _iosSystemVersion.split('.');
      if (int.parse(versionParts.first) >= 14) {
        return separatedPermissions();
      }
    }
    return storagePermission;
  }

  /// Returns documents permission for android >= 13 & ios >= 14
  static Future<List<Permission>> getDocumentsPermission() async {
    List<Permission> storagePermission = [Permission.storage];
    if (Platform.isAndroid) {
      if (_androidSdkVersionInt < 33) {
        return storagePermission;
      }
    } else if (Platform.isIOS) {
      List<String> versionParts = _iosSystemVersion.split('.');
      if (int.parse(versionParts.first) < 14) {
        return storagePermission;
      }
    }
    return [];
  }

  static Future<void> openMediaPermissionSettings(
      Permission mediaPermission) async {
    await openAppSettings();
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  static String _getPermissionRequestMessage(Permission permission,
      {bool fromSettings = false}) {
    if (customMessage != null) {
      return customMessage!(permission, fromSettings);
    }
    String message(arabicPermissionName) =>
        '${fromSettings ? 'فشل طلب الصلاحية!' : ''} برجاء السماح بصلاحية استخدام $arabicPermissionName ${fromSettings ? 'من الإعدادات' : ''} لتتمكن من استخدام كامل وظائف التطبيق.'
        '${arabicPermissionName == 'الإشعارات' ? '\nيمكنك التحكم بالاشعارات من ادارة تنبيهات التطبيق.' : ''}';
    return message(permission.arName);
  }
}
