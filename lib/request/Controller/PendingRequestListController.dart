import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../FirebaseManager/RequestManager.dart';
import '../Model/RequestDetails.dart';

class PendingRequestListController extends GetxController {
  var requests = <RequestDetails>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    getPendingRequests();
    super.onInit();
  }

  @override
  void onClose() {
    requests.close();
    isLoading.close();
    super.onClose();
  }

  Future<void> getPendingRequests() async {
    isLoading.value = true;
    requests.value = await getPendingRequestList();
    isLoading.value = false;
  }
}
