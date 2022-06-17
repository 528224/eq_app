import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../FirebaseManager/UserManager.dart';
import '../Login/new_login_screen.dart';
import '../main.dart';
import 'AppTheme.dart';
import 'Constants.dart';
import 'Extentions.dart';

Widget getCommonErrorWidget() {
  return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
          child: Text(commonErrorMessage,
              style: AppTextStyles().kTextStyleWithFont)));
}

Widget getCommonProgressWidget() {
  return Center(child: CircularProgressIndicator());
}

Widget getNoDataWidget() {
  return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
          child:
              Text(noDataMessage, style: AppTextStyles().kTextStyleWithFont)));
}

Widget screenTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget getCommonLabelWidgetOld(String? value, String? name) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$name',
          style: AppTextStyles().kTextStyleWithFont, //TODO try dim color
        ),
        Text('$value', style: AppTextStyles().kTextStyleWithFont),
      ],
    ),
  );
}

Widget getCommonLabelWidget(String? value, String name) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 8,
        ),
        Text(
          '$name',
          style: AppTextStyles().kTextStyleSixteenBoldWithThemeColor,
        ),
        const SizedBox(
          height: 4,
        ),
        Text('${value ?? "Not Available"}',
            style: AppTextStyles().kTextStyleFourteenWithThemeColor),
        const SizedBox(
          height: 8,
        ),
      ],
    ),
  );
}
// List<Widget> getCommonLabelWidgetNew(String value, String name,
//     [double padding = 12.0]) {
//   var verticalPadding = 4.0;
//   return [
//     Padding(
//       padding:
//           EdgeInsets.symmetric(vertical: verticalPadding, horizontal: padding),
//       child: Text(
//         '$name',
//         style: AppTextStyles().kTextStyleEighteenBoldWithThemeColor,
//       ),
//     ),
//     Padding(
//       padding:
//           EdgeInsets.symmetric(vertical: verticalPadding, horizontal: padding),
//       child: Text('$value',
//           style: AppTextStyles().kTextStyleFourteenWithGreyColor),
//     ),
//   ];
// }

Widget getCommonListItemLabelWidget(String? value, String? name) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$name',
          style: AppTextStyles().kTextStyleWithFont, //TODO try different color
        ),
        Text(
          '$value',
          style: AppTextStyles().kTextStyleWithFont,
        ),
      ],
    ),
  );
}

Widget getCommonBackgroundWidget(double height) {
  return SizedBox(height: height);

  // return Container(
  //   height: height,
  //   color: Get.theme.backgroundColor,
  // );
}

Widget getCommonSectionWidget(String sectionTitle, String description) {
  return Padding(
    padding: EdgeInsets.all(12),
    child: Column(
      children: [
        Align(
          child: Text(sectionTitle,
              style: AppTextStyles().kTextStyleEighteenBoldWithThemeColor),
          alignment: Alignment.centerLeft,
        ),
        const SizedBox(
          height: 8,
        ),
        Align(
          child: Text(
            description,
            style: AppTextStyles().kTextStyleWithFont,
          ),
          alignment: Alignment.centerLeft,
        )
      ],
    ),
  );
}

Widget getCommonSectionHeaderWidget(String name, AlignmentGeometry alignment) {
  return Padding(
    padding: EdgeInsets.all(12),
    child: Align(
      child: Text(
        name,
        style: AppTextStyles().kTextStyleEighteenBoldWithThemeColor,
      ),
      alignment: alignment,
    ),
  );
}

Widget getCommonListItemSectionHeaderWidget(
    String name, AlignmentGeometry alignment) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
    child: Align(
      child: Text(
        name,
        style: AppTextStyles().kTextStyleEighteenBoldWithThemeColor,
      ),
      alignment: alignment,
    ),
  );
}

Widget getCommonAddAndPreviewImageWidget(Rx<XFile> imageFileRx,
    [String remoteUrl = '']) {
  var imagePath = imageFileRx.value.path;
  if (imagePath.isEmpty && remoteUrl.isEmpty) {
    return _getImageSelectButton(imageFileRx);
  } else {
    return _getImagePreviewSection(imageFileRx, remoteUrl);
  }
}

_getImageSelectButton(Rx<XFile> imageFileRx) {
  return TextButton(
      onPressed: () {
        selectImage(imageFileRx);
      },
      child:
          Text('Tap to add image', style: AppTextStyles().kTextStyleWithFont));
}

_getImagePreviewSection(Rx<XFile> imageFileRx, [String remoteUrl = '']) {
  var imagePath = imageFileRx.value.path;
  return ListTile(
    leading: Hero(
      tag: imagePath.isNotEmpty ? imageFileRx.value.name : remoteUrl,
      child: imagePath.isNotEmpty
          ? Image.file(File(imagePath))
          : getRemoteImageViewWidget(remoteUrl),
    ),
    onTap: () {
      Get.to(() => ImageFullScreenWidget(imagePath));
    },
    trailing: _getFileCloseButton(imageFileRx),
  );
}

selectImage(Rx<XFile> imageFileRx, [bool isFromCamera = false]) async {
  final ImagePicker _picker = ImagePicker();
  // // Pick an image
  XFile? selectedImage = await _picker.pickImage(
    source: isFromCamera ? ImageSource.camera : ImageSource.gallery,
    maxWidth: 500,
    maxHeight: 1000,
    imageQuality: 70,
  );
  if (selectedImage != null) {
    imageFileRx.value = selectedImage;
  }
  // // Capture a photo
  // final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
  // Pick multiple images
  // final List<XFile>? images = await _picker.pickMultiImage();
}

getRemoteImageViewWidget(String? url) {
  if (url == null || url.isEmpty)
    return Text('No Image Available',
        style: AppTextStyles().kTextStyleWithFont);
  return CachedNetworkImage(
      imageUrl: url,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(value: downloadProgress.progress),
          ),
      errorWidget: (context, url, error) => Icon(Icons.error));
}

Widget getCommonAddAndPreviewVideoWidget(Rx<XFile> fileRx,
    [String remoteUrl = '']) {
  var filePath = fileRx.value.path;
  if (filePath.isEmpty && remoteUrl.isEmpty) {
    return _getVideoSelectButton(fileRx, true);
  } else {
    return getVideoPreviewSection(fileRx, remoteUrl);
  }
}

_getVideoSelectButton(Rx<XFile> fileRx, bool isFromCamera) {
  return TextButton(
      onPressed: () {
        captureVideo(fileRx, isFromCamera);
      },
      child:
          Text('Tap to add video', style: AppTextStyles().kTextStyleWithFont));
}

getVideoPreviewSection(Rx<XFile> fileRx, [String remoteUrl = '']) {
  return ListTile(
    leading: Hero(
      tag: fileRx.value.name,
      child: Icon(
        Icons.video_call,
        color: Colors.black,
        size: 30.0,
      ),
    ),
    onTap: () {
      //Play video
      Get.to(() => AssetVideoWidget(remoteUrl, fileRx.value));
    },
    trailing: _getFileCloseButton(fileRx),
  );
}

_getFileCloseButton(Rx<XFile> imageFileRx) {
  return IconButton(
    icon: Icon(Icons.close, color: Colors.black),
    onPressed: () {
      imageFileRx.value = XFile("");
    },
  );
}

captureVideo(Rx<XFile> fileRx, bool isFromCamera,
    [bool isRearCamera = true]) async {
  final ImagePicker _picker = ImagePicker();
  XFile? file = await _picker.pickVideo(
    source: isFromCamera ? ImageSource.camera : ImageSource.gallery,
    preferredCameraDevice:
        isRearCamera ? CameraDevice.rear : CameraDevice.front,
    maxDuration: Duration(minutes: 1),
  );
  if (file != null) {
    fileRx.value = file;
  }
}

class ImageFullScreenWidget extends StatelessWidget {
  ImageFullScreenWidget(this.imagePath, [this.isRemote = true]);

  String imagePath;
  bool isRemote;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Fullscreen'),
      ),
      body: Center(
        child: Hero(
          tag: imagePath,
          child: isRemote
              ? CachedNetworkImage(
                  imageUrl: imagePath,
                )
              : Image.file(File(imagePath)),
        ),
      ),
    );
  }
}

// class PDFFullScreenWidget extends StatelessWidget {
//   PDFFullScreenWidget(this.title, this.url);
//
//   String url;
//   String title;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Center(
//         child: SfPdfViewer.network(url),
//       ),
//     );
//   }
// }

Widget getCommonRemoteImageWidget(String? url, String title) {
  return Padding(
    padding: EdgeInsets.only(top: 16, bottom: 16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getRemoteImageViewWidget(url),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Center(
            child: Text(title, style: AppTextStyles().kTextStyleWithFont),
          ),
        ),
      ],
    ),
  );
}

Widget getCommonRemoteVideoWidget(String? url, String title) {
  return Padding(
    padding: EdgeInsets.only(top: 16, bottom: 16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        getRemoteVideoWidget(url),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Center(
            child: Text(title, style: AppTextStyles().kTextStyleWithFont),
          ),
        ),
      ],
    ),
  );
}

getRemoteVideoWidget(String? url) {
  if (url == null || url.isEmpty)
    return Text('No Video Available',
        style: AppTextStyles().kTextStyleWithFont);

  //TODO better preview
  return ListTile(
      leading: Hero(
        tag: url,
        child: Icon(
          Icons.video_call,
          color: Colors.black,
          size: 30.0,
        ),
      ),
      onTap: () {
        Get.to(() => AssetVideoWidget(url, XFile("")));
      });

  // var _controller = VideoPlayerController.network(
  //     // url,
  //     "https://firebasestorage.googleapis.com/v0/b/service-tracker-application.appspot.com/o/requestVideos%2Fbde310d0-72b3-11ec-a387-6bd783d548fe.png?alt=media&token=2234d4ce-5421-4583-889c-8e28c9de3008.mp4");
  //
  // return VideoPlayer(_controller);
}

/// Using this widget is not necessary to hide children. The simplest way to
/// hide a child is just to not include it, or, if a child _must_ be given (e.g.
/// because the parent is a [StatelessWidget]) then to use [SizedBox.shrink]
/// instead of the child that would otherwise be included.
Widget getCommonBoxWidget(double width, double height) {
  return SizedBox(
    width: width,
    height: height,
  );
}

Widget getImageIconWidget(String imageUrl) {
  return Image.network(imageUrl, fit: BoxFit.fitWidth);
}

Widget getDefaultImageIconWidget() {
  return FlutterLogo();
}

Widget getCommonSaveAndCancelButtons(
    String saveTitle, VoidCallback saveAction) {
  return Padding(
    padding: EdgeInsets.only(left: 12, right: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            child: Text("Cancel", style: AppTextStyles().kTextStyleWithFont),
            onPressed: () => Get.back(),
          ),
        ),
        const SizedBox(width: defaultPadding * 1),
        Expanded(
          child: ElevatedButton(
            child: Text(saveTitle, style: AppTextStyles().kTextStyleWithFont),
            onPressed: saveAction,
          ),
        ),
      ],
    ),
  );
}

Widget getCommonExpandedButton(String title, VoidCallback onPressed,
    [bool isElevated = true]) {
  return getCommonElevatedButton(title, onPressed);
}

Widget getCommonElevatedButton(String title, VoidCallback onPressed) {
  return Padding(
    padding: EdgeInsets.only(left: 16, right: 16),
    child: ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: Get.width),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: AppTextStyles().kTextStyleWithFont,
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            elevation: 10,
            padding: EdgeInsets.all(14)),
      ),
    ),
  );
}

Widget getCommonExpandedTextButton(String title, VoidCallback onPressed) {
  return getCommonElevatedButton(title, onPressed);
}

Widget getCommonBackActionButton(String title) {
  return getCommonElevatedButton(title, () => Get.back());
}

Widget getCommonDateSelectionPicker(
    PrimitiveWrapper primitiveWrapper, String dateLabel, bool isDateOnly) {
  var initialDate = primitiveWrapper.value.isNotEmpty
      ? getTimestampFromString(primitiveWrapper.value)?.toDate() ??
          DateTime.now()
      : DateTime.now();
  if (initialDate.weekday == 6) {
    initialDate = initialDate.add(Duration(days: 2));
  } else if (initialDate.weekday == 7) {
    initialDate = initialDate.add(Duration(days: 1));
  }
  // var initialValue = DateTime.now().toString();
  var initialValue = initialDate.toString();

  primitiveWrapper.value = initialValue;
  return Padding(
    padding: EdgeInsets.only(left: 8, right: 8),
    child: DateTimePicker(
      type: isDateOnly
          ? DateTimePickerType.date
          : DateTimePickerType.dateTimeSeparate,
      dateMask: 'd MMM, yyyy',
      initialValue: initialValue,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      icon: Icon(Icons.event),
      dateLabelText: dateLabel,
      timeLabelText: 'Time',
      selectableDayPredicate: (date) {
        // Disable weekend days to select from the calendar
        if (date.weekday == 6 || date.weekday == 7) {
          return false;
        }
        return true;
      },
      onChanged: (val) {
        primitiveWrapper.value = val;
      },
      validator: (val) {
        print(val);
        return null;
      },
      onSaved: (val) {
        primitiveWrapper.value = val ?? "";
      },
    ),
  );
}

class PrimitiveWrapper {
  String value;

  PrimitiveWrapper(this.value);
}

Widget getCommonNumberInputFieldWidget(String title,
    TextEditingController controller, FormFieldValidator<String>? validator) {
  return TextFormField(
    controller: controller,
    decoration: textFieldDecoration(title),
    validator: validator,
    minLines: 1,
    maxLines: 1,
    maxLength: 5,
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  );
}

String? emptyCheckValidator(String? value) {
  bool isNullOrBlank = value?.isBlank ?? true;
  if (isNullOrBlank) {
    return requiredField;
  }
  return null;
}

Widget getCommonAddAndPreviewPdfWidget(Rx<XFile> fileRx) {
  var filePath = fileRx.value.path;
  if (filePath.isEmpty) {
    return _getFileSelectButton(fileRx);
  } else {
    return _getFilePreviewSection(fileRx);
  }
}

_getFileSelectButton(Rx<XFile> fileRx) {
  return TextButton(
      onPressed: () {
        _selectFile(fileRx);
      },
      child: Text('Tap to add report pdf',
          style: AppTextStyles().kTextStyleWithFont));
}

_getFilePreviewSection(Rx<XFile> fileRx) {
  var filePath = fileRx.value.path;
  return ListTile(
    leading: Hero(
      tag: fileRx.value.name,
      child: Icon(
        Icons.picture_as_pdf,
        color: Colors.black,
        size: 30.0,
      ),
    ),
    onTap: () async {
      final Uri _url = Uri.parse(filePath);
      if (!await launchUrl(_url)) throw 'Could not launch $_url';
      // OpenFile.open(filePath);//TODO Verify
    },
    trailing: _getFileCloseButton(fileRx),
  );
}

_selectFile(Rx<XFile> fileRx) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    PlatformFile file = result.files.first;

    print(file.name);
    print(file.bytes);
    print(file.size);
    print(file.extension);
    print(file.path);
    fileRx.value = XFile(file.path ?? "");
  } else {
    fileRx.value = XFile("");
    // User canceled the picker
  }
}

getCommonRemotePdfFilePreviewSection(String name, String url) {
  return ListTile(
    title: Text(
      name,
      // style: AppTextStyles().kTextStyleWithFont,
      style: TextStyle(
//creates underlined text.
          decoration: TextDecoration.underline,
          color: Colors.red),
    ),
    trailing: Hero(
      tag: name,
      child: Icon(
        Icons.picture_as_pdf,
        color: Colors.black,
        size: 30.0,
      ),
    ),
    onTap: () async {
      final Uri _url = Uri.parse(url);
      if (!await launchUrl(_url)) throw 'Could not launch $_url';
      // launch(url); //For having download option
      //Get.to(() => PDFFullScreenWidget(name, url));
    },
  );
}

Widget getImageWidget(String url, String defaultImage) {
  return (url.isNotEmpty)
      ? CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: url,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                child:
                    CircularProgressIndicator(value: downloadProgress.progress),
              ),
          errorWidget: (context, url, error) => Icon(Icons.error))
      : Image.asset(
          defaultImage,
          fit: BoxFit.cover,
        );
}

Widget commonScaffold(String title, Widget body,
    [Widget? floatingButton = null]) {
  return Scaffold(
    appBar: AppBar(
      title: screenTitle(title),
      centerTitle: true,
      actions: [logoutIconButton()],
    ),
    body: Container(child: body),
    floatingActionButton: floatingButton,
  );
}

Widget logoutIconButton() {
  return IconButton(
    icon: const Icon(Icons.logout),
    tooltip: 'Logout',
    onPressed: () async {
      logoutButtonAction();
    },
  );
}

logoutButtonAction() {
  Get.defaultDialog(
    textCancel: "NO",
    textConfirm: "YES",
    title: "Logout",
    content: Text(
      "Are you sure you want to log out?",
      style: AppTextStyles().kTextStyleWithFont,
    ),
    onCancel: () {},
    onConfirm: () async {
      await _logoutAction();
    },
  );
}

_logoutAction() async {
  await FirebaseAuth.instance.signOut();
  var docId = currentUserDetails?.firestoreId;
  if (docId != null) updateUserDetailsForLogout(docId);
  currentUserDetails = null;
  currentFirebaseAuthUser = null;
  Get.offAll(() => NewLoginScreen());
}

Widget FloatingAddIconButton(VoidCallback addAction, [String? heroTag]) {
  return FloatingActionButton(
    onPressed: addAction,
    tooltip: 'Add',
    heroTag: heroTag ?? 'Add Request',
    child: new Icon(Icons.add),
    elevation: 4.0,
  );
}

InputDecoration textFieldDecoration(String hintText, [String? labelText]) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: AppTextStyles().kTextStyleWithFont,
    labelText: labelText ?? hintText,
    labelStyle: AppTextStyles().kTextStyleWithFont,
    //prefixIcon: Icon(Icons.phone),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    isDense: true,
    errorStyle: AppTextStyles().kTextStyleWithFont,
  );
}

Widget getThemeSwitchIcon(void Function() changeTheme) {
  return IconButton(
    onPressed: changeTheme,
    icon: Icon(
      Get.isDarkMode ? Icons.light : Icons.dark_mode,
      color: Get.isDarkMode ? Colors.white : Colors.black,
    ),
  );
}

showCustomSnackBar(String title, String message, [bool isError = true]) {
  Get.snackbar(
    title,
    message,
    duration: Duration(seconds: isError ? 5 : 2),
    backgroundColor:
        Get.isDarkMode ? Colors.blueAccent : Colors.deepPurpleAccent,
    titleText: Text(
      title,
      style: AppTextStyles().kTextStyleWithFont,
    ),
    messageText: Text(
      message,
      style: AppTextStyles().kTextStyleWithFont,
    ),
  );
}

class ProfileImageWidgetOld extends StatelessWidget {
  final String imagePath;
  final String defaultImage;
  final bool isEdit;
  final bool isRemote;
  final VoidCallback onEditClicked;

  const ProfileImageWidgetOld({
    Key? key,
    required this.imagePath,
    this.defaultImage = "assets/images/placeholder-profile-pic.png",
    this.isEdit = false,
    this.isRemote = true,
    required this.onEditClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = imagePath.isEmpty
        ? AssetImage(defaultImage)
        : isRemote
            ? NetworkImage(imagePath)
            : Image.file(File(imagePath)).image;
    return Hero(
      tag: imagePath,
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: image,
            fit: BoxFit.cover,
            width: 128,
            height: 128,
            child: InkWell(onTap: () {
              Get.to(() => ImageFullScreenWidget(imagePath, isRemote));
            }),
          ),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => GestureDetector(
        onTap: onEditClicked,
        child: buildCircle(
          color: Colors.white,
          all: 3,
          child: buildCircle(
            color: color,
            all: 8,
            child: Icon(
              isEdit ? Icons.add_a_photo : Icons.edit,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}

class ProfileImageWidget extends StatelessWidget {
  final String overlayText;
  final String imagePath;
  final bool isEdit;
  final bool isRemote;
  final VoidCallback onEditClicked;

  const ProfileImageWidget({
    Key? key,
    required this.imagePath,
    this.overlayText = "",
    this.isEdit = false,
    this.isRemote = true,
    required this.onEditClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Text(
              overlayText,
              // style: AppTextStyles().kTextStyleTwentyBoldWithWhiteColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    if (isRemote && !imagePath.isEmpty) {
      return getRemoteImageViewWidget(imagePath);
    }

    var defaultImage = "assets/images/placeholder-profile-pic.png";
    final image = imagePath.isEmpty
        ? AssetImage(defaultImage)
        : Image.file(File(imagePath)).image;
    return Material(
      color: Colors.transparent,
      child: Ink.image(
        image: image,
        fit: BoxFit.cover,
        width: Get.width,
        height: 300,
      ),
    );
  }

  Widget buildEditIcon(Color color) => GestureDetector(
        onTap: onEditClicked,
        child: buildCircle(
          color: Colors.white,
          all: 3,
          child: buildCircle(
            color: color,
            all: 8,
            child: Icon(
              isEdit ? Icons.add_a_photo : Icons.edit,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}

class AssetVideoWidget extends StatefulWidget {
  @override
  AssetVideoWidgetState createState() => AssetVideoWidgetState();
  String url = "";
  XFile file = XFile("");
  AssetVideoWidget(this.url, this.file);
}

class AssetVideoWidgetState extends State<AssetVideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    File file = File(widget.file.path);
    _controller = widget.file.path.isEmpty
        ? VideoPlayerController.network(widget.url)
        : VideoPlayerController.file(file);

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //https://stackoverflow.com/questions/49340116/setstate-called-after-dispose/53815277
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  VideoPlayer(_controller),
                  VideoProgressIndicator(_controller, allowScrubbing: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
