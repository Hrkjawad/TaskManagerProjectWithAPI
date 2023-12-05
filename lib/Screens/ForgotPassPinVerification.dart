import 'package:flutter/material.dart';
import 'package:task_manager_assignment/Screens/SetPassword.dart';
import 'package:task_manager_assignment/Screens/bg.dart';
import 'package:task_manager_assignment/login_Signup/login.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_assignment/Datas/NetUtils.dart';
import 'package:task_manager_assignment/Datas/SnackbarMessage.dart';
import 'package:task_manager_assignment/Datas/Urls.dart';

class ForgotPassPinVerification extends StatefulWidget {
  final String email;

  const ForgotPassPinVerification({Key? key, required this.email})
      : super(key: key);

  @override
  State<ForgotPassPinVerification> createState() =>
      _ForgotPassPinVerificationState();
}

class _ForgotPassPinVerificationState
    extends State<ForgotPassPinVerification> {
  final TextEditingController otpController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: background(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: ListView(
              children: [
                const SizedBox(
                  height: 55,
                ),
                Text(
                  "PIN Verification",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  "A 6 digit verification pin will be sent to your email address",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                PinCodeTextField(
                  controller: otpController,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: Colors.green,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  keyboardType: TextInputType.number,
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onCompleted: (v) {
                    setState(() {
                      isButtonEnabled = true;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      isButtonEnabled = value.length == 6;
                    });
                  },
                  appContext: context,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 40,
                  color: Colors.green,
                  child: ElevatedButton(
                    child: const Text('Verify',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    ),
                    onPressed: isButtonEnabled
                        ? () async {
                      await verifyOtp();
                    }
                        : null,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const login(),
                          ),
                        );
                      },
                      child: const Text("Sign in"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyOtp() async {
    try {
      final response = await NetworkUtils().getMethod(
        Urls.recoveryOtpUrl(widget.email, otpController.text.trim()),
      );

      if (response != null && response['status'] == 'success') {
        SnackBarMessage(context, "OTP verification done!");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SetPassword(
              email: widget.email,
              otp: otpController.text,
            ),
          ),
        );
      } else {
        SnackBarMessage(context, "OTP verification failed. Check your OTP!", true);
      }
    } catch (e) {
      print("Error during OTP verification: $e");
      SnackBarMessage(context, "An error occurred. Please try again.", true);
    }
  }
}
