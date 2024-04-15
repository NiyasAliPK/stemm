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
}
