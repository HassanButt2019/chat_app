import 'package:flutter/material.dart';
import 'package:whatsapp/custom_ui/button_custom.dart';
import 'package:whatsapp/model/chat_model.dart';
import 'package:whatsapp/screens/home_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ChatModel sourceChat;
    List<ChatModel> chats = [
    ChatModel(
      id:1,
    name: "hassan",
    isGroup: false,
    currentMessage: "HEY HASSAN",
    time: "4:00",
    icon: "person.svg"  
    ),
    ChatModel(
      id:2,
    name: "ali",
    isGroup: false,
    currentMessage: "HEY ali",
    time: "5:00",
    icon: "person.svg"  
    ),

    ChatModel(
      id:3,
    name: "tahir",
    isGroup: false,
    currentMessage: "Yar assignment kra de",
    time: "3:00",
    icon: "person.svg"  
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context , index){
          return InkWell(
            onTap: (){
             sourceChat = chats.removeAt(index);
             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen(chatModel: chats, sourceChat: sourceChat,)));
            },
            child: ButtonCard(name: chats[index].name,icon: Icons.person));
        }),


    );
  }
}