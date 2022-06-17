import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/AppTheme.dart';
import '../../common/CommonWidgets.dart';
import '../../common/Constants.dart';
import '../../common/Extentions.dart';
import '../Controller/SubmitDiagnosisDetailsController.dart';
import '../Model/RequestDetails.dart';

class SubmitServiceWidget extends StatelessWidget {
  late RequestDetails details;

  SubmitServiceWidget(this.details);

  SubmitDiagnosisDetailsController controller =
      Get.put(SubmitDiagnosisDetailsController());

  @override
  Widget build(BuildContext context) {
    controller.details = details;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Submit Diagnose Details')),
        body: SingleChildScrollView(
          child: Container(
            child: Form(
              key: controller.requestFormKey,
              child: _getBody(),
            ),
          ),
        ),
      ),
    );
  }

  _getBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getCommonSectionHeaderWidget(details.title, Alignment.center),
        getCommonLabelWidget(details.getReferenceNumberText(), 'Ref.No'),
        getCommonLabelWidget(
            getStringFromTimestamp(details.scheduledDateTime), CScheduledDate),
        getCommonLabelWidget(details.equipment?.name, CEquipmentName),
        getCommonLabelWidget(details.getAutogeneratedText(), CAutoGenerated),
        getCommonLabelWidget(
            getStringFromTimestamp(details.createdDate), CCreatedDate),
        if (details.description.isNotEmpty == true)
          getCommonSectionWidget('Issue Details', details.description),
        if (details.requestPhotoUrls.isNotEmpty == true)
          getRemoteImageViewWidget(details.requestPhotoUrls.first),
        if (details.requestVideoUrls.isNotEmpty == true)
          getRemoteVideoWidget(details.requestVideoUrls.first),
        if (details.equipment?.address.isNotEmpty == true)
          getCommonSectionWidget(CAddress, details.equipment?.address ?? ""),
        getCommonSectionHeaderWidget(
            'Please Add Diagnosis Details', Alignment.center),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: TextFormField(
            controller: controller.serviceCommentController,
            decoration: textFieldDecoration(CDiagnosisDetails),
            validator: controller.validator,
            minLines: 1,
            maxLines: 5,
            maxLength: 500,
            autofocus: false,
          ),
        ),
        _getAddAndPreviewImageWidget(),
        if (!details.isAutoGenerated) _getIssueSolvedOrNotSelectionWidget(),
        const SizedBox(height: defaultPadding * 1),
        Container(
          child: Column(
            children: [
              getCommonBackgroundWidget(24.0),
              getCommonExpandedButton(
                  "Submit Diagnosis", controller.saveAction),
              getCommonBackgroundWidget(24.0),
            ],
          ),
        )
      ],
    );
  }

  _getAddAndPreviewImageWidget() {
    return Obx(() {
      return getCommonAddAndPreviewImageWidget(controller.image);
    });
  }

  _getIssueSolvedOrNotSelectionWidget() {
    return Obx(() {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Is Issue Resolved?',
              style: AppTextStyles().kTextStyleWithFont,
            ),
            CupertinoSwitch(
              value: controller.isIssueSolved.value,
              onChanged: (value) {
                controller.isIssueSolved.value = value;
              },
            ),
          ],
        ),
      );
    });
  }
}
