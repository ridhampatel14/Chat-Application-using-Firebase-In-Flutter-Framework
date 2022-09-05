import 'package:flutter/material.dart';
import 'package:chat_application/services/constants.dart';
import 'package:chat_application/services/databse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class chatroomscreen extends StatefulWidget{
  final String chatRoomId;
  const chatroomscreen(this.chatRoomId);
  @override
  State<StatefulWidget> createState() {
    return _chatroomscreenState();
  }
}

class _chatroomscreenState extends State<chatroomscreen>{

  databseMethods dbm=databseMethods();
  TextEditingController messageEditingController=TextEditingController();
  Stream<QuerySnapshot>? chatMessageStream;

  Widget chatMessageList(){
    return StreamBuilder<QuerySnapshot>(
        stream: chatMessageStream,
        builder:(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          return snapshot.hasData ?ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context,index){
                return messageTile(snapshot.data?.docs[index]['message'],snapshot.data?.docs[index]['sendby']== constants.myName);
              }
          ) : Container();
    },
    );
  }

  sendMessage(){
    if(messageEditingController.text.isNotEmpty){
      Map<String,dynamic> messagemap={
        'message':messageEditingController.text,
        'sendby':constants.myName,
        'time':DateTime.now().millisecondsSinceEpoch,
      };
      dbm.addMessages(widget.chatRoomId, messagemap);
      messageEditingController.text='';
    }
  }

  @override
  void initState(){

    dbm.getMessages(widget.chatRoomId).then((val){
      setState(() {
        chatMessageStream=val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('chatroomscreen'),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              color: Colors.black,
              child:chatMessageList()
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(40)
                ),
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                child: Row(
                  children: [
                    Expanded(

                      child: TextField(
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'enter message',
                          hintStyle: TextStyle(
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                        ),
                        controller: messageEditingController,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        sendMessage();
                      },
                      child: const Icon(
                        Icons.send,
                        size:50,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class messageTile extends StatelessWidget{
  final String message;
  final bool sendbyme;
  const messageTile(this.message,this.sendbyme);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: sendbyme? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        decoration: BoxDecoration(
          borderRadius:sendbyme? BorderRadius.only(
            topLeft: Radius.circular(20),topRight:  Radius.circular(20),bottomLeft: Radius.circular(20),
          ): BorderRadius.only(
            topLeft: Radius.circular(20),topRight:  Radius.circular(20),bottomRight: Radius.circular(20),
          ),
          color:sendbyme ? Colors.blue : Colors.grey.shade800,
        ),
        child: Text(message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

}