// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:servicetracker/common/CommonWidgets.dart';
// import 'package:servicetracker/common/Constants.dart';
// import 'package:servicetracker/request/Controller/PendingRequestListController.dart';
// import 'package:servicetracker/request/Model/RequestDetails.dart';
// import 'package:servicetracker/request/pending_requests/approve_service_widget.dart';
// import 'package:servicetracker/request/pending_requests/pending_request_list_widget.dart';
// import 'package:servicetracker/request/pending_requests/schedule_request_details_widget.dart';
// import 'package:servicetracker/request/pending_requests/submit_service_widget.dart';
// import 'package:syncfusion_flutter_calendar/calendar.dart';
//
// class RequestCalenderWidget extends StatelessWidget {
//   RequestCalenderWidget({Key? key, required this.title}) : super(key: key);
//   PendingRequestListController controller = Get.find();
//   final String title;
//
//   @override
//   Widget build(BuildContext context) {
//     return commonScaffold(
//       'Calender',
//       _cateFutureListData(),
//     );
//   }
//
//   _cateFutureListData() {
//     return Obx(() {
//       var items = controller.requests.value;
//       if (items.isNotEmpty) {
//         return _getCalenderView(items);
//       } else if (controller.isLoading.value) {
//         return getCommonProgressWidget();
//       } else {
//         return getNoDataWidget();
//       }
//     });
//   }
//
//   _getCalenderView(List<RequestDetails> items) {
//     return SfCalendar(
//       view: CalendarView.week,
//       // firstDayOfWeek: 6,
//       //initialDisplayDate: DateTime(2021, 03, 01, 08, 30),
//       //initialSelectedDate: DateTime(2021, 03, 01, 08, 30),
//       dataSource: MeetingDataSource(getAppointments(items)),
//       onTap: (CalendarTapDetails tapDetails) {
//         var appointments = tapDetails.appointments ?? List.empty();
//         if (appointments.isNotEmpty) {
//           var ids = appointments.map((e) => e.id).toList();
//           var selectedRequests = controller.requests.value
//               .where((element) => (ids.contains(element.documentId)))
//               .toList();
//           if (selectedRequests.length == 1) {
//             var request = selectedRequests.first;
//             _navigateToRequestDetails(request);
//           } else {
//             Get.to(() => PendingRequestListWidget(selectedRequests));
//           }
//         }
//       },
//     );
//   }
//
//   List<Appointment> getAppointments(List<RequestDetails> items) {
//     List<Appointment> meetings = <Appointment>[];
//
//     items.forEach((element) {
//       final startTime = _getCalenderStartDateForStatus(element);
//       if (startTime != null) {
//         final endTime = startTime.add(const Duration(hours: 2));
//         meetings.add(Appointment(
//             id: element.documentId,
//             startTime: startTime,
//             endTime: endTime,
//             subject: element.title,
//             color: _getColorForStatus(element),
//             // recurrenceRule: 'FREQ=DAILY;COUNT=10',
//             isAllDay: false));
//       }
//     });
//     return meetings;
//   }
//
//   _getCalenderStartDateForStatus(RequestDetails item) {
//     if (item.status == RequestStatus.created.toString()) {
//       return item.createdDate?.toDate();
//     } else if (item.status == RequestStatus.scheduled.toString()) {
//       return item.scheduledDateTime?.toDate();
//     } else if (item.status == RequestStatus.diagonized.toString()) {
//       return item.servicedDateTime?.toDate();
//     }
//   }
//
//   _getColorForStatus(RequestDetails item) {
//     if (item.status == RequestStatus.created.toString()) {
//       return Colors.yellow;
//     } else if (item.status == RequestStatus.scheduled.toString()) {
//       return Colors.blue;
//     } else if (item.status == RequestStatus.diagonized.toString()) {
//       return Colors.lightGreen;
//     }
//   }
//
//   _navigateToRequestDetails(RequestDetails item) {
//     if (item.status == RequestStatus.created.toString()) {
//       Get.to(() => ScheduleRequestWidget(item));
//     } else if (item.status == RequestStatus.scheduled.toString()) {
//       Get.to(() => SubmitServiceWidget(item));
//     } else if (item.status == RequestStatus.diagonized.toString()) {
//       Get.to(() => ApproveDiagnosisServiceWidget(item));
//     }
//   }
// }
//
// class MeetingDataSource extends CalendarDataSource {
//   MeetingDataSource(List<Appointment> source) {
//     appointments = source;
//   }
// }
