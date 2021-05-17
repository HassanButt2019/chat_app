import 'package:flutter/material.dart';

class ReplyMessage extends StatelessWidget {
    ReplyMessage({Key key , this.msg}) : super(key : key);

  final String msg;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 1,
          margin: EdgeInsets.symmetric(horizontal :15 , vertical:5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:10  , right:60 , top:5, bottom: 20),
                child: Text(msg, style: TextStyle(fontSize: 16 ),),
              ),
              Positioned(
                bottom: 4,
                right: 10,

                    child:Text("4:00",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey
                  ),                
                  ), 
                 
              )
            ],
          ),
          // color: Color(0xffdcf8c6),
        ),
      ),
    );
  }
}
