## Usage
1. Import the necessary packages:

```dart
  permission_service:
    git:
      url: https://github.com/AhmedShawkyAhmed/permission_service.git
```
2. Initialize the socket using the `init` method:

```dart
PermissionService.checkPermission([Permission.locationWhenInUse]);
```