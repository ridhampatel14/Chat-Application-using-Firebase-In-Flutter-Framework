import 'package:cloud_firestore/cloud_firestore.dart';
class databseMethods{
  getUserByName(String username) async{
    return await FirebaseFirestore.instance.collection('users').where('name',isEqualTo: username).get();
  }

  getUserByEmail(String useremail) async{
    return await FirebaseFirestore.instance.collection('users').where('email',isEqualTo: useremail).get();
  }

  uploadData(userMap) async{
    await FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId,chatRoomMap) async{
    await FirebaseFirestore.instance.collection('chatRoom').doc(chatRoomId).set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addMessages(String chatRoomId, messageMap) async{
    await FirebaseFirestore.instance.collection('chatRoom').doc(chatRoomId)
        .collection('chats').add(messageMap).catchError((e){
       print(e.toString());
    });
  }

  getMessages(String chatRoomId) async{
    return await FirebaseFirestore.instance.collection('chatRoom').doc(chatRoomId)
        .collection('chats').orderBy('time').snapshots();
  }
}