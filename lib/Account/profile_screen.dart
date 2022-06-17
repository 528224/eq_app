import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../FirebaseManager/UserManager.dart';
import '../common/CommonWidgets.dart';
import '../common/Constants.dart';
import '../common/DataClasses.dart';
import '../common/globalFunctions.dart';
import '../main.dart';
import '../users/user_list_widget.dart';
import 'edit_profile_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getBody());
  }

  Widget getBody() {
    return Obx(() {
      var user = controller.userDetails.value;
      return ListView(
        physics: BouncingScrollPhysics(),
        children: [
          buildProfileImageWidget(user),
          // const SizedBox(height: 24),
          // Center(child: buildName(user)),
          // const SizedBox(height: 48),
          // NumbersWidget(),
          const SizedBox(height: 16),
          getCommonLabelWidget(user.phoneNo, 'Mobile'),
          const SizedBox(height: 16),
          getCommonLabelWidget(user.emailId, 'Email'),
          const SizedBox(height: 16),
          if (currentUserDetails?.userRole != UserRoles.appleTester.toString())
            getCommonLabelWidget(user.getRoleText(), 'Privilege'),
          const SizedBox(height: 40),
          if (currentUserDetails?.userRole == UserRoles.superAdmin.toString())
            getCommonExpandedButton('Manage Users', () {
              Get.to(() => UserListWidget());
            }),
          if (currentUserDetails?.userRole == UserRoles.superAdmin.toString())
            const SizedBox(height: 48),
          buildButtons(),
          const SizedBox(height: 48),
          // buildAbout(user),
        ],
      );
    });
  }

  Widget buildProfileImageWidget(UserDetails user) {
    var imagePath = "";
    if (user.photoUrls.isNotEmpty == true) {
      imagePath = user.photoUrls[0];
    }
    return ProfileImageWidget(
      imagePath: imagePath,
      overlayText: user.name,
      onEditClicked: () {
        Get.to(() => EditProfilePage());
      },
    );
  }

  Widget buildName(UserDetails? user) => Text(
        user?.name ?? "",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      );

  Widget buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 12),
          Expanded(
              child: buildButton('Logout', () {
            logoutButtonAction();
          })),
          const SizedBox(width: defaultPadding * 1),
          Expanded(
              child: buildButton('Switch Theme', () {
            switchTheme();
          })),
          const SizedBox(width: 12),
        ],
      );

  Widget buildButton(String title, VoidCallback onPressed) => ButtonWidget(
        text: title,
        onClicked: onPressed,
      );

  Widget buildAbout(UserDetails? user) => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '',
              style: TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: StadiumBorder(),
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: Text(text),
        onPressed: onClicked,
      );
}

class NumbersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, currentUserDetails?.phoneNo ?? "", 'Phone'),
          buildDivider(),
          buildButton(context, currentUserDetails?.emailId ?? "", 'Email'),
          buildDivider(),
          if (currentUserDetails?.userRole != UserRoles.appleTester.toString())
            buildButton(
                context, currentUserDetails?.getRoleText() ?? "", 'Privilege'),
          // buildButton(context, '4.8', 'Ranking'),
          // buildDivider(),
          // buildButton(context, '35', 'Following'),
          // buildDivider(),
          // buildButton(context, '50', 'Followers'),
        ],
      );

  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {},
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
}

class ProfileController extends GetxController {
  final requestFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  var image = XFile("").obs;

  var userDetails = currentUserDetails!.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    image.close();

    super.onClose();
  }

  String? validator(String? value) {
    bool isNullOrBlank = value?.isBlank ?? true;
    if (isNullOrBlank) {
      return 'Please this field must be filled';
    }
    return null;
  }

  updateControllers() {
    var user = currentUserDetails;
    nameController.text = user?.name ?? "";
    emailController.text = user?.emailId ?? "";
    mobileController.text = user?.phoneNo ?? "";
  }

  Future<void> updateProfileAction() async {
    await Get.showOverlay<void>(
        asyncFunction: () async {
          if (requestFormKey.currentState!.validate()) {
            var details = currentUserDetails;
            if (details == null) return;
            details.name = nameController.text;
            details.emailId = emailController.text;
            details.phoneNo = mobileController.text;
            if (image.value.path.isNotEmpty) {
              details.photoPaths = [image.value.path];
            }
            var submitted = await updateUserDetails(details);
            if (submitted) {
              await fetchAndUpdateUserDetailsIfUserExist(details.phoneNo);
              userDetails.value = currentUserDetails!;
              Get.back();
            } else {
              showCustomSnackBar('Failed', 'Failed to Update details');
            }
          }
        },
        loadingWidget: getCommonProgressWidget(),
        opacity: 0.7);
  }
}
