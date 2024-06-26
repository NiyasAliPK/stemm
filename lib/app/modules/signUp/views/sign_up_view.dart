import 'package:firebase_chat/app/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  final SignUpController _controller = Get.put(SignUpController());

  SignUpView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _controller.formKey,
            child: ListView(
              children: [
                SizedBox(height: context.height * 0.075),
                TextFormField(
                  controller: _controller.nameController,
                  decoration: const InputDecoration(hintText: "Name"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    } else if (value.length < 3) {
                      return 'Name should have more than 2 letters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.height * 0.075),
                TextFormField(
                  controller: _controller.ageController,
                  decoration: const InputDecoration(hintText: "Age"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your age';
                    } else if (value.length > 3) {
                      return 'Please enter a valid age';
                    }
                    return null;
                  },
                ),
                SizedBox(height: context.height * 0.075),
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
                SizedBox(height: context.height * 0.075),
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
                SizedBox(height: context.height * 0.075),
                ElevatedButton(
                    onPressed: () {
                      _controller.signUpWithEmailAndPassword();
                    },
                    child: const Text("Register")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
