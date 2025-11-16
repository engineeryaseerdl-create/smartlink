import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_widget.dart';
import '../utils/constants.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ChatProvider>().loadChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          return ChatListWidget(
            chats: provider.chats,
            onChatTap: (chat) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatConversationScreen(chatId: chat.id),
                ),
              );
            },
            isLoading: provider.isLoading,
          );
        },
      ),
    );
  }
}

class ChatConversationScreen extends StatefulWidget {
  final String chatId;

  const ChatConversationScreen({
    super.key,
    required this.chatId,
  });

  @override
  State<ChatConversationScreen> createState() => _ChatConversationScreenState();
}

class _ChatConversationScreenState extends State<ChatConversationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ChatProvider>().loadChatMessages(widget.chatId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ChatProvider>(
          builder: (context, provider, child) {
            final chat = provider.currentChat;
            if (chat == null) return const Text('Chat');
            
            final otherParticipant = chat.participants.first;
            return Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: otherParticipant.avatar != null
                      ? NetworkImage(otherParticipant.avatar!)
                      : null,
                  child: otherParticipant.avatar == null
                      ? Text(otherParticipant.name[0].toUpperCase())
                      : null,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        otherParticipant.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        otherParticipant.role.toUpperCase(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          final chat = provider.currentChat;
          if (chat == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Messages List
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: chat.messages.length,
                  itemBuilder: (context, index) {
                    final message = chat.messages[chat.messages.length - 1 - index];
                    final isMe = message.senderId == provider.currentUserId;
                    
                    return ChatBubbleWidget(
                      message: message,
                      isMe: isMe,
                    );
                  },
                ),
              ),
              
              // Message Input
              ChatInputWidget(
                onSendMessage: (message) {
                  provider.sendMessage(widget.chatId, message);
                },
                onImagePick: () {
                  // Handle image picking
                },
                isLoading: provider.isSending,
              ),
            ],
          );
        },
      ),
    );
  }
}