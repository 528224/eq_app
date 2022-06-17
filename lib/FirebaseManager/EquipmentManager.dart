import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../common/Constants.dart';
import '../common/FCMManager.dart';
import '../common/globalFunctions.dart';
import '../main.dart';
import '../products/Model/EquipmentDetails.dart';

const String equipmentCollectionKey = 'equipments';

Future<List<EquipmentDetails>> getEquipmentList() async {
  var fireStore = FirebaseFirestore.instance;
  QuerySnapshot itemList = await fireStore
      .collection(equipmentCollectionKey)
      .orderBy(updatedTimeKey, descending: true)
      .get();
  var items = itemList.docs
      .map((doc) =>
          EquipmentDetails.fromSnapshot(doc.data() as Map<String, dynamic>))
      .toList();

  var userCode = currentUserDetails?.code ?? "";
  var userRole = currentUserDetails?.userRole ?? "";
  if (userRole.isEmpty || userCode.isEmpty) {
    return [];
  } else if (userRole == UserRoles.userManager.toString()) {
    items =
        items.where((element) => element.userManagerCode == userCode).toList();
  } else if (userRole == UserRoles.userAdmin.toString()) {
    items = items
        .where((element) =>
            element.userManagerCode == userCode ||
            element.userAdminCode == userCode)
        .toList();
  } else if (isAppleTester()) {
    items = items
        .where((element) =>
            element.userManagerCode == userCode ||
            element.userAdminCode == userCode)
        .toList();
  }

  items = items.where((element) => element.isMarkedAsDeleted == false).toList();
  return items;
}
//
// Future<List<EquipmentDetails>> getEquipmentList() async {
//   var fireStore = FirebaseFirestore.instance;
//   QuerySnapshot itemList;
//   var userCode = currentUserDetails?.code ?? "";
//   var userRole = currentUserDetails?.userRole ?? "";
//   if (userRole.isEmpty || userCode.isEmpty) {
//     return [];
//   } else if (userRole == UserRoles.userManager.toString()) {
//     itemList = await fireStore
//         .collection(equipmentCollectionKey)
//         .where(userManagerCodeKey, isEqualTo: userCode)
//         .orderBy(updatedTimeKey, descending: true)
//         .get();
//   } else if (userRole == UserRoles.userAdmin.toString()) {
//     itemList = await fireStore
//         .collection(equipmentCollectionKey)
//         .where(userAdminCodeKey, isEqualTo: userCode)
//         .orderBy(updatedTimeKey, descending: true)
//         .get();
//     var itemList1 = await fireStore
//         .collection(equipmentCollectionKey)
//         .where(userManagerCodeKey, isEqualTo: userCode)
//         .orderBy(updatedTimeKey, descending: true)
//         .get();
//     if (itemList1.docs.isNotEmpty) {
//       itemList.docs.addAll(itemList1.docs);
//     }
//   } else {
//     itemList = await fireStore
//         .collection(equipmentCollectionKey)
//         .orderBy(updatedTimeKey, descending: true)
//         .get();
//   }
//
//   var items = itemList.docs
//       .map((doc) =>
//           EquipmentDetails.fromSnapshot(doc.data() as Map<String, dynamic>))
//       .toList();
//   return items;
// }

Future<bool> addNewEquipment(EquipmentDetails details) async {
  var docId = details.documentId;
  if (docId.isEmpty) {
    docId = Uuid().v1();
  }
  if (details.photoPaths.isNotEmpty) {
    var urls = await uploadFileAndGetDownloadUrls(
        details.photoPaths, equipmentCollectionKey);
    details.photoUrls.addAll(urls);
  }

  var data = details.toSnapShot();
  data[updatedTimeKey] = FieldValue.serverTimestamp();
  data[documentIdKey] = docId;
  CollectionReference collRef =
      FirebaseFirestore.instance.collection(equipmentCollectionKey);
  return await collRef
      .doc(docId)
      .set(data)
      .then((value) => true)
      .catchError((error) => false);
}

Future<bool> updateEquipmentIdleStatus(String documentId, bool isIdle) async {
  CollectionReference collRef =
      FirebaseFirestore.instance.collection(equipmentCollectionKey);
  return await collRef
      .doc(documentId)
      .update({isIdleKey: isIdle})
      .then((value) => true)
      .catchError((error) => false);
}

Future<bool> updateEquipmentCurrentlyHavingIssueStatus(
    String documentId, bool isCurrentlyHavingIssue) async {
  CollectionReference collRef =
      FirebaseFirestore.instance.collection(equipmentCollectionKey);
  return await collRef
      .doc(documentId)
      .update({isCurrentlyHavingIssueKey: isCurrentlyHavingIssue})
      .then((value) => true)
      .catchError((error) => false);
}

Future<bool> deleteEquipment(String documentId) async {
  CollectionReference collRef =
      FirebaseFirestore.instance.collection(equipmentCollectionKey);
  return await collRef
      .doc(documentId)
      .update({markedAsDeletedKey: true})
      .then((value) => true)
      .catchError((error) => false);
}
