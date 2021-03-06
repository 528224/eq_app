import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/Constants.dart';
import '../../common/Extentions.dart';
import '../../products/Model/EquipmentDetails.dart';

class RequestDetails {
  String documentId = '';
  int referenceCount = 0;
  String requestType = '';
  String title = '';
  String description = '';
  String status = '';
  Timestamp? createdDate;
  String eqFirestoreId = '';
  EquipmentDetails? equipment;
  List<String> actions = [];
  String userManagerCode = '';
  String userAdminCode = '';
  String? serviceEngineerCode;
  String? serviceEngineerName;
  String? serviceEngineerPhoneNo;
  String serviceAdminCode = '';
  Timestamp? scheduledDateTime;
  Timestamp? servicedDateTime;
  Timestamp? updatedDateTime;
  String serviceEngineerComment = "";
  List<String> requestPhotoPaths = [];
  List<String> servicePhotoPaths = [];
  List<String> requestVideoPaths = [];
  String? reportPdfPath;
  List<String> requestPhotoUrls = [];
  List<String> servicePhotoUrls = [];
  List<String> requestVideoUrls = [];
  String? reportPdfUrl;
  bool isIssueFixed = false;
  bool isAutoGenerated = false;

  RequestDetails.fromSnapshot(Map<String, dynamic> snapshot) {
    documentId =
        snapshot.containsKey(documentIdKey) ? snapshot[documentIdKey] : '';
    referenceCount = snapshot.containsKey(referenceNumberKey)
        ? snapshot[referenceNumberKey]
        : 0;
    requestType =
        snapshot.containsKey(requestTypeKey) ? snapshot[requestTypeKey] : '';
    title = snapshot.containsKey(titleKey) ? snapshot[titleKey] : '';
    description =
        snapshot.containsKey(descriptionKey) ? snapshot[descriptionKey] : '';
    status = snapshot.containsKey(statusKey) ? snapshot[statusKey] : '';
    createdDate =
        snapshot.containsKey(createdDateKey) ? snapshot[createdDateKey] : null;
    eqFirestoreId = snapshot.containsKey(eqFirestoreIdKey)
        ? snapshot[eqFirestoreIdKey]
        : '';
    var equipmentDetails =
        snapshot.containsKey(equipmentKey) ? snapshot[equipmentKey] : null;
    if (equipmentDetails != null) {
      equipment = EquipmentDetails.fromSnapshot(equipmentDetails);
    }
    if (snapshot.containsKey(actionsKey)) {
      actions = List<String>.from(snapshot[actionsKey]);
    } else {
      actions = List.empty();
    }
    if (snapshot.containsKey(requestPhotoUrlsKey)) {
      requestPhotoUrls = List<String>.from(snapshot[requestPhotoUrlsKey]);
    } else {
      requestPhotoUrls = List.empty();
    }
    if (snapshot.containsKey(servicePhotoUrlsKey)) {
      servicePhotoUrls = List<String>.from(snapshot[servicePhotoUrlsKey]);
    } else {
      servicePhotoUrls = List.empty();
    }
    if (snapshot.containsKey(requestVideoUrlsKey)) {
      requestVideoUrls = List<String>.from(snapshot[requestVideoUrlsKey]);
    } else {
      requestVideoUrls = List.empty();
    }

    reportPdfUrl = snapshot.containsKey(reportPdfUrlKey)
        ? snapshot[reportPdfUrlKey]
        : null;

    scheduledDateTime = snapshot.containsKey(scheduledDateTimeKey)
        ? snapshot[scheduledDateTimeKey]
        : null;

    servicedDateTime = snapshot.containsKey(servicedDateKey)
        ? snapshot[servicedDateKey]
        : null;

    updatedDateTime =
        snapshot.containsKey(updatedTimeKey) ? snapshot[updatedTimeKey] : null;

    serviceEngineerComment = snapshot.containsKey(serviceEngineerCommentKey)
        ? snapshot[serviceEngineerCommentKey]
        : '';
    userManagerCode = snapshot.containsKey(userManagerCodeKey)
        ? snapshot[userManagerCodeKey]
        : '';
    userAdminCode = snapshot.containsKey(userAdminCodeKey)
        ? snapshot[userAdminCodeKey]
        : '';
    serviceEngineerCode = snapshot.containsKey(serviceEngineerCodeKey)
        ? snapshot[serviceEngineerCodeKey]
        : '';
    serviceEngineerName = snapshot.containsKey(serviceEngineerNameKey)
        ? snapshot[serviceEngineerNameKey]
        : '';
    serviceEngineerPhoneNo = snapshot.containsKey(serviceEngineerPhoneNoKey)
        ? snapshot[serviceEngineerPhoneNoKey]
        : '';
    serviceAdminCode = snapshot.containsKey(serviceAdminCodeKey)
        ? snapshot[serviceAdminCodeKey]
        : '';
    isIssueFixed =
        snapshot.containsKey(issueFixedKey) ? snapshot[issueFixedKey] : false;
    isAutoGenerated = snapshot.containsKey(isAutoGeneratedKey)
        ? snapshot[isAutoGeneratedKey]
        : false;
  }

  String getStatusText() {
    if (status == RequestStatus.created.toString()) {
      return isAutoGenerated
          ? 'Registered Periodic Maintenance'
          : 'Reported: ${title}';
    } else if (status == RequestStatus.scheduled.toString()) {
      return 'Scheduled Visit for ${getStringFromTimestamp(scheduledDateTime)}';
    } else if (status == RequestStatus.diagonized.toString()) {
      return 'Diagnosed: ${title}';
    } else if (status == RequestStatus.completed.toString()) {
      return isIssueFixed ? 'Resolved: ${title}' : 'Not Resoled: ${title}';
    } else if (status == RequestStatus.ignored.toString()) {
      return 'Marked as Ignored';
    } else {
      return '_';
    }
  }

  String getShortStatusText() {
    if (status == RequestStatus.created.toString()) {
      return isAutoGenerated ? 'Maintenance Required' : 'Issue Reported';
    } else if (status == RequestStatus.scheduled.toString()) {
      return 'Scheduled Site Visit';
    } else if (status == RequestStatus.diagonized.toString()) {
      return isAutoGenerated ? 'Maintenance Done' : 'Issue Diagnosed';
    } else if (status == RequestStatus.completed.toString()) {
      return isAutoGenerated
          ? 'Maintenance Done'
          : (isIssueFixed ? 'Issue Resolved' : 'Issue Not Resoled');
    } else if (status == RequestStatus.ignored.toString()) {
      return 'Marked As Ignored';
    } else {
      return '_';
    }
  }

  Timestamp getUpdatedTimeStamp() {
    Timestamp? updatedTime;
    if (status == RequestStatus.created.toString()) {
      updatedTime = createdDate;
    } else if (status == RequestStatus.scheduled.toString()) {
      updatedTime = scheduledDateTime;
    } else if (status == RequestStatus.diagonized.toString()) {
      updatedTime = servicedDateTime;
    } else if (status == RequestStatus.completed.toString()) {
      updatedTime = servicedDateTime;
    } else if (status == RequestStatus.ignored.toString()) {
      updatedTime = createdDate;
    } else {
      updatedTime = createdDate;
    }
    return updatedTime ?? Timestamp.fromDate(DateTime.now());
  }

  String getAutogeneratedText() {
    return isAutoGenerated ? "Scheduled Maintenance" : "Equipment Issue";
  }

  String getResolvedStatus() {
    return isIssueFixed
        ? (isAutoGenerated
            ? 'Completed Periodic Maintenance'
            : 'Diagnosed and Resoled the issue')
        : "Diagnosed but not resolved";
  }

  String getReferenceNumberText() {
    var year = createdDate?.toDate().year;
    var countString = referenceCount.toString();
    if (referenceCount < 100) {
      countString =
          (referenceCount < 10) ? "00$referenceCount" : "0$referenceCount";
    }
    return isAutoGenerated ? 'PM/$year/$countString' : 'CP/$year/$countString';
  }

  Map<String, dynamic> toSnapShot() {
    return {
      documentIdKey: documentId,
      referenceNumberKey: referenceCount,
      requestTypeKey: requestType,
      titleKey: title,
      descriptionKey: description,
      statusKey: status,
      eqFirestoreIdKey: eqFirestoreId,
      equipmentKey: equipment?.toSnapShot(),
      actionsKey: actions,
      userManagerCodeKey: userManagerCode,
      userAdminCodeKey: userAdminCode,
      serviceEngineerCodeKey: serviceEngineerCode,
      serviceEngineerNameKey: serviceEngineerName,
      serviceEngineerPhoneNoKey: serviceEngineerPhoneNo,
      serviceAdminCodeKey: serviceAdminCode,
      requestPhotoUrlsKey: requestPhotoUrls,
      servicePhotoUrlsKey: servicePhotoUrls,
      requestVideoUrlsKey: requestVideoUrls,
      reportPdfUrlKey: reportPdfUrl,
      servicedDateKey: servicedDateTime,
      scheduledDateTimeKey: scheduledDateTime,
      serviceEngineerCommentKey: serviceEngineerComment,
      issueFixedKey: isIssueFixed,
      isAutoGeneratedKey: isAutoGenerated,
    };
  }

  RequestDetails() {}
}
