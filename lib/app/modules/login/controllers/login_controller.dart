import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  loginWithEmailAndPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      final auth = FirebaseAuth.instance;
      final response = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Loghelper.responseLogger(screen: "Login", response: response.toString());
    } catch (e) {
      Loghelper.showToast(
          message:
              'Failed to login, Please check your credentials and try again');
    }
  }

  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();
    super.dispose();
  }
}
