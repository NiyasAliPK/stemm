import 'package:firebase_chat/app/utils/firbase_services.dart';
import 'package:firebase_chat/app/utils/models.dart';
import 'package:firebase_chat/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  RxList<MessageModel> messages = <MessageModel>[].obs;

  FirebaseHelper firebaseHelper = FirebaseHelper();

  sendMessage({required UserResponse selectedUser}) {
    try {
      if (messageController.text.isEmpty) {
        Loghelper.showToast(message: 'Please enter a message');
        return;
      }
      FirebaseHelper.sendChat(
          selectedUser: selectedUser, message: messageController.text);
    } catch (e) {
      Loghelper.showToast(message: 'Failed to send message, Please try again.');
    }
  }
}
