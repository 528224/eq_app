import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../FirebaseManager/UserManager.dart';
import '../common/AppTheme.dart';
import '../common/CommonWidgets.dart';
import '../common/globalFunctions.dart';
import '../home/home_widget.dart';
import '../main.dart';
import 'new_login_screen.dart';

class NewLoginOTPScreen extends StatelessWidget {
  final LoginOTPVerificationController controller =
      Get.put(LoginOTPVerificationController());
  final String verificationId;
  final String fullPhoneNumber;
  final int? resendToken;

  NewLoginOTPScreen(
      this.fullPhoneNumber, this.verificationId, this.resendToken);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [getThemeSwitchIcon(switchTheme)],
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //_buildTopImage(),
                  Center(
                    child: Text(
                      'EQ App',
                      style: GoogleFonts.montserrat(
                        fontSize: 32,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 4
                          ..color = AppThemes.getPrimaryColor(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  _buildText(
                      data: "Enter OTP sent to $fullPhoneNumber to Login",
                      textStyle:
                          AppTextStyles().kTextStyleFourteenWithThemeColor),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: controller.verifyOTPRequestFormKey,
                    child: Column(
                      children: [
                        // _buildTextFormField(),
                        // _buildTextFormField(),
                        getPinCodeWidget(controller.otpController,
                            controller.errorController, controller.validateOTP),
                        SizedBox(
                          height: 16,
                        ),
                        getCommonElevatedButton('Login',
                            () => {controller.verifyOTPAction(verificationId)}),
                        SizedBox(
                          height: 16,
                        ),
                        if (resendToken != null)
                          getCommonElevatedButton(
                              'Resend OTP',
                              () => {
                                    controller.reSendOTPAction(
                                        fullPhoneNumber, resendToken!)
                                  }),
                        // _buildText(
                        //     data: "We will send OTP message to this number",
                        //     textStyle:
                        //     AppTextStyles().kTextStyleTwelveWithGreyColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _buildFooter(),
          )
        ],
      ),
    );
  }

  Widget _buildTopImage() {
    return Center(
      child: ClipOval(
        child: Image.asset(
          'assets/icon/eq_app_logo.png',
          // height: 130,
          // width: 130,
        ),
      ),
    );
    return Image.asset(
      'assets/icon/eq_app_logo.png',
      height: 150,
      width: 150,
    );
  }

  Widget _buildText({required String data, required TextStyle textStyle}) {
    return Text(
      data,
      style: textStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildFooter() {
    return ClipPath(
      clipper: FooterWaveClipper(),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: AppColors().bottomFooterGradient,
              begin: Alignment.center,
              end: Alignment.bottomRight),
        ),
        height: Get.height / 3,
      ),
    );
  }

  Widget getPinCodeWidget(
    TextEditingController otpController,
    StreamController<ErrorAnimationType>? errorController,
    String? Function(String? value) validator,
  ) {
    return PinCodeTextField(
      appContext: Get.context!,
      pastedTextStyle: TextStyle(
        color: Colors.green.shade600,
        fontWeight: FontWeight.bold,
      ),
      length: 6,
      animationType: AnimationType.fade,
      validator: validator,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        selectedColor: AppColors().kPrimaryColor,
        activeFillColor: AppColors().kPrimaryColor,
        inactiveFillColor: Colors.white,
        activeColor: AppColors().kPrimaryColor,
        inactiveColor: AppColors().kPrimaryColor,
      ),
      textStyle: AppTextStyles().kPinTextStyle,
      cursorColor: AppColors().kPrimaryTextColor,
      animationDuration: Duration(milliseconds: 300),
      enableActiveFill: true,
      errorAnimationController: errorController,
      controller: otpController,
      keyboardType: TextInputType.number,
      boxShadows: [
        BoxShadow(
          offset: Offset(0, 1),
          color: Colors.black12,
          blurRadius: 10,
        )
      ],
      onCompleted: (v) {
        print("Completed");
      },
      onChanged: (value) {},
      beforeTextPaste: (text) {
        print("Allowing to paste $text");
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return false;
      },
    );
  }
}

class LoginOTPVerificationController extends GetxController {
  var otpController = TextEditingController();
  var errorController = StreamController<ErrorAnimationType>();
  int? resendToken;
  var verifyOTPRequestFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // Simulating obtaining the user name from some local storage
    super.onInit();
  }

  @override
  void onClose() {
    // otpController.dispose();
    errorController.close();
    super.onClose();
  }

  String? validateOTP(String? value) {
    bool isNullOrBlank = value?.isBlank ?? true;
    if (isNullOrBlank) {
      return 'OTP should not be empty';
    }
    if ((value?.length ?? 0) < 6) {
      return 'Please enter valid OTP';
    }

    return null;
  }

  Future<void> verifyOTPAction(String verificationId) async {
    await Get.showOverlay<void>(
        asyncFunction: () async {
          if (verifyOTPRequestFormKey.currentState!.validate()) {
            try {
              var _authCredential = PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: otpController.text);

              var userDetails = await FirebaseAuth.instance
                  .signInWithCredential(_authCredential);

              var phoneNumber = userDetails.user?.phoneNumber;
              if (phoneNumber == null) {
                showCustomSnackBar('Login Failed',
                    'Something went wrong, Please try again later');
                return;
              }
              currentFirebaseAuthUser = FirebaseAuth.instance.currentUser;
              var updated =
                  await fetchAndUpdateUserDetailsIfUserExist(phoneNumber);
              if (updated == false) {
                showCustomSnackBar('User does not exist',
                    'Sorry we could not find a user with mobile number $phoneNumber');
                return;
              }

              showCustomSnackBar('Logged in successfully',
                  'Logged in successfully, welcome to EQApp', false);
              Get.offAll(() => HomeWidget());
            } catch (error) {
              showCustomSnackBar('Verification Failed', error.toString());
            }
          }
        },
        loadingWidget: getCommonProgressWidget(),
        opacity: 0.7);
  }

  Future<void> reSendOTPAction(String fullPhoneNumber, int resendToken) async {
    await Get.showOverlay<void>(
        asyncFunction: () async {
          otpController.text = '';
          var validResendToken = this.resendToken ?? resendToken;
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: fullPhoneNumber,
            forceResendingToken: validResendToken,
            verificationCompleted: (PhoneAuthCredential credential) async {
              await FirebaseAuth.instance.signInWithCredential(credential);
              Get.offAll(() => HomeWidget());
            },
            verificationFailed: (FirebaseAuthException e) {
              var errorMessage = e.toString();
              if (e.code == 'invalid-phone-number') {
                errorMessage = 'The provided phone number is not valid.';
              }
              showCustomSnackBar('Verification Failed', errorMessage);
            },
            codeSent: (String verificationId, int? resendToken) {
              this.resendToken = resendToken;
              showCustomSnackBar('Successfully sent OTP',
                  'OTP send to $fullPhoneNumber', false);
            },
            codeAutoRetrievalTimeout: (String verificationId) {},
          );
        },
        loadingWidget: getCommonProgressWidget(),
        opacity: 0.7);
  }
}
