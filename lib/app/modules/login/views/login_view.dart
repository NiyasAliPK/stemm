import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final LoginController _controller = Get.put(LoginController());

  LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _controller.formKey,
          child: Column(
            children: [
              SizedBox(height: context.height * 0.1),
              TextFormField(
                  decoration: const InputDecoration(hintText: "Email")),
              SizedBox(height: context.height * 0.1),
              TextFormField(
                  decoration: const InputDecoration(hintText: "Password")),
              SizedBox(height: context.height * 0.1),
              ElevatedButton(
                  onPressed: () {
                    _controller.loginWithEmailAndPassword();
                  },
                  child: const Text("Login"))
            ],
          ),
        ),
      )),
    );
  }
}
