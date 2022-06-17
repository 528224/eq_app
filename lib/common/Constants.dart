//Enum constants

enum UserRoles {
  userManager,
  userAdmin,
  serviceEngineer,
  serviceAdmin,
  superAdmin,
  appleTester
}
enum RequestStatus { created, scheduled, diagonized, completed, ignored }
enum RequestType { issue, maintenance }

const String isDarkModeKey = 'isDarkMode';
const String userUUIDKey = 'userUUID';

//Firebase Keys
const String serialNumberKey = 'serialNumber';
const String documentIdKey = 'documentId';
const String uuidKey = 'uuid';
const String codeKey = 'code';
const String nameKey = 'name';
const String modelKey = 'model';
const String purchaseDateKey = 'purchaseDate';
const String titleKey = 'title';
const String descriptionKey = 'description';
const String detailsKey = 'details';
const String addressKey = 'address';
const String isIdleKey = 'isIdle';
const String isCurrentlyHavingIssueKey = 'isCurrentlyHavingIssue';
const String isHasPeriodicMaintenanceKey = 'hasPeriodicMaintenance';
const String scheduledDateTimeKey = 'scheduledDateTime';
const String serviceEngineerCommentKey = 'serviceEngineerComment';
const String issueFixedKey = 'isIssueFixed';
const String isAutoGeneratedKey = 'isAutoGenerated';
const String userManagerCodeKey = 'userManagerCode';
const String userManagerNameKey = 'userManagerName';
const String userAdminCodeKey = 'userAdminCode';
const String userAdminNameKey = 'userAdminName';
const String serviceEngineerCodeKey = 'serviceEngineerCode';
const String serviceEngineerNameKey = 'serviceEngineerName';
const String serviceEngineerPhoneNoKey = 'serviceEngineerPhoneNo';
const String serviceAdminCodeKey = 'serviceAdminCode';
const String photoUrlsKey = 'photoUrls';
const String equipmentKey = 'equipment';
const String warrantyPeriodInYearsKey = 'warrantyPeriodInYears';
const String scheduleMaintenancePeriodInDaysKey =
    'scheduleMaintenancePeriodInDays';
const String equipmentModelNumKey = 'eqModelNum';
const String equipmentSerialNumKey = 'eqSerialNum';
const String eqFirestoreIdKey = 'eqFirestoreId';
const String lastServiceDateKey = 'lastServiceDate';
const String lastAutoCreatedServiceDiagnisedDateKey =
    'lastAutoCreatedServiceDiagnisedDate';
const String nextServiceDateKey = 'nextServiceDate';

const String fcmTokenKey = 'fcmToken';
const String emailIdKey = 'email';
const String phoneNoKey = 'mobile';
const String authTokenKey = 'authToken';
const String userRoleKey = 'userRole';
const String platformKey = 'platform';
const String appVersionKey = 'appVersion';
const String updatedTimeKey = "updatedTime";

const String referenceNumberKey = 'referenceNumber';
const String statusKey = 'status';
const String createdDateKey = 'createdDate';
const String servicedDateKey = 'servicedDate';
const String requestPhotoUrlsKey = 'requestPhotoUrls';
const String reportPdfUrlKey = 'reportPdfUrlKey';
const String servicePhotoUrlsKey = 'servicePhotoUrls';
const String requestVideoUrlsKey = 'requestVideoUrls';
const String actionsKey = 'actions';

const String requestTypeKey = 'requestType';
const String markedAsDeletedKey = 'markedAsDeleted';

//Display String Constants
const String commonErrorMessage = 'Something went wrong. Try again later';
const String noDataMessage = 'No items available';
const String commonErrorMessgae = 'Something went wrong. Try again later';

const String CMachineName = 'Machine Name';
const String CModelNo = 'Model';
const String CSerialNo = 'Serial No';
const String CEquipmentDetails = 'Additional Details';
const String CAddress = 'Address';
const String CPurchasedDate = 'Purchased Date';
const String CLastPeriodicServiceDate = 'Last Periodic Service Date';
const String CWarrantyPeriodYears = 'Warranty Period in Years';
const String CHasPeriodicMaintenance = 'Has Periodic Maintenance';
const String CScheduledMaintenancePeriodDays =
    'Scheduled Maintenance Period in Days';
const String CDaysSinceLastScheduledMaintenance =
    'Days Since Last Scheduled Maintenance';

const String CAssignedUser = 'Assigned User';
const String CServiceEngineer = 'Service Engineer';
const String CUserAdmin = 'User Admin';

const String CTitle = 'Title';
const String CDescription = 'Description';
const String CEquipmentName = 'Equipment Name';
const String CCreatedDate = 'Registered On';
const String CStatus = 'Status';
const String CAutoGenerated = 'Request Type';
const String CIssueResolved = 'Issue Resolved';
const String CDiagnosisDetails = 'Diagnosis Details';
const String CScheduledDate = 'Scheduled For';
const String CServicedDate = 'Actual Serviced Date';
const String CDiagnosedDuration = 'Diagnosed Duration';

const defaultPadding = 16.0;

const requiredField = "This field is required";
