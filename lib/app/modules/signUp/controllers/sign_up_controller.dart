import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/app/modules/home/views/home_view.dart';
import 'package:firebase_chat/app/utils/firbase_services.dart';
import 'package:firebase_chat/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  signUpWithEmailAndPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      final auth = FirebaseAuth.instance;
      final response = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Loghelper.responseLogger(
          screen: 'Sing Up', response: response.toString());
      if (response.additionalUserInfo!.isNewUser && response.user != null) {
        FirebaseHelper.addUser(
            email: response.user!.email!, uid: response.user!.uid);
        Get.offAll(() => HomeView());
      }
    } catch (e) {
      Loghelper.showToast(message: 'Failed to Sign Up, Please try again');
    }
  }
}
