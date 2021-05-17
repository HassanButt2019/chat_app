import 'package:flutter/material.dart';
import 'package:whatsapp/model/chat_model.dart';
import 'package:whatsapp/page/chat_page.dart';
import 'package:whatsapp/page/status_page.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({Key key , this.chatModel ,this.sourceChat}) : super(key :key );

  final List<ChatModel> chatModel;
  final ChatModel sourceChat;
  @override

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 4 , vsync:this , initialIndex: 0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sourceChat.name),
        actions: [
          IconButton(icon:Icon(Icons.search), onPressed: (){}),
          PopupMenuButton<String>(
            onSelected: (value){
               print(value);
            },
            itemBuilder:(BuildContext context) {
            return [
              PopupMenuItem(child: Text("New Group") ,value: "New Group",),
              PopupMenuItem(child: Text("New Broadcast") ,value: "New Broadcast",),
              PopupMenuItem(child: Text("Whatsapp Web") ,value: "Whatsapp Web",),
              PopupMenuItem(child: Text("Starred message") ,value: "Starred message",),
              PopupMenuItem(child: Text("Setting") ,value: "Settings",),

            ];
          },
          )
        ],
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _controller,
          tabs: [
            Tab(
              icon: Icon(Icons.camera_alt),
            ),
            Tab(
              text:"Chats",
            ),
            Tab(
              text:"Status",
            ),
            Tab(
              text:"Calls",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
        Text("Camera"),
        ChatPage(chatModel: widget.chatModel,sourceChat: widget.sourceChat,),
        StatusPage(),
        Text("Calls")
        ],

      ),
    );
  }
}