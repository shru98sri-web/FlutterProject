import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/chat_model.dart';
import '../providers/event_provider.dart';
import '../utils/advanced_services.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String eventId;
  final String eventTitle;
  const ChatRoomScreen(
      {super.key, required this.eventId, required this.eventTitle});

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  final TextEditingController _msgInputController = TextEditingController();

  void _dispatchChatMessage() async {
    if (_msgInputController.text.trim().isEmpty) return;
    final user = ref.read(authProvider).currentUser;
    if (user == null) return;

    final messagePayload = {
      'senderId': user.uid,
      'senderName': user.displayName ?? 'Event Guest',
      'senderPhoto': user.photoURL ?? 'https://placehold.co',
      'messageText': _msgInputController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    };

    _msgInputController.clear();
    await ref
        .read(firestoreProvider)
        .collection('events')
        .doc(widget.eventId)
        .collection('chats')
        .add(messagePayload);
  }

  @override
  Widget build(BuildContext context) {
    final firestore = ref.watch(firestoreProvider);
    final appLanguageCode = ref.watch(currentLanguageProvider).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(widget.eventTitle)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('events')
                  .doc(widget.eventId)
                  .collection('chats')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                final chatDocs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, idx) {
                    final message = ChatMessage.fromFirestore(chatDocs[idx]);
                    return ChatBubbleTile(
                        message: message, targetLanguageCode: appLanguageCode);
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).cardColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgInputController,
                    decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none),
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.send, color: Colors.deepPurple),
                    onPressed: _dispatchChatMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubbleTile extends StatefulWidget {
  final ChatMessage message;
  final String targetLanguageCode;
  const ChatBubbleTile(
      {super.key, required this.message, required this.targetLanguageCode});

  @override
  State<ChatBubbleTile> createState() => _ChatBubbleTileState();
}

class _ChatBubbleTileState extends State<ChatBubbleTile> {
  String? _translatedSubtext;
  bool _isTranslating = false;

  @override
  void initState() {
    super.initState();
    _runAiTranslation();
  }

  void _runAiTranslation() async {
    if (widget.targetLanguageCode == 'en') return;
    setState(() => _isTranslating = true);
    final translated = await AiTranslationService.translateMessage(
        text: widget.message.messageText,
        targetLanguageCode: widget.targetLanguageCode);
    if (mounted) {
      setState(() {
        _translatedSubtext = translated;
        _isTranslating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.message.senderPhoto)),
      title: Text(widget.message.senderName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.message.messageText,
              style: const TextStyle(fontSize: 15)),
          if (_isTranslating)
            const Padding(
                padding: EdgeInsets.only(top: 4),
                child: SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2))),
          if (_translatedSubtext != null &&
              _translatedSubtext != widget.message.messageText)
            Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('✨ $_translatedSubtext',
                    style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.deepPurple.shade300))),
        ],
      ),
    );
  }
}
