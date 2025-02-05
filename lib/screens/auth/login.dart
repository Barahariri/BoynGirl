// Login.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'dart:ui';
import 'package:active_ecommerce_cms_demo_app/custom/btn.dart';
import 'package:active_ecommerce_cms_demo_app/custom/input_decorations.dart';
import 'package:active_ecommerce_cms_demo_app/custom/toast_component.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/auth_helper.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/other_config.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';
import 'package:toast/toast.dart';
import '../../custom/loading.dart';
import '../../repositories/address_repository.dart';
import 'otp.dart';

class Login extends StatefulWidget {
  final String? redirectRoute;
  Login({Key? key, this.redirectRoute}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _phone = "";
  String? _otp = "";
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  String _phoneError = "";
  String _otpError = "";
  bool _isOtpScreen = false;
  Timer? _timer;
  int _start = 120;
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _timer?.cancel();
    _phoneNumberController.dispose();
    _otpController.dispose();
    super.dispose();
  }
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() { timer.cancel(); });
      } else {
        setState(() { _start--; });
      }
    });
  }
  void onPressedContinue() async {
    if (_phone!.isEmpty) {
      setState(() { _phoneError = "Please enter a valid phone number."; });
      return;
    }
    try {
      var response = await AuthRepository().sendOtp(_phone!);
      if (response.result == false) {
        ToastComponent.showDialog(response.message!.join("\n"), gravity: Toast.center, duration: Toast.lengthLong);
      } else {
        setState(() { _isOtpScreen = true; startTimer(); });
      }
    } catch (e) {
      ToastComponent.showDialog("Failed to send OTP. Please try again.", gravity: Toast.center, duration: Toast.lengthLong);
    }
  }
  void onPressedVerify() async {
    var otp = _otpController.text.trim();
    setState(() { _otpError = ""; });
    if (otp.isEmpty) {
      setState(() { _otpError = "Please enter the OTP."; });
      return;
    }
    Loading.show(context);
    try {
      var loginResponse = await AuthRepository().verifyOtp(_phone!, otp);
      if (loginResponse.result == false) {
        ToastComponent.showDialog(loginResponse.message!.join("\n"), gravity: Toast.center, duration: Toast.lengthLong);
      } else {
        ToastComponent.showDialog(loginResponse.message!, gravity: Toast.center, duration: Toast.lengthLong);
        AuthHelper().setUserData(loginResponse);
        if (widget.redirectRoute != null && widget.redirectRoute!.isNotEmpty) {
          context.go(widget.redirectRoute!);
        } else {
          context.go("/");
        }
      }
    } catch (e) {
      ToastComponent.showDialog("An error occurred during login. Please try again.", gravity: Toast.center, duration: Toast.lengthLong);
    } finally {
      Loading.close();
    }
  }
  @override
  Widget build(BuildContext context) {
    final _screen_width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.accent_color),
          onPressed: () { Navigator.pop(context); },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.login_screen_log_in, style: TextStyle(color: MyTheme.accent_color)),
      ),
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset("assets/login_bg.jpg", fit: BoxFit.cover)),
          Positioned.fill(child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), child: Container(color: Colors.black.withOpacity(0.3)))),
          Center(child: _isOtpScreen ? buildOtpScreen(context, _screen_width) : buildPhoneScreen(context, _screen_width)),
        ],
      ),
    );
  }
  Widget buildPhoneScreen(BuildContext context, double _screen_width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: _screen_width * (3 / 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(bottom: 4.0), child: Text(AppLocalizations.of(context)!.login_screen_phone, style: TextStyle(color: MyTheme.accent_color, fontWeight: FontWeight.w600))),
              Container(
                height: 50,
                child: TextField(
                  controller: _phoneNumberController,
                  onChanged: (value) { setState(() { _phone = value; }); },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(8)],
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecorations.buildInputDecoration_phone(hint_text: AppLocalizations.of(context)!.enter_phone_ucf),
                ),
              ),
              if (_phoneError.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4.0), child: Text(_phoneError, style: TextStyle(color: Colors.red, fontSize: 12))),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(border: Border.all(color: MyTheme.textfield_grey, width: 1), borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: Btn.minWidthFixHeight(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
                    color: MyTheme.amber,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
                    child: Text(AppLocalizations.of(context)!.proceed_ucf, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    onPressed: onPressedContinue,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
  Widget buildOtpScreen(BuildContext context, double _screen_width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: _screen_width * (3 / 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(bottom: 4.0), child: Text(AppLocalizations.of(context)!.otp_ucf, style: TextStyle(color: MyTheme.accent_color, fontWeight: FontWeight.w600))),
              Container(
                height: 50,
                child: TextField(
                  controller: _otpController,
                  onChanged: (value) { setState(() { _otp = value; }); },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecorations.buildInputDecoration_phone(hint_text: "• • • • • •"),
                ),
              ),
              if (_otpError.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 4.0), child: Text(_otpError, style: TextStyle(color: Colors.red, fontSize: 12))),
              Padding(padding: const EdgeInsets.only(top: 8.0), child: Text("00:${_start.toString().padLeft(2, '0')}", style: TextStyle(color: MyTheme.accent_color, fontWeight: FontWeight.w600))),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(border: Border.all(color: MyTheme.textfield_grey, width: 1), borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  child: Btn.minWidthFixHeight(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 50,
                    color: MyTheme.amber,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6.0))),
                    child: Text(AppLocalizations.of(context)!.verify_now, style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                    onPressed: onPressedVerify,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
