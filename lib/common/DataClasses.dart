import 'Constants.dart';

class UserDetails {
  String firestoreId = '';
  String? uuid;
  String? code;
  String name = '';
  String emailId = '';
  String phoneNo = '';
  String userRole = '';
  String? fcmToken;
  String? platform;
  String? appVersion;
  List<String> photoPaths = [];
  List<String> photoUrls = [];

  UserDetails.fromSnapshot(String id, Map<String, dynamic> snapshot) {
    firestoreId = id;
    uuid = snapshot.containsKey(uuidKey) ? snapshot[uuidKey] : null;
    code = snapshot.containsKey(codeKey) ? snapshot[codeKey] : null;
    fcmToken = snapshot.containsKey(fcmTokenKey) ? snapshot[fcmTokenKey] : null;
    name = snapshot.containsKey(nameKey) ? snapshot[nameKey] : '';
    emailId = snapshot.containsKey(emailIdKey) ? snapshot[emailIdKey] : '';
    phoneNo = snapshot.containsKey(phoneNoKey) ? snapshot[phoneNoKey] : '';
    userRole = snapshot.containsKey(userRoleKey) ? snapshot[userRoleKey] : '';
    platform = snapshot.containsKey(platformKey) ? snapshot[platformKey] : null;
    appVersion =
        snapshot.containsKey(appVersionKey) ? snapshot[appVersionKey] : null;
    if (snapshot.containsKey(photoUrlsKey)) {
      photoUrls = List<String>.from(snapshot[photoUrlsKey]);
    } else {
      photoUrls = List.empty();
    }
  }

  Map<String, dynamic> toSnapShot() {
    return {
      uuidKey: uuid,
      codeKey: code,
      fcmTokenKey: fcmToken,
      nameKey: name,
      emailIdKey: emailId,
      phoneNoKey: phoneNo,
      userRoleKey: userRole,
      platformKey: platform,
      appVersionKey: appVersion,
      photoUrlsKey: photoUrls,
    };
  }

  UserDetails() {}

  String getRoleText() {
    if (userRole == UserRoles.superAdmin.toString()) {
      return 'Super Admin';
    } else if (userRole == UserRoles.serviceAdmin.toString()) {
      return 'Service Admin';
    } else if (userRole == UserRoles.serviceEngineer.toString()) {
      return 'Service Engineer';
    } else if (userRole == UserRoles.userAdmin.toString()) {
      return 'User Admin';
    } else if (userRole == UserRoles.userManager.toString()) {
      return 'User';
    } else {
      return '_';
    }
  }

  bool canUpdateEquipment() {
    return userRole == UserRoles.superAdmin.toString();
  }

  bool canViewQRCode() {
    return userRole == UserRoles.superAdmin.toString();
  }
}
