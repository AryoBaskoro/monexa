import 'package:flutter/material.dart';

import '../../common/color_extension.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/round_textfield.dart';
import '../../widgets/secondary_button.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  TextEditingController txtEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.gray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/img/app_logo.png",
                  width: media.width * 0.5, fit: BoxFit.contain),
              const Spacer(),
              Text(
                "Forgot your password?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: TColor.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                "Don't worry, enter your email and we'll send you a reset link.",
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.gray50, fontSize: 14),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundTextField(
                title: "Email Address",
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 25,
              ),
              PrimaryButton(
                title: "Reset Password",
                onPressed: () {
                  print("Reset Password for: ${txtEmail.text}");
                },
              ),
              const Spacer(),
              Text(
                "or",
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.gray50, fontSize: 14),
              ),
              const SizedBox(
                height: 20,
              ),
              SecondaryButton(
                title: "Cancel",
                onPressed: () {
                  Navigator.pop(context); // Kembali ke SignInView
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}