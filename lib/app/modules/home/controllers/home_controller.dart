import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/app/utils/firbase_services.dart';
import 'package:firebase_chat/app/utils/models.dart';
import 'package:firebase_chat/app/utils/utils.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final List<UserResponse> users = [];

  logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      Loghelper.showToast(message: 'Failed to logout, Please try again.');
    }
  }

  Future<List<UserResponse>?> fetchAllUsers() async {
    try {
      final response = await FirebaseHelper.fetchAllUser();
      if (response.snapshot.exists) {
        Loghelper.responseLogger(
            screen: "Home", response: response.snapshot.value.toString());

        if (response.snapshot.value is Map) {
          users.clear();
          for (var element in (response.snapshot.value! as Map).entries) {
            users.add(UserResponse(
                email: element.value['email'],
                uid: element.value['uid'],
                age: element.value['age'],
                name: element.value['name']));
          }
        }
        users.removeWhere(
            (element) => element.uid == FirebaseAuth.instance.currentUser?.uid);
      }
      return users;
    } catch (e) {
      Loghelper.showToast(message: 'Failed to load users, Please try again');
      return null;
    }
  }
}
