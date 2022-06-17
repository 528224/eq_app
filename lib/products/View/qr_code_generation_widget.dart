import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QRCodeGenerationWidget extends StatelessWidget {
  String data;

  QRCodeGenerationWidget(this.data);

  @override
  Widget build(BuildContext context) {
    ScreenshotController screenshotController = ScreenshotController();

    return SafeArea(
      child: Screenshot(
        controller: screenshotController,
        child: Scaffold(
          appBar: AppBar(
            title: Text(data),
            actions: [getShareWidget(screenshotController)],
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Center(
                child: QrImage(
                  data: data,
                  version: QrVersions.auto,
                  size: 320,
                  gapless: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getShareWidget(ScreenshotController screenshotController) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: InkWell(
          borderRadius: const BorderRadius.all(
            Radius.circular(22.0),
          ),
          onTap: () {
            captureScreenshotAndShare2(screenshotController);
          },
          child: Icon(Icons.share),
        ));
  }

  Future<void> captureScreenshotAndShare(
      ScreenshotController screenshotController) async {
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((Uint8List? image) async {
      if (image != null) {
        final directoryPath = GetPlatform.isAndroid
            ? (await getExternalStorageDirectory())?.path ?? ""
            : (await getApplicationDocumentsDirectory()).path;
        final imageFile = File('$directoryPath/image.png');

        await imageFile.writeAsBytes(image);

        /// Share Plugin
        await Share.shareFiles([imageFile.path]);
      }
    }).onError((error, stackTrace) {
      var e = error;
    });
  }

  Future<void> captureScreenshotAndShare2(
      ScreenshotController screenshotController) async {
    double pixelRatio = MediaQuery.of(Get.context!).devicePixelRatio;
    await screenshotController
        .capture(
            delay: const Duration(milliseconds: 10), pixelRatio: pixelRatio)
        .then((Uint8List? image) async {
      if (image != null) {
        // final directoryPath = GetPlatform.isAndroid
        //     ? (await getExternalStorageDirectory())?.path ?? ""
        //     : (await getApplicationDocumentsDirectory()).path;
        final directoryPath = (await getApplicationDocumentsDirectory()).path;
        final imagePath = await File('$directoryPath/image.png').create();
        await imagePath.writeAsBytes(image);

        /// Share Plugin
        await Share.shareFiles([imagePath.path]);
      }
    }).onError((error, stackTrace) {
      var e = error;
    });
  }
}
