import 'dart:developer';
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

class ChatController extends GetxController {
  final Rx<TextEditingController> messageController =
      TextEditingController().obs;
  RxList<MessageModel> messages = <MessageModel>[].obs;

  FirebaseHelper firebaseHelper = FirebaseHelper();

  sendMessage({required UserResponse selectedUser}) async {
    try {
      if (messageController.value.text.isEmpty) {
        sendFiles(selectedUser: selectedUser);
        return;
      }
      await FirebaseHelper.sendChat(
          selectedUser: selectedUser, message: messageController.value.text);
      messageController.value.clear();
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
    // try {
    //   Get.dialog(
    //     barrierDismissible: false,
    //     const AlertDialog(content: CircularProgressIndicator()),
    //   );
    //   final request = await HttpClient().getUrl(Uri.parse(url));
    //   final response = await request.close();
    //   if (response.statusCode == 200) {
    //     final List<int> bytes =
    //         await response.fold<List<int>>(<int>[], (a, b) => a + b);
    //     final filePath = await getAppDirectory();
    //     final file = await File(filePath).writeAsBytes(bytes);
    //     Get.back();
    //     openFileFromPath(path: file.path);
    //     log('File downloaded to: ${file.path}');
    //   } else {
    //     throw Exception('Failed to download file: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   throw Exception('Failed to download file: $e');
    // } finally {}

    try {
      var dir = await getApplicationDocumentsDirectory();
      String filePath = "${dir.path}/files";

      await Dio().download(url, filePath, onReceiveProgress: (rec, total) {
        print("Received: ${rec / total}");
      });
      log("PATH>>>>$filePath");
      openFileFromPath(path: filePath);
    } catch (e) {
      print("Error: $e");
    }
  }
}

Future<String> getAppDirectory() async {
  final Directory appDir = await getApplicationDocumentsDirectory();
  return "${appDir.path}/downloaded_file";
}
