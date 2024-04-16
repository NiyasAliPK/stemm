import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loghelper {
  static showToast({required String message}) {
    return Get.showSnackbar(GetSnackBar(
      title: "Oops",
      message: message,
      backgroundColor: Colors.deepPurple,
      duration: const Duration(seconds: 2),
    ));
  }

  static responseLogger({required String screen, required String response}) {
    log("$screen Response >>>> $response");
  }
}

class Utils {
  static final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final passwordRegex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
}
