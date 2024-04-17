import 'package:firebase_chat/app/modules/chat/views/chat_view.dart';
import 'package:firebase_chat/app/modules/userDetails/views/user_details_view.dart';
import 'package:firebase_chat/app/utils/models.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final HomeController _controller = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  _controller.logout();
                },
                child: const Text('Logout'))
          ],
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<List<UserResponse>?>(
                future: _controller.fetchAllUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) => Card(
                                elevation: 0.75,
                                child: ListTile(
                                  onTap: () {
                                    Get.to(() => ChatView(
                                          selectedUser: snapshot.data![index],
                                        ));
                                  },
                                  title: Text(snapshot.data![index].name ?? ''),
                                  trailing: IconButton(
                                      onPressed: () {
                                        Get.to(() => UserDetailsView(
                                              selectedUser:
                                                  snapshot.data![index],
                                            ));
                                      },
                                      icon: const Icon(Icons.info_outline)),
                                ),
                              ),
                          separatorBuilder: (context, index) => SizedBox(
                                height: context.height * 0.025,
                              ),
                          itemCount: snapshot.data!.length),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const Text("No Other users found");
                  }
                },
              )
            ],
          ),
        )));
  }
}

class ListItems extends StatelessWidget {
  const ListItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          InkWell(
            // onTap: () {
            //   Navigator.of(context)
            //     ..pop()
            //     ..push(
            //       MaterialPageRoute<SecondRoute>(
            //         builder: (context) => SecondRoute(),
            //       ),
            //     );
            // },
            child: Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry A')),
            ),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[200],
            child: const Center(child: Text('Entry B')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[300],
            child: const Center(child: Text('Entry C')),
          ),
        ],
      ),
    );
  }
}
