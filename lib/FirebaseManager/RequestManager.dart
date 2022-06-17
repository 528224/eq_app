import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../common/Constants.dart';
import '../common/DataClasses.dart';
import '../common/Extentions.dart';
import '../common/FCMManager.dart';
import '../common/globalFunctions.dart';
import '../main.dart';
import '../request/Model/RequestDetails.dart';
import 'EquipmentManager.dart';

const String requestCollectionKey = 'requests';
const String requestPhotosCollectionKey = 'requestPhotos';
const String requestVideosCollectionKey = 'requestVideos';
const String serviceCollectionKey = 'services';
const String requestReferenceCountKey = 'requestReferenceCount';

Future<List<RequestDetails>> getRequestListForProduct(
    String eqFirestoreId) async {
  var fireStore = FirebaseFirestore.instance;
  var collRef = fireStore.collection(requestCollectionKey);
  var itemList = await collRef
      .where(eqFirestoreIdKey, isEqualTo: eqFirestoreId)
      .orderBy(updatedTimeKey, descending: true)
      .get();
  var items = itemList.docs
      .map((doc) => RequestDetails.fromSnapshot(doc.data()))
      .toList();
  return items;
}

Future<List<RequestDetails>> getPendingRequestList() async {
  var fireStore = FirebaseFirestore.instance;
  var collRef = fireStore.collection(requestCollectionKey);
  QuerySnapshot itemList = await collRef
      .where(statusKey, whereIn: [
        RequestStatus.created.toString(),
        RequestStatus.scheduled.toString(),
        RequestStatus.diagonized.toString()
      ])
      .orderBy(updatedTimeKey, descending: true)
      .get();

  var items = itemList.docs
      .map((doc) =>
          RequestDetails.fromSnapshot(doc.data() as Map<String, dynamic>))
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
  } else if (userRole == UserRoles.serviceEngineer.toString()) {
    items = items
        .where((element) => element.serviceEngineerCode == userCode)
        .toList();
  } else if (isAppleTester()) {
    items = items
        .where((element) =>
            element.userManagerCode == userCode ||
            element.userAdminCode == userCode ||
            element.serviceEngineerCode == userCode)
        .toList();
  }

  return items;
}

//
// Future<List<RequestDetails>> getPendingRequestList() async {
//   var fireStore = FirebaseFirestore.instance;
//   QuerySnapshot itemList;
//   var userCode = currentUserDetails?.code ?? "";
//   var userRole = currentUserDetails?.userRole ?? "";
//   var collRef = fireStore.collection(requestCollectionKey);
//   if (userRole.isEmpty || userCode.isEmpty) {
//     return [];
//   } else if (userRole == UserRoles.userManager.toString()) {
//     itemList = await collRef
//         .where(userManagerCodeKey, isEqualTo: userCode)
//         .where(statusKey, whereIn: [
//           RequestStatus.created.toString(),
//           RequestStatus.scheduled.toString(),
//           RequestStatus.diagonized.toString()
//         ])
//         .orderBy(updatedTimeKey, descending: true)
//         .get();
//   } else if (userRole == UserRoles.userAdmin.toString()) {
//     itemList = await collRef
//         .where(userAdminCodeKey, isEqualTo: userCode)
//         .where(statusKey, whereIn: [
//           RequestStatus.created.toString(),
//           RequestStatus.scheduled.toString(),
//           RequestStatus.diagonized.toString()
//         ])
//         .orderBy(updatedTimeKey, descending: true)
//         .get();
//     var itemList1 = await collRef
//         .where(userManagerCodeKey, isEqualTo: userCode)
//         .where(statusKey, whereIn: [
//           RequestStatus.created.toString(),
//           RequestStatus.scheduled.toString(),
//           RequestStatus.diagonized.toString()
//         ])
//         .orderBy(updatedTimeKey, descending: true)
//         .get();
//     if (itemList1.docs.isNotEmpty) {
//       itemList.docs.addAll(itemList1.docs);
//     }
//   } else if (userRole == UserRoles.serviceEngineer.toString()) {
//     itemList = await collRef
//         .where(serviceEngineerCodeKey, isEqualTo: userCode)
//         .where(statusKey, whereIn: [
//           RequestStatus.scheduled.toString(),
//           RequestStatus.diagonized.toString()
//         ])
//         .orderBy(updatedTimeKey, descending: true)
//         .get();
//   } else {
//     itemList = await collRef
//         .where(statusKey, whereIn: [
//           RequestStatus.created.toString(),
//           RequestStatus.scheduled.toString(),
//           RequestStatus.diagonized.toString()
//         ])
//         .orderBy(updatedTimeKey, descending: true)
//         .get();
//   }
//
//   var items = itemList.docs
//       .map((doc) =>
//           RequestDetails.fromSnapshot(doc.data() as Map<String, dynamic>))
//       .toList();
//
//   return items;
// }
//
// Future<List<RequestDetails>> getRequestHistoryList() async {
//   var fireStore = FirebaseFirestore.instance;
//   QuerySnapshot itemList;
//   var userCode = currentUserDetails?.code ?? "";
//   var userRole = currentUserDetails?.userRole ?? "";
//   var collRef = fireStore.collection(requestCollectionKey);
//   if (userRole.isEmpty || userCode.isEmpty) {
//     return [];
//   } else if (userRole == UserRoles.userManager.toString()) {
//     itemList = await collRef
//         .where(userManagerCodeKey, isEqualTo: userCode)
//         .orderBy(updatedTimeKey, descending: true)
//         .get();
//   } else if (userRole == UserRoles.userAdmin.toString()) {
//     itemList = await collRef
//         .where(userAdminCodeKey, isEqualTo: userCode)
//         .orderBy(updatedTimeKey, descending: true)
//         .get();
//     var itemList1 = await collRef
//         .where(userManagerCodeKey, isEqualTo: userCode)
//         .orderBy(updatedTimeKey, descending: true)
//         .get();
//     if (itemList1.docs.isNotEmpty) {
//       itemList.docs.addAll(itemList1.docs);
//     }
//   } else if (userRole == UserRoles.serviceEngineer.toString()) {
//     itemList = await collRef
//         .where(serviceEngineerCodeKey, isEqualTo: userCode)
//         .orderBy(updatedTimeKey, descending: true)
//         .get();
//   } else {
//     itemList = await collRef.get();
//   }
//
//   var items = itemList.docs
//       .map((doc) =>
//           RequestDetails.fromSnapshot(doc.data() as Map<String, dynamic>))
//       .toList();
//
//   items = items.where((element) {
//     return (element.status == RequestStatus.completed.toString() ||
//         element.status == RequestStatus.ignored.toString());
//   }).toList();
//
//   return items;
// }

Future<List<RequestDetails>> getRequestHistoryList() async {
  var fireStore = FirebaseFirestore.instance;
  var collRef = fireStore.collection(requestCollectionKey);
  QuerySnapshot itemList = await collRef.get();
  var items = itemList.docs
      .map((doc) =>
          RequestDetails.fromSnapshot(doc.data() as Map<String, dynamic>))
      .toList();

  items = items.where((element) {
    return (element.status == RequestStatus.completed.toString() ||
        element.status == RequestStatus.ignored.toString());
  }).toList();

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
  } else if (userRole == UserRoles.serviceEngineer.toString()) {
    items = items
        .where((element) => element.serviceEngineerCode == userCode)
        .toList();
  } else if (isAppleTester()) {
    items = items
        .where((element) =>
            element.userManagerCode == userCode ||
            element.userAdminCode == userCode ||
            element.serviceEngineerCode == userCode)
        .toList();
  }

  items = items.where((element) => element.updatedDateTime != null).toList();
  items.sort((a, b) => b.updatedDateTime!.compareTo(a.updatedDateTime!));

  return items;
}

Future<bool> addNewRequest(RequestDetails details) async {
  details.documentId = Uuid().v1();
  var imageUrls = await uploadFileAndGetDownloadUrls(
      details.requestPhotoPaths, requestPhotosCollectionKey);
  details.requestPhotoUrls.addAll(imageUrls);
  var videoUrls = await uploadFileAndGetDownloadUrls(
      details.requestVideoPaths, requestVideosCollectionKey);
  details.requestVideoUrls.addAll(videoUrls);
  details.status = RequestStatus.created.toString();
  details.actions.add(
      '${currentUserDetails?.name} created request on ${DateTime.now().toString()}');
  details.eqFirestoreId = details.equipment?.documentId ?? "";
  details.userManagerCode = details.equipment?.userManagerCode ?? "";
  details.userAdminCode = details.equipment?.userAdminCode ?? "";
  var data = details.toSnapShot();
  data[updatedTimeKey] = FieldValue.serverTimestamp();
  data[createdDateKey] = FieldValue.serverTimestamp();
  var referenceNumber = await generateReferenceNumber(!details.isAutoGenerated);
  if (referenceNumber <= 0) {
    return false;
  }
  data[referenceNumberKey] = referenceNumber;
  //Below logic Fails in case of multiple issues
  if (!details.isAutoGenerated) {
    await updateEquipmentCurrentlyHavingIssueStatus(
        details.eqFirestoreId, true);
  }
  CollectionReference collRef =
      FirebaseFirestore.instance.collection(requestCollectionKey);
  return await collRef
      .doc(details.documentId)
      .set(data)
      .then((value) => true)
      .catchError((error) => false);
}

Future<bool> markAsIgnoredRequest(RequestDetails details) async {
  details.status = RequestStatus.ignored.toString();
  details.actions.add(
      '${currentUserDetails?.name} marked as ignored on ${DateTime.now().toString()}');
  details.serviceAdminCode = currentUserDetails?.code ?? "";
  var data = details.toSnapShot();
  data[updatedTimeKey] = FieldValue.serverTimestamp();
  //Fails in case of multiple issues
  //Below logic Fails in case of multiple issues
  if (!details.isAutoGenerated) {
    await updateEquipmentCurrentlyHavingIssueStatus(
        details.eqFirestoreId, false);
  }
  CollectionReference collRef =
      FirebaseFirestore.instance.collection(requestCollectionKey);
  return await collRef
      .doc(details.documentId)
      .update(data)
      .then((value) => true)
      .catchError((error) => false);
}

Future<bool> scheduleRequest(
    RequestDetails details, UserDetails engineer) async {
  details.status = RequestStatus.scheduled.toString();
  details.actions.add(
      '${currentUserDetails?.name} scheduled on ${getStringFromTimestamp(details.scheduledDateTime)} to Service Engineer ${engineer.name} on ${DateTime.now().toString()}');
  details.serviceEngineerCode = details.serviceEngineerCode ?? "";
  details.serviceAdminCode = currentUserDetails?.code ?? "";
  var data = details.toSnapShot();
  data[updatedTimeKey] = FieldValue.serverTimestamp();
  data[servicedDateKey] = FieldValue.serverTimestamp();
  CollectionReference collRef =
      FirebaseFirestore.instance.collection(requestCollectionKey);
  return await collRef
      .doc(details.documentId)
      .update(data)
      .then((value) => true)
      .catchError((error) => false);
}

Future<bool> SubmitDiagnosisForServiceRequest(RequestDetails details) async {
  var urls = await uploadFileAndGetDownloadUrls(
      details.servicePhotoPaths, serviceCollectionKey);
  details.servicePhotoUrls.addAll(urls);
  details.status = RequestStatus.diagonized.toString();
  details.actions.add(
      '${currentUserDetails?.name} submitted diagnosis report on ${DateTime.now().toString()}');
  var data = details.toSnapShot();
  data[updatedTimeKey] = FieldValue.serverTimestamp();
  data[servicedDateKey] = FieldValue.serverTimestamp();
//Below logic Fails in case of multiple issues
  if (!details.isAutoGenerated) {
    await updateEquipmentCurrentlyHavingIssueStatus(
        details.eqFirestoreId, !details.isIssueFixed);
  }
  CollectionReference collRef =
      FirebaseFirestore.instance.collection(requestCollectionKey);
  return await collRef
      .doc(details.documentId)
      .update(data)
      .then((value) => true)
      .catchError((error) => false);
}

Future<bool> ApproveDiagnosisOfServiceRequest(RequestDetails details) async {
  if (details.reportPdfPath != null &&
      details.reportPdfPath?.isNotEmpty == true) {
    var urls = await uploadFileAndGetDownloadUrls(
        [details.reportPdfPath!], serviceCollectionKey);
    details.reportPdfUrl = urls.first;
  }
  details.status = RequestStatus.completed.toString();
  details.actions.add(
      '${currentUserDetails?.name} Approved diagnosis report on ${DateTime.now().toString()}');
  var data = details.toSnapShot();
  data[updatedTimeKey] = FieldValue.serverTimestamp();
  WriteBatch batch = FirebaseFirestore.instance.batch();
  CollectionReference reqCollRef =
      FirebaseFirestore.instance.collection(requestCollectionKey);
  batch.update(reqCollRef.doc(details.documentId), data);
  var equDocId = details.equipment?.documentId ?? '';
  if (equDocId.isNotEmpty && details.isAutoGenerated) {
    CollectionReference equCollRef =
        FirebaseFirestore.instance.collection(equipmentCollectionKey);
    batch.update(equCollRef.doc(equDocId),
        {lastAutoCreatedServiceDiagnisedDateKey: FieldValue.serverTimestamp()});
  }

  await batch.commit();
  return true;
}

Future<RequestDetails> getRequestDetails(String requestDocId) async {
  var fireStore = FirebaseFirestore.instance;
  var collRef = fireStore.collection(requestCollectionKey).doc(requestDocId);
  var doc = await collRef.get();
  var item = RequestDetails.fromSnapshot(doc.data() as Map<String, dynamic>);
  return item;
}

Future<int> generateReferenceNumber(bool isIssue) async {
  // Create a reference to the document the transaction will use
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection(requestReferenceCountKey)
      .doc(requestReferenceCountKey);

  var referenceCount = 0;
  return FirebaseFirestore.instance
      .runTransaction((transaction) async {
        // Get the document
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (!snapshot.exists) {
          return -1;
        }
        var data = snapshot.data() as Map<String, dynamic>;
        var year = DateTime.now().year;
        var key = isIssue ? 'issues_$year' : 'maintenance_$year';
        referenceCount = data.containsKey(key) ? snapshot[key] : 0;
        referenceCount = referenceCount + 1;
        // var countString = referenceCount.toString();
        // if (referenceCount < 100) {
        //   countString =
        //       (referenceCount < 10) ? "00$referenceCount" : "0$referenceCount";
        // }
        // referenceNumberString =
        //     isIssue ? 'CP/$year/$countString' : 'PM/$year/$countString';
        // Perform an update on the document
        transaction.update(documentReference, {key: referenceCount});
      })
      .then((value) => referenceCount)
      .catchError((error) => 0);
}

Future<bool> deleteNonProcessedRequests() async {
  QuerySnapshot itemList = await FirebaseFirestore.instance
      .collection(requestCollectionKey)
      .where("status", isEqualTo: "RequestStatus.created")
      .get();
  itemList.docs.forEach((element) async {
    await element.reference.delete();
  });

  return true;
}
