import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../common/Constants.dart';
import '../common/DataClasses.dart';
import '../common/FCMManager.dart';
import '../common/globalFunctions.dart';
import '../main.dart';

const String userCollectionKey = 'users';

Future<bool> fetchAndUpdateUserDetailsIfUserExist(String phoneNumber) async {
  currentUserDetails = await getUserDetails(phoneNumber);
  if (currentUserDetails?.phoneNo.isNotEmpty == true) {
    if (isNotAppleTester()) {
      //No need to manage FCM for apple tester
      currentUserDetails?.fcmToken = fcmToken;
    }
    currentUserDetails?.uuid = currentFirebaseAuthUser?.uid;
    if (currentUserDetails != null)
      return await updateUserDetails(currentUserDetails!);
  }
  return false;
}

Future<UserDetails> getUserDetails(String phoneNumber) async {
  var fireStore = FirebaseFirestore.instance;
  QuerySnapshot itemList = await fireStore
      .collection(userCollectionKey)
      .where(phoneNoKey, isEqualTo: phoneNumber)
      .get();
  var items = itemList.docs
      .map((doc) =>
          UserDetails.fromSnapshot(doc.id, doc.data() as Map<String, dynamic>))
      .toList();
  if (items.isNotEmpty) {
    return items.first;
  } else {
    return UserDetails();
  }
}

Future<UserDetails> getUserDetailsForUUID(String uuid) async {
  var fireStore = FirebaseFirestore.instance;
  QuerySnapshot itemList = await fireStore
      .collection(userCollectionKey)
      .where(uuidKey, isEqualTo: uuid)
      .get();
  var items = itemList.docs
      .map((doc) =>
          UserDetails.fromSnapshot(doc.id, doc.data() as Map<String, dynamic>))
      .toList();
  if (items.isNotEmpty) {
    return items.first;
  } else {
    return UserDetails();
  }
}

Future<bool> updateUserDetails(UserDetails details) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  details.code = details.emailId; //TODO
  details.appVersion = version;
  details.platform = defaultTargetPlatform.toString();

  if (details.photoPaths.isNotEmpty) {
    var urls = await uploadFileAndGetDownloadUrls(details.photoPaths, 'Users');
    details.photoUrls = urls;
  }

  var data = details.toSnapShot();
  data[updatedTimeKey] = FieldValue.serverTimestamp();
  CollectionReference users =
      FirebaseFirestore.instance.collection(userCollectionKey);
  if (details.firestoreId.isEmpty) {
    details.firestoreId = Uuid().v1();
    return await users
        .doc(details.firestoreId)
        .set(data)
        .then((value) => true)
        .catchError((error) => false);
  } else {
    return await users
        .doc(details.firestoreId)
        .update(data)
        .then((value) => true)
        .catchError((error) => false);
  }
}

Future<bool> updateUserDetailsForLogout(String firestoreId) async {
  CollectionReference users =
      FirebaseFirestore.instance.collection(userCollectionKey);
  return await users
      .doc(firestoreId)
      .update({
        uuidKey: "",
        fcmTokenKey: "",
        updatedTimeKey: FieldValue.serverTimestamp()
      })
      .then((value) => true)
      .catchError((error) => false);
}

Future<List<UserDetails>> getAllUserList() async {
  var fireStore = FirebaseFirestore.instance;
  var itemList = await fireStore.collection(userCollectionKey).get();
  var items = itemList.docs
      .map((doc) =>
          UserDetails.fromSnapshot(doc.id, doc.data() as Map<String, dynamic>))
      .toList();
  items = items
      .where((element) => element.userRole != UserRoles.superAdmin.toString())
      .toList();

  return items;
}

Future<List<UserDetails>> getUserList(UserRoles userRole) async {
  var fireStore = FirebaseFirestore.instance;
  var itemList = await fireStore
      .collection(userCollectionKey)
      .where(userRoleKey, isEqualTo: userRole.toString())
      .get();
  var items = itemList.docs
      .map((doc) =>
          UserDetails.fromSnapshot(doc.id, doc.data() as Map<String, dynamic>))
      .toList();

  return items;
}

Future<bool> deleteUserDetails(String documentId) async {
  CollectionReference users =
      FirebaseFirestore.instance.collection(userCollectionKey);
  return await users
      .doc(documentId)
      .delete()
      .then((value) => true)
      .catchError((error) => false);
}
