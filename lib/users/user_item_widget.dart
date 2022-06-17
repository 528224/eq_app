import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/CommonWidgets.dart';
import '../common/DataClasses.dart';

class UserItemWidget extends StatelessWidget {
  late UserDetails userDetails;

  UserItemWidget(this.userDetails);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            getCommonLabelWidget(userDetails.name, 'Name'),
            getCommonLabelWidget(userDetails.userRole, 'Role'),
            getCommonLabelWidget(userDetails.phoneNo, 'Mobile'),
            getCommonLabelWidget(userDetails.emailId, 'Email'),
            // getCommonExpandedTextButton('Edit', () {
            //   Get.to(() => AddEditUserScreen(userDetails));
            // }),
          ],
        ),
      ),
    );
  }
}
