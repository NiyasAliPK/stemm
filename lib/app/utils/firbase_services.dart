import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/app/utils/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseHelper {
  static const String baseRtdbUrl =
      'https://stemmchat-default-rtdb.firebaseio.com/';

  static const String members = "$baseRtdbUrl/users";
  // FirebaseHelper._internal();
  // static final FirebaseHelper _instance = FirebaseHelper._internal();
  // factory FirebaseHelper() => _instance;

  static final firebaseApp = Firebase.app(defaultFirebaseAppName);

  static Stream<DatabaseEvent>? databaseStream;
  final StreamController<DatabaseEvent> _streamController =
      StreamController.broadcast();
  StreamController<DatabaseEvent> get watchTimeDbUpdates => _streamController;

  static FirebaseDatabase get getDataBase {
    return FirebaseDatabase.instanceFor(
        app: firebaseApp, databaseURL: baseRtdbUrl);
  }

  static addUser({required String email, required String uid}) async {
    getDataBase.refFromURL(members).push().set({"email": email, "uid": uid});
  }

  static Future<DatabaseEvent> fetchAllUser() async {
    return await getDataBase.refFromURL(members).once();
  }

  static DatabaseReference chatRoomRef({required UserResponse selectedUser}) {
    return getDataBase.refFromURL(baseRtdbUrl).child('chatRoom').child(
        getRoomId(
            uids: [FirebaseAuth.instance.currentUser!.uid, selectedUser.uid!]));
  }

  static sendChat(
      {required UserResponse selectedUser, required String message}) {
    return chatRoomRef(selectedUser: selectedUser)
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      'uid': FirebaseAuth.instance.currentUser?.uid,
      'message': message,
    });
  }

  getChatsForRoom({required UserResponse selectedUser}) {
    chatRoomRef(selectedUser: selectedUser).ref.onChildAdded.listen((event) {
      // if (_streamController.isClosed) {
      //   _streamController = StreamController.broadcast();
      // }
      _streamController.add(event);
    });
    // chatStream = databaseStream?.listen((event) {
    //   _streamController.add(event);
    // });
  }

  static String getRoomId({required List<String> uids}) {
    uids.sort((a, b) => a.compareTo(b));
    return uids.join();
  }
}
