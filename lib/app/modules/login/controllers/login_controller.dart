import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  GlobalKey formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  loginWithEmailAndPassword() async {
    try {
      final auth = FirebaseAuth.instance;
      final response = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      log("message>>>${response.toString()}");
    } catch (e) {
      Loghelper.showToast(message: 'Failed to login, Please try again');
    }
  }
}
