import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_chat/app/utils/firbase_services.dart';
import 'package:firebase_chat/app/utils/models.dart';
import 'package:firebase_chat/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChatController extends GetxController {
  final TextEditingController messageController = TextEditingController();
  RxList<MessageModel> messages = <MessageModel>[].obs;
  AutoScrollController scrollController = AutoScrollController();

  FirebaseHelper firebaseHelper = FirebaseHelper();

  RxDouble progress = 0.0.obs;

  sendMessage({required UserResponse selectedUser}) async {
    try {
      if (messageController.text.isEmpty) {
        sendFiles(selectedUser: selectedUser);
        return;
      }
      await FirebaseHelper.sendChat(
          selectedUser: selectedUser, message: messageController.text);
      messageController.clear();
      update();
    } catch (e) {
      Loghelper.showToast(message: 'Failed to send message, Please try again.');
    }
  }

  sendFiles({required UserResponse selectedUser}) async {
    try {
      final FilePickerResult? pickedFile =
          await FilePicker.platform.pickFiles();
      if (pickedFile != null) {
        Get.dialog(const AlertDialog(
          content: SizedBox(
            width: 75,
            height: 75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularProgressIndicator(),
                Text("Uploading file, Please wait...")
              ],
            ),
          ),
        ));
        final url = await firebaseHelper.uploadFiles(pickedFile: pickedFile);

        if (url.isNotEmpty) {
          await FirebaseHelper.sendChat(
              selectedUser: selectedUser,
              message: url,
              path: pickedFile.files.first.path!);
          Get.back();
        }
      } else {
        Loghelper.showToast(message: 'No files selected');
        return;
      }
    } catch (e) {
      Loghelper.showToast(message: 'Faild to upload file, Please try again.');
    }
  }

  openFileFromPath({required String path}) async {
    try {
      await OpenFile.open(path);
    } catch (e) {
      Loghelper.showToast(message: "Failed to open file.");
    }
  }

  Future<void> downloadFile(String url) async {
    try {
      List<Directory> dir = await getExternalStorageDirectories() ?? [];
      var first = url.split('?').first;
      var fileName = first.split('/o/').last;
      if (dir.isEmpty) throw Exception('Storage not found');

      String filePath = "${dir.first.path}/$fileName";
      Get.dialog(AlertDialog(
        content: SizedBox(
          width: 75,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const CircularProgressIndicator(),
              Obx(() => Text("${progress.value.round()}% Completed.")),
              const Text("Downloading file, Please wait...")
            ],
          ),
        ),
      ));
      await Dio().download(
        url,
        filePath,
        onReceiveProgress: (count, total) {
          progress.value =
              double.parse((count / total).toStringAsFixed(2)) * 100;
        },
      );
      Get.back();
      openFileFromPath(path: filePath);
    } catch (e) {
      Loghelper.showToast(message: "Failed to download file, Please try again");
    }
  }

  Future<String> getAppDirectory() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    return "${appDir.path}/downloaded_file";
  }
}
