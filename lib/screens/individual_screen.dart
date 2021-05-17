import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/cryptography/AES_algorithm.dart';
import 'package:whatsapp/custom_ui/own_msg_custom.dart';
import 'package:whatsapp/custom_ui/reply_message.dart';
import 'package:whatsapp/model/chat_model.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:whatsapp/model/message_model.dart';
import 'package:file_picker/file_picker.dart';


class IndividualPage extends StatefulWidget {
  const IndividualPage({Key key , this.chatModel , this.sourceChat}) : super(key:key);
final ChatModel chatModel;
final ChatModel sourceChat;
  @override
  _IndividualPageState createState() => _IndividualPageState();
}

class _IndividualPageState extends State<IndividualPage> {
  bool show = false;
  bool sendButton = false;
  FocusNode focusnode = FocusNode();
  File file1;

  
  Future getFiles(int src_id , int dest_id) async {
    File file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['jpg', 'jpeg', 'png' , 'txt' ,'var' , 'pdf' , '.bin']);
    print(file.path); 
    String fileName = file.path.split('/').last;
    String fileExtension = fileName.split('.').last;
    print(fileExtension);

    var bytes = await File(file.path).readAsBytes();
    var base64 = Base64Encoder().convert(bytes);
    sendFile(base64 , src_id , dest_id , fileName , fileExtension);



  }


  Aes aes = Aes();

  List<MessageModel> msgs = [];
  Future<File> writeFile(Uint8List data, String name) async {
    // storage permission ask
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    // // the downloads folder path
    var rng = new Random();
    String rnge = rng.nextInt(10000).toString();
    Directory tempDir = await DownloadsPathProvider.downloadsDirectory;
    String tempPath = tempDir.path;
    var filePath = tempPath + '/$rnge+$name';

    // 
    //

    // the data
    var bytes = ByteData.view(data.buffer);
    final buffer = bytes.buffer;
    // save the data in the path
    return File(filePath).writeAsBytes(buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  
  TextEditingController controller = TextEditingController();

  IO.Socket socket;


  void connect(){
    socket = IO.io("http://192.168.100.134:5000",<String , dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });
    socket.connect();
    socket.onConnect((data) {
      print("Connected");

      socket.on('msg', (msg) {
        print(msg);
        var de_msg = Aes.decrypt(msg['msg']);
        print(de_msg);
        setMessage("dest", de_msg);
      });
      socket.on('send-image', (img) {
        print(img);

        

        // if(img['fileExtension'] == 'jpg' || img['fileExtension'] == 'jpeg' || img['fileExtension'] == 'png' )
        // {
        Uint8List bytes = Base64Codec().decode(img['img']);
        _showMyDialog(bytes ,img['filename'] , ''); 
        print("File Recivied");

        // }else if(img['fileExtension'] == 'txt')
        // {
        //  Uint8List bytes = Base64Codec().decode(img['img']);
        //  print(bytes);
        // _showMyDialog(bytes ,img['filename'] , '');
        // print("File Recivied");
        // }
        





      });
    });
    print(socket.connected);
    socket.emit("signin",widget.sourceChat.id);
  }


  void sendFile(img , int src_id , int dest_id , String filename , String fileExtension)
 {
   socket.emit('send-image',{'img':img , 'src_id':src_id , 'dest_id':dest_id , 'filename':filename , 'fileExtension':fileExtension});
 } 


  void sendMessage(String msg , int src_id , int dest_id)
  {
    setMessage("source", msg);
    print(msg);
    var en_msg = Aes.encrypt(msg.toString());
    print("HELLO " + en_msg.toString());
    socket.emit('msg',{'msg':en_msg , 'src_id':src_id , 'dest_id':dest_id});
  }


  void setMessage(String type , String msg){
    MessageModel messageModel = MessageModel(msg: msg , type: type);

    setState(() {
      msgs.add(messageModel);
    });
  }

  Future<void> _showMyDialog(Uint8List data, String name , String txt) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Your File Is Ready '),
              Text('Would you like to download this File {$name?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Approve'),
            onPressed: () {
              writeFile(data ,name);
              
              Navigator.of(context).pop();
            },
          ),
           TextButton(
            child: Text('Cancel'),
            onPressed: () {
          
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusnode.addListener(() {
      if(focusnode.hasFocus){
        setState(() {
          show = false;
        });
      }
    });
    connect();
  }


  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/whatsappbg.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(

            leadingWidth: 70,
            leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back , size: 24,),
                  SizedBox(width:5),
                  CircleAvatar(
                    radius: 20,
                     child: SvgPicture.asset(
                    'assets/${widget.chatModel.icon}',
                    height: 37,
                    width: 37,
                    ),

                    backgroundColor: Colors.blueGrey,
                  ),

                ],
              ),
            ),
            title: InkWell(
              onTap: (){},
                      child: Container(
                margin: EdgeInsets.all(6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                  Text(widget.chatModel.name , style: TextStyle(fontSize: 18.5 , fontWeight: FontWeight.bold),),
                  Text("Last seen today at 12:05" , style: TextStyle(fontSize: 13 ),),


                
                
                ],
                
                
                ),
              ),
            ),

actions: [
  IconButton(icon: Icon(Icons.videocam), onPressed: (){}),
  IconButton(icon: Icon(Icons.call), onPressed: (){}),
                            PopupMenuButton<String>(
                onSelected: (value){
                   print(value);
                },
                itemBuilder:(BuildContext context) {
                return [
                  PopupMenuItem(child: Text("View Contact") ,value: "View Contact",),
                  PopupMenuItem(child: Text("Media , Links , docs") ,value: "Media , Links , docs",),


                ];
              },
              )


],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
                  onWillPop: () {
                    if (show) {
                      setState(() {
                        show = false;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                    return Future.value(false);
                  },
                      child: Stack(
                children: [
                Container(
                  height: MediaQuery.of(context).size.height-140,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: msgs.length,
                    itemBuilder: (context , index){
                      if(msgs[index].type == "source")
                      {
                        return OwnMessage(msg:msgs[index].msg );
                      }else{
                        return ReplyMessage(msg:msgs[index].msg );

                      }

                    }
                    
                    ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width-60,
                      
                      child: Card(

                        margin: EdgeInsets.only(right:2 , left:2 , bottom:8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                        ),
                        child: TextFormField(
                          controller: controller,
                          onChanged: (value){
                            if(value.length > 0)
                            setState(() {
                              sendButton = true;
                            });
                            else
                             setState(() {
                              sendButton = false;
                            });


                          },
                          focusNode: focusnode,
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.multiline,
                          minLines: 1,
                          decoration: InputDecoration(
                                border: InputBorder.none,
                                
                                hintText: "Type a message here...",
                                contentPadding: EdgeInsets.all(10),
                                // ignore: missing_required_param
                                prefixIcon: IconButton(
                                  onPressed: (){
                                    focusnode.unfocus();
                                    focusnode.canRequestFocus = false;
                                    setState(() {
                                      
                                      show = !show;
                                    });
                                  },
                                  icon: Icon(Icons.emoji_emotions),
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.attach_file), 
                                      onPressed: (){
                                        controller.clear();
                                        getFiles(widget.sourceChat.id, widget.chatModel.id);

                                        controller.clear();

                                      }),
                                  IconButton(icon: Icon(Icons.camera_alt), onPressed: (){}),
                                  ],
                                )

                          ),

                        )
                        )
                        ),
                    Padding(
                      
                      padding: EdgeInsets.only(bottom:8 , right: 5 ,  left: 2),
                      child: CircleAvatar(
                        backgroundColor: Color(0xFF128C7E),
                        radius: 25,
                        // ignore: missing_required_param
                        child: IconButton(
                          onPressed: (){
                            if(sendButton)
                            {
                              sendMessage(controller.text, widget.sourceChat.id, widget.chatModel.id);
                            controller.clear();
                            }
                          },
                          
                          icon:Icon(sendButton ? Icons.send : Icons.mic  , color: Colors.white)
                          ),
                        

                      ),
                    )

                  ],
                  ),
                   show?
                  emojiSelector()
                   :Container(),
                              ],
                            ),
                )
                ],
              ),
            ),
          ),
        

        ),
      ],
    );
  }

  Widget emojiSelector(){
    return EmojiPicker(
    rows: 4,
    columns: 7,
      onEmojiSelected: (emoji , category){
        print(emoji);
        setState(() {
          controller.text = controller.text + emoji.emoji;
        });
      }
      
      );
  }
}