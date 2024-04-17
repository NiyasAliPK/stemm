import 'package:get/get.dart';

import 'package:firebase_chat/app/modules/chat/bindings/chat_binding.dart';
import 'package:firebase_chat/app/modules/chat/views/chat_view.dart';
import 'package:firebase_chat/app/modules/home/bindings/home_binding.dart';
import 'package:firebase_chat/app/modules/home/views/home_view.dart';
import 'package:firebase_chat/app/modules/signUp/bindings/sign_up_binding.dart';
import 'package:firebase_chat/app/modules/signUp/views/sign_up_view.dart';
import 'package:firebase_chat/app/modules/userDetails/bindings/user_details_binding.dart';
import 'package:firebase_chat/app/modules/userDetails/views/user_details_view.dart';

import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.USER_DETAILS,
      page: () => UserDetailsView(),
      binding: UserDetailsBinding(),
    ),
  ];
}
