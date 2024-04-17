import 'package:firebase_chat/app/utils/models.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/user_details_controller.dart';

class UserDetailsView extends GetView<UserDetailsController> {
  final UserResponse? selectedUser;
  const UserDetailsView({super.key, this.selectedUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(radius: context.height * 0.1),
                    Card(
                      elevation: 0.75,
                      child: ListTile(
                          leading: const Text('Name'),
                          trailing: Text(selectedUser!.name ?? 'Not found')),
                    ),
                    Card(
                      elevation: 0.75,
                      child: ListTile(
                          leading: const Text('Age'),
                          trailing: Text(selectedUser!.age ?? 'Not found')),
                    ),
                    Card(
                      elevation: 0.75,
                      child: ListTile(
                          leading: const Text('Email'),
                          trailing: Text(selectedUser!.email ?? 'Not found')),
                    )
                  ],
                ))));
  }
}
