import 'package:nars/enumerables/message_status.dart';
import 'package:nars/enumerables/message_type.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

ChatMessage welcomeFromJson(String str) => ChatMessage.fromJson(json.decode(str));

String welcomeToJson(ChatMessage data) => json.encode(data.toJson());
class ChatMessage {
  ChatMessage({
    this.text,
    required this.messageType,
    required this.messageStatus,
    required this.sender,
    required this.dateTime,
  });

  String? text;
  MessageType messageType;
  MessageStatus messageStatus;
  String sender;
  DateTime dateTime;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json["text"],
        messageType: json["messageType"],
        messageStatus: json["messageStatus"],
        sender: json["sender"],
        dateTime: DateTime.parse(json["dateTime"]),
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "messageType": messageType,
        "messageStatus": messageStatus,
        "sender": sender,
        "dateTime": dateTime.toIso8601String(),
    };
}
