import 'dart:async';
import 'dart:developer';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/app/utils/models.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chat_controller.dart';

// class ChatView extends GetView<ChatController> {
//   final ChatController _controller = Get.put(ChatController());
//   final UserResponse? selectedUser;
//   ChatView({super.key, this.selectedUser});

//   @override

// }

class ChatView extends StatefulWidget {
  final UserResponse? selectedUser;
  const ChatView({super.key, this.selectedUser});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  StreamSubscription? chatStream;

  @override
  void initState() {
    _controller.messages.clear();
    _controller.firebaseHelper
        .getChatsForRoom(selectedUser: widget.selectedUser!);
    chatStream =
        _controller.firebaseHelper.watchTimeDbUpdates.stream.listen((event) {
      if (event.snapshot.value is Map) {
        final map = event.snapshot.value as Map;
        final data = MessageModel(message: map['message'], uid: map['uid']);
        _controller.messages.add(data);
        log("message>>>>${_controller.messages}");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    chatStream?.cancel();
    // _controller.firebaseHelper.watchTimeDbUpdates.s;
    super.dispose();
  }

  final ChatController _controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatView'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() => ListView(
                    children:
                        List.generate(_controller.messages.length, (index) {
                      return BubbleSpecialOne(
                        text: _controller.messages[index].message!,
                        color: _controller.messages[index].uid ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? Colors.blue
                            : Colors.grey,
                        isSender: _controller.messages[index].uid ==
                            FirebaseAuth.instance.currentUser!.uid,
                      );
                    }),
                  )))),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: context.width * 0.05,
          ),
          SizedBox(
              width: context.width * 0.82,
              child: TextField(
                controller: _controller.messageController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              )),
          IconButton(
              onPressed: () {
                _controller.sendMessage(selectedUser: widget.selectedUser!);
              },
              icon: const Icon(Icons.send)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
