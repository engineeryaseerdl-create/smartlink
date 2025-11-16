import 'user_model.dart';

class ChatModel {
  final String id;
  final List<UserModel> participants;
  final String? orderId;
  final List<MessageModel> messages;
  final LastMessageModel? lastMessage;
  final bool isActive;
  final int unreadCount;
  final DateTime createdAt;

  ChatModel({
    required this.id,
    required this.participants,
    this.orderId,
    required this.messages,
    this.lastMessage,
    required this.isActive,
    this.unreadCount = 0,
    required this.createdAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'] ?? '',
      participants: (json['participants'] as List?)
          ?.map((p) => UserModel.fromJson(p))
          .toList() ?? [],
      orderId: json['order'],
      messages: (json['messages'] as List?)
          ?.map((m) => MessageModel.fromJson(m))
          .toList() ?? [],
      lastMessage: json['lastMessage'] != null
          ? LastMessageModel.fromJson(json['lastMessage'])
          : null,
      isActive: json['isActive'] ?? true,
      unreadCount: json['unreadCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class MessageModel {
  final String id;
  final String senderId;
  final String content;
  final String messageType;
  final String? fileUrl;
  final bool isRead;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    this.messageType = 'text',
    this.fileUrl,
    required this.isRead,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      senderId: json['sender'] is String ? json['sender'] : json['sender']['_id'] ?? '',
      content: json['content'] ?? '',
      messageType: json['messageType'] ?? 'text',
      fileUrl: json['fileUrl'],
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class LastMessageModel {
  final String content;
  final String senderId;
  final DateTime timestamp;

  LastMessageModel({
    required this.content,
    required this.senderId,
    required this.timestamp,
  });

  factory LastMessageModel.fromJson(Map<String, dynamic> json) {
    return LastMessageModel(
      content: json['content'] ?? '',
      senderId: json['sender'] is String ? json['sender'] : json['sender']['_id'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}