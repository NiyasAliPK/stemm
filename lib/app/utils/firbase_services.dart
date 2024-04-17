import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat/app/utils/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  static addUser(
      {required String email,
      required String uid,
      required String name,
      required String age}) async {
    getDataBase
        .refFromURL(members)
        .push()
        .set({"email": email, "uid": uid, "name": name, "age": age});
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
      {required UserResponse selectedUser,
      required String message,
      String path = ''}) async {
    return await chatRoomRef(selectedUser: selectedUser)
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .set({
      'uid': FirebaseAuth.instance.currentUser?.uid,
      'message': message,
      'path': path
    });
  }

  getChatsForRoom({required UserResponse selectedUser}) {
    chatRoomRef(selectedUser: selectedUser).ref.onChildAdded.listen((event) {
      _streamController.add(event);
    });
  }

  static String getRoomId({required List<String> uids}) {
    uids.sort((a, b) => a.compareTo(b));
    return uids.join();
  }

  Future<String> uploadFiles({required FilePickerResult pickedFile}) async {
    final path = 'Files/${pickedFile.files.first.name}';
    final file = File(pickedFile.files.first.path!);
    final ref = FirebaseStorage.instance.ref().child(path);

    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }
}
