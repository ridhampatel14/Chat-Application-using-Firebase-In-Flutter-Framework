import 'package:chat_application/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:chat_application/services/databse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_application/screen/chatroom.dart';
import 'package:chat_application/services/sharedPre.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen>{
  User? user=FirebaseAuth.instance.currentUser;
  final TextEditingController nameEditingController=TextEditingController();
  databseMethods dbm=databseMethods();
  //Map<String,dynamic>? usermap;
  QuerySnapshot? searchsnapshot;

  @override
  void initState() {
    super.initState();
    getUserName();
  }



  initialsearch(){
    dbm.getUserByName(nameEditingController.text).then((val){
      setState(() {
        searchsnapshot=val;
        //usermap=val.docs[0].data();
      });
    });
  }
  getUserName() async{
    constants.myName= (await HelperFunction.getUserNameSharedPreference())!;
    setState(() {

    });
  }

  createChatRoomAndStartCon({required String username}){

    if(username!=constants.myName) {
      String chatRoomId = getChatRoomId(username, constants.myName);
      List<String> user = [username, constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": user,
        "chatRoomId": chatRoomId
      };
      dbm.createChatRoom(chatRoomId, chatRoomMap).then(
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      chatroomscreen(chatRoomId)))
      );
    }
    else{
      Fluttertoast.showToast(msg: "you can not message youself!!!");
    }
  }

  Widget userList(){
    return searchsnapshot!= null ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchsnapshot?.docs.length,
        itemBuilder: (context, index){
          return userTile(
            //usermap!['email'].toString()
            name: searchsnapshot!.docs[0]['name'],
            email: searchsnapshot!.docs[0]['email']
          );
        })
    : Container() ;
  }


  Widget userTile({required String name,required String email}){
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
      child: Row(
        children: [
          Container(
            //padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(email,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoomAndStartCon(username: name);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
              child: const Text('message',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
}



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
                onPressed:() => {logout(context)},
                icon: const Icon(Icons.logout)
            ),
          ],
        ),
        body: Container(
          color: Colors.black87,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                color: Colors.black54,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: nameEditingController,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'enter name',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        initialsearch();
                      },
                      child: const Icon(
                          Icons.search,
                          size:50,
                          color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              userList(),
            ],
          ),
        )
      ),
    );
  }
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}

getChatRoomId(String a,String b){
  if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
    return '$b\_$a';
  }
  else{
    return '$a\_$b';
  }
}