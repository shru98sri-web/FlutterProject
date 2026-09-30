import 'package:flutter/material.dart';
import 'package:flutter_gen_ai_chat_ui/flutter_gen_ai_chat_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat UI Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6366F1)),
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // 1. Instantiate the central message window stream coordinator
  final ChatMessagesController _chatController = ChatMessagesController();

  // 2. Map structural profiles identifying conversational participants
  final ChatUser _currentUser = ChatUser(
    id: 'user_client',
    firstName: 'Me',
  );

  final ChatUser _aiUser = ChatUser(
    id: 'ai_agent',
    firstName: 'AI Assistant',
  );

  /// Simulates a real-time word-by-word streaming generation mechanism.
  /// In real apps, replace this loop with your actual API endpoint stream (e.g., Gemini or OpenAI).
  Future<void> _simulateAiStreamingResponse(String prompt) async {
    final String trackingId = DateTime.now().microsecondsSinceEpoch.toString();

    // Append an initial blank message bubble bound to the AI model entity
    _chatController.addMessage(
      ChatMessage(
        text: '',
        user: _aiUser,
        createdAt: DateTime.now(),
        customProperties: {
          'id': trackingId,
          'isStreaming': true,
        },
      ),
    );

    // Mock incoming token stream chunks
    final List<String> tokenChunks = [
      'Hello! ',
      'I am ',
      'processing ',
      'your request: ',
      '"$prompt". ',
      '\n\nHere is some **Markdown formatting** with code:\n',
      '```dart\nvoid main() {\n  print("Hello World");\n}\n```'
    ];

    final StringBuffer textBuffer = StringBuffer();

    for (final String chunk in tokenChunks) {
      // Artificially space out tokens at 60fps to preview UI engine rendering
      await Future.delayed(const Duration(milliseconds: 200));
      textBuffer.write(chunk);

      // Incrementally update the message UI array context
      _chatController.updateMessage(
        ChatMessage(
          text: textBuffer.toString(),
          user: _aiUser,
          createdAt: DateTime.now(),
          customProperties: {
            'id': trackingId,
            'isStreaming': true,
          },
        ),
      );
    }

    // Explicitly transition status flag away from active streaming
    _chatController.stopStreamingMessage(trackingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generative AI Interface'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // 3. Connect configuration dependencies into the core view widget
      body: AiChatWidget(
        currentUser: _currentUser,
        aiUser: _aiUser,
        controller: _chatController,
        enableMarkdownStreaming:
            true, // Animates markdown styles smoothly as tokens load
        streamingWordByWord: true,
        onSendMessage: (ChatMessage message) async {
          // Immediately triggers when the user presses Send
          await _simulateAiStreamingResponse(message.text);
        },
      ),
    );
  }
}
