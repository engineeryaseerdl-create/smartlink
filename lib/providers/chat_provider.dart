import 'package:flutter/foundation.dart';
import '../models/chat_model.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<ChatModel> _chats = [];
  ChatModel? _currentChat;
  bool _isLoading = false;
  bool _isSending = false;
  String? _currentUserId;

  List<ChatModel> get chats => _chats;
  ChatModel? get currentChat => _currentChat;
  bool get isLoading => _isLoading;
  bool get isSending => _isSending;
  String? get currentUserId => _currentUserId;

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
  }

  Future<void> loadChats() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/chat');

      if (response['success']) {
        _chats = (response['chats'] as List)
            .map((json) => ChatModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading chats: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createOrGetChat(String participantId, {String? orderId}) async {
    try {
      final response = await _apiService.post('/chat', data: {
        'participantId': participantId,
        if (orderId != null) 'orderId': orderId,
      });

      if (response['success']) {
        final chat = ChatModel.fromJson(response['chat']);
        
        // Add to chats list if not exists
        final existingIndex = _chats.indexWhere((c) => c.id == chat.id);
        if (existingIndex == -1) {
          _chats.insert(0, chat);
        } else {
          _chats[existingIndex] = chat;
        }
        
        _currentChat = chat;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error creating/getting chat: $e');
    }
  }

  Future<void> loadChatMessages(String chatId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.get('/chat/$chatId/messages');

      if (response['success']) {
        _currentChat = ChatModel.fromJson(response['chat']);
        
        // Mark messages as read
        await _apiService.put('/chat/$chatId/read');
      }
    } catch (e) {
      debugPrint('Error loading chat messages: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String chatId, String content, {String? fileUrl}) async {
    if (content.trim().isEmpty) return;

    _isSending = true;
    notifyListeners();

    try {
      final response = await _apiService.post('/chat/$chatId/messages', data: {
        'content': content,
        if (fileUrl != null) 'fileUrl': fileUrl,
        if (fileUrl != null) 'messageType': 'image',
      });

      if (response['success']) {
        final message = MessageModel.fromJson(response['message']);
        
        // Add message to current chat
        if (_currentChat != null) {
          _currentChat!.messages.add(message);
          
          // Update last message
          _currentChat = ChatModel(
            id: _currentChat!.id,
            participants: _currentChat!.participants,
            orderId: _currentChat!.orderId,
            messages: _currentChat!.messages,
            lastMessage: LastMessageModel(
              content: content,
              senderId: _currentUserId!,
              timestamp: DateTime.now(),
            ),
            isActive: _currentChat!.isActive,
            createdAt: _currentChat!.createdAt,
          );
        }
        
        // Update chat in list
        final chatIndex = _chats.indexWhere((c) => c.id == chatId);
        if (chatIndex != -1) {
          _chats[chatIndex] = _currentChat!;
          // Move to top
          _chats.removeAt(chatIndex);
          _chats.insert(0, _currentChat!);
        }
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  void addNewMessage(String chatId, MessageModel message) {
    // Update current chat if it matches
    if (_currentChat?.id == chatId) {
      _currentChat!.messages.add(message);
    }
    
    // Update chat in list
    final chatIndex = _chats.indexWhere((c) => c.id == chatId);
    if (chatIndex != -1) {
      final chat = _chats[chatIndex];
      final updatedChat = ChatModel(
        id: chat.id,
        participants: chat.participants,
        orderId: chat.orderId,
        messages: chat.messages..add(message),
        lastMessage: LastMessageModel(
          content: message.content,
          senderId: message.senderId,
          timestamp: message.createdAt,
        ),
        isActive: chat.isActive,
        unreadCount: message.senderId != _currentUserId ? chat.unreadCount + 1 : chat.unreadCount,
        createdAt: chat.createdAt,
      );
      
      _chats.removeAt(chatIndex);
      _chats.insert(0, updatedChat);
    }
    
    notifyListeners();
  }
}