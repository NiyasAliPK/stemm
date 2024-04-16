import 'package:firebase_chat/app/modules/signUp/views/sign_up_view.dart';
import 'package:firebase_chat/app/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final LoginController _controller = Get.put(LoginController());

  LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                controller: _controller.emailController,
                decoration: const InputDecoration(hintText: "Email"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  } else if (!Utils.emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: context.height * 0.1),
              TextFormField(
                controller: _controller.passwordController,
                decoration: const InputDecoration(hintText: "Password"),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  } else if (!Utils.passwordRegex.hasMatch(value)) {
                    return 'Password must contain at least 8 characters, including uppercase, lowercase, and numeric characters';
                  }
                  return null;
                },
                obscureText: true,
              ),
              SizedBox(height: context.height * 0.1),
              ElevatedButton(
                  onPressed: () {
                    _controller.loginWithEmailAndPassword();
                  },
                  child: const Text("Login")),
              Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                      onPressed: () {
                        Get.to(() => SignUpView());
                      },
                      child: const Text("Don't have an account? Sign Up")))
            ],
          ),
        ),
      )),
    );
  }
}
