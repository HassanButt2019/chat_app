
import 'package:flutter/material.dart';

class ChatModel{
  int id;
  String name;
  String icon;
  bool isGroup;
  String time;
  String currentMessage;

ChatModel({this.name , this.icon , this.isGroup , this.time , this.currentMessage , this.id});
}