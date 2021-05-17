import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whatsapp/model/chat_model.dart';
import 'package:whatsapp/screens/individual_screen.dart';


class CustomCard extends StatelessWidget {
  const CustomCard({Key key , this.chatModel , this.sourceChat}) : super(key:key);

  final ChatModel chatModel;
  final ChatModel sourceChat;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> IndividualPage(chatModel: chatModel,sourceChat: sourceChat,)));
      },
          child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: SvgPicture.asset(
                'assets/${chatModel.icon}',
                height: 37,
                width: 37,
                ),
              backgroundColor: Colors.blueGrey,
              radius: 25,
            ),
            trailing: Text(chatModel.time),
            title: Text(chatModel.name , style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold),),
            subtitle: Row(
              children: [
                Icon(Icons.done_all),
                SizedBox(width:10),
                Text(chatModel.currentMessage , style: TextStyle(fontSize: 13 ),),
              ],
            )

          ),
          Padding(
            padding: const EdgeInsets.only(right: 20 , left: 18),
            child: Divider(thickness:1),
          )
        ],
      ),
    );
  }
}