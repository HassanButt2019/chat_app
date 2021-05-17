import 'package:flutter/material.dart';
import 'package:whatsapp/custom_ui/card_custom.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp/model/chat_model.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key , this.chatModel , this.sourceChat}) :super(key:key);
  final List<ChatModel> chatModel;
  final ChatModel sourceChat;
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.chatModel.length,
        itemBuilder: (BuildContext context , index){
          return CustomCard(chatModel: widget.chatModel[index] , sourceChat: widget.sourceChat,);
        }
        
        ),
      floatingActionButton: FloatingActionButton(
      onPressed: (){

      },
      child: Icon(Icons.chat),
      
      ),
    );
  }
}