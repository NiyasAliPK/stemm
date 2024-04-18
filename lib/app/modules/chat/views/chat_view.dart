import 'dart:async';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/app/utils/models.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

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
  StreamSubscription? chatSubscription;

  @override
  void initState() {
    _controller.messages.clear();
    _controller.firebaseHelper
        .getChatsForRoom(selectedUser: widget.selectedUser!);
    chatSubscription =
        _controller.firebaseHelper.watchTimeDbUpdates.stream.listen((event) {
      if (event.snapshot.value is Map) {
        final map = event.snapshot.value as Map;
        final data = MessageModel(
            message: map['message'], uid: map['uid'], path: map['path'] ?? '');
        _controller.messages.add(data);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    chatSubscription?.cancel();
    // _controller.firebaseHelper.watchTimeDbUpdates.s;
    super.dispose();
  }

  final ChatController _controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.selectedUser!.name!),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Obx(() {
                _controller.scrollController.scrollToIndex(
                    _controller.messages.length,
                    duration: const Duration(milliseconds: 300));
                return Column(children: [
                  Expanded(
                    child: ListView.separated(
                      controller: _controller.scrollController,
                      itemCount: _controller.messages.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: context.height * 0.01);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return _controller.messages[index].message!
                                .contains('https://')
                            ? AutoScrollTag(
                                key: ValueKey(index),
                                controller: _controller.scrollController,
                                index: index,
                                child: GestureDetector(
                                    onTap: () {
                                      if (_controller.messages[index].uid ==
                                          FirebaseAuth
                                              .instance.currentUser!.uid) {
                                        _controller.openFileFromPath(
                                            path: _controller
                                                .messages[index].path!);
                                      } else {
                                        _controller.downloadFile(_controller
                                            .messages[index].message!);
                                      }
                                    },
                                    child: BubbleSpecialOne(
                                      text: 'File',
                                      color: Colors.grey,
                                      isSender:
                                          _controller.messages[index].uid ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid,
                                    )),
                              )
                            : AutoScrollTag(
                                key: ValueKey(index),
                                controller: _controller.scrollController,
                                index: index,
                                child: BubbleSpecialOne(
                                  text: _controller.messages[index].message!,
                                  color: _controller.messages[index].uid ==
                                          FirebaseAuth.instance.currentUser!.uid
                                      ? Colors.blue
                                      : Colors.green,
                                  isSender: _controller.messages[index].uid ==
                                      FirebaseAuth.instance.currentUser!.uid,
                                ),
                              );
                      },
                    ),
                  ),
                  SizedBox(height: context.height * 0.1)
                ]);
              }))),
      floatingActionButton: Container(
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: context.width * 0.05,
            ),
            SizedBox(
                width: context.width * 0.82,
                child: TextFormField(
                  controller: _controller.messageController,
                  onChanged: (value) {
                    if (isKeyboardVisible) {
                      _controller.scrollController.scrollToIndex(
                          _controller.messages.length,
                          duration: const Duration(milliseconds: 300));
                    }
                    _controller.update();
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                )),
            GetBuilder<ChatController>(
              builder: (controller) => IconButton(
                  onPressed: () {
                    _controller.sendMessage(selectedUser: widget.selectedUser!);
                  },
                  icon: _controller.messageController.text.isEmpty
                      ? const Icon(Icons.attach_file)
                      : const Icon(Icons.send)),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
