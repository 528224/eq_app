import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/AppTheme.dart';
import '../common/CommonWidgets.dart';
import '../common/Constants.dart';
import '../common/globalFunctions.dart';
import '../home/home_widget.dart';
import 'new_login_otp_screen.dart';

class NewLoginScreen extends StatefulWidget {
  @override
  State<NewLoginScreen> createState() => _NewLoginScreenState();
}

class _NewLoginScreenState extends State<NewLoginScreen> {
  final LoginController controller = Get.put(LoginController());

  @override
  void initState() {
    // Simulating obtaining the user name from some local storage
    super.initState();
    GetStorage().remove(userUUIDKey);
  }

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
                      data: "Enter Mobile Number to Login",
                      textStyle:
                          AppTextStyles().kTextStyleFourteenWithThemeColor),
                  SizedBox(
                    height: 12,
                  ),
                  Form(
                    key: controller.loginScreenRequestFormKey,
                    child: Column(
                      children: [
                        // _buildTextFormField(),
                        _buildCountryCodeField(controller),
                        _buildTextFormField(),
                        SizedBox(
                          height: 16,
                        ),
                        getCommonElevatedButton(
                            'Continue', controller.sendOTPAction),
                        SizedBox(
                          height: 16,
                        ),
                        _buildText(
                            data: "We will send OTP message to this number",
                            textStyle:
                                AppTextStyles().kTextStyleTwelveWithGreyColor),
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

  Widget _buildTextFormField() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller.phoneNumberController,
      style: AppTextStyles().kTextStyleWithFont,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        hintText: "Mobile Number",
        hintStyle: AppTextStyles().kTextStyleWithFont,
        labelText: "Mobile Number",
        labelStyle: AppTextStyles().kTextStyleWithFont,
        prefixIcon: Icon(Icons.phone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        isDense: true,
        errorStyle: AppTextStyles().kTextStyleWithFont,
      ),
      maxLength: 10,
      validator: (value) {
        return controller.validateMobile(value);
      },
    );
  }
}

Widget _buildCountryCodeField(LoginController controller) {
  return Container(
    // height: 55,
    child: Align(
      alignment: Alignment.centerLeft,
      child: CountryCodePicker(
        onChanged: controller.onCountryChange,
        // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
        initialSelection: '+91',
        favorite: ['+91', '+971'],
        textStyle: AppTextStyles().kTextStyleWithFont,
        // optional. Shows only country name and flag
        showCountryOnly: false,
        // optional. Shows only country name and flag when popup is closed.
        showOnlyCountryWhenClosed: false,
        // optional. aligns the flag and the Text left
        alignLeft: false,
      ),
    ),
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

class FooterWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height - 60);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LoginController extends GetxController {
  var phoneNumberController = TextEditingController();
  var selectedCountryCode = "+91".obs;
  var loginScreenRequestFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    // Simulating obtaining the user name from some local storage
    super.onInit();
  }

  @override
  void onClose() {
    // phoneNumberController.dispose();
    super.onClose();
  }

  String? validateMobile(String? value) {
    bool isNullOrBlank = value?.isBlank ?? true;
    if (isNullOrBlank) {
      return 'Phone number should not be empty';
    }
    if ((value?.length ?? 0) < 6) {
      return 'Please enter valid phone number';
    }

    return null;
  }

  Future<void> sendOTPAction() async {
    await Get.showOverlay<void>(
        asyncFunction: () async {
          if (loginScreenRequestFormKey.currentState!.validate()) {
            var fullPhoneNumber =
                '$selectedCountryCode${phoneNumberController.text}';

            await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: fullPhoneNumber,
              verificationCompleted: (PhoneAuthCredential credential) async {
                await FirebaseAuth.instance.signInWithCredential(credential);
                Get.offAll(() => HomeWidget());
              },
              verificationFailed: (FirebaseAuthException e) {
                var errorMessage = e.toString();
                if (e.code == 'invalid-phone-number') {
                  errorMessage = 'The provided phone number is not valid.';
                }
                showCustomSnackBar(
                  'Failed',
                  errorMessage,
                );
              },
              codeSent: (String verificationId, int? resendToken) {
                Get.to(() => NewLoginOTPScreen(
                    fullPhoneNumber, verificationId, resendToken));
              },
              codeAutoRetrievalTimeout: (String verificationId) {},
            );
          }
        },
        loadingWidget: getCommonProgressWidget(),
        opacity: 0.7);
  }

  void onCountryChange(CountryCode countryCode) {
    selectedCountryCode.value = countryCode.dialCode ?? "";
  }
}
