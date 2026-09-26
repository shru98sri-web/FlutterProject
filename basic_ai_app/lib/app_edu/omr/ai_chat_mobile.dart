import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const VoiceAiChatApp());
}

// ============================================================
// APP
// ============================================================

class VoiceAiChatApp extends StatelessWidget {
  const VoiceAiChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Study Assistant',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
        ),
      ),
      home: const AiChatPage(),
    );
  }
}

// ============================================================
// MESSAGE MODEL
// ============================================================

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

// ============================================================
// AI CHAT PAGE
// ============================================================

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage>
    with TickerProviderStateMixin {
  // ----------------------------------------------------------
  // CONTROLLERS
  // ----------------------------------------------------------

  final TextEditingController _controller = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  // ----------------------------------------------------------
  // SPEECH
  // ----------------------------------------------------------

  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _speechAvailable = false;
  bool _isListening = false;

  // ----------------------------------------------------------
  // TEXT TO SPEECH
  // ----------------------------------------------------------

  final FlutterTts _tts = FlutterTts();

  bool _isSpeaking = false;

  // ----------------------------------------------------------
  // CHAT STATE
  // ----------------------------------------------------------

  bool _isTyping = false;

  final List<ChatMessage> _messages = [];

  // ----------------------------------------------------------
  // ANIMATION
  // ----------------------------------------------------------

  late AnimationController _micAnimationController;

  // ----------------------------------------------------------
  // SUGGESTIONS
  // ----------------------------------------------------------

  final List<String> _suggestions = [
    'Explain photosynthesis',
    'Explain Newton\'s first law',
    'Give me a Java program',
    'What is quantum physics?',
  ];

  // ----------------------------------------------------------
  // INIT
  // ----------------------------------------------------------

  @override
  void initState() {
    super.initState();

    _initializeSpeech();

    _initializeTts();

    _micAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.85,
      upperBound: 1.15,
    );

    _addWelcomeMessage();
  }

  // ----------------------------------------------------------
  // WELCOME MESSAGE
  // ----------------------------------------------------------

  void _addWelcomeMessage() {
    _messages.add(
      ChatMessage(
        text:
        'Hello! 👋\n\n'
            'I am your AI Study Assistant. '
            'You can type a question or tap the microphone 🎤 '
            'and speak to me.\n\n'
            'I can help with Physics, Mathematics, Programming, '
            'Science and many other subjects.',
        isUser: false,
        time: DateTime.now(),
      ),
    );
  }

  // ----------------------------------------------------------
  // SPEECH INITIALIZATION
  // ----------------------------------------------------------

  Future<void> _initializeSpeech() async {
    try {
      final available = await _speech.initialize(
        onStatus: (status) {
          if (!mounted) return;

          if (status == 'done' || status == 'notListening') {
            setState(() {
              _isListening = false;
            });

            _micAnimationController.stop();
            _micAnimationController.reset();
          }
        },
        onError: (error) {
          if (!mounted) return;

          setState(() {
            _isListening = false;
          });

          _micAnimationController.stop();
          _micAnimationController.reset();

          _showSnackBar(
            'Speech recognition error: ${error.errorMsg}',
          );
        },
      );

      if (!mounted) return;

      setState(() {
        _speechAvailable = available;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _speechAvailable = false;
      });
    }
  }

  // ----------------------------------------------------------
  // TTS INITIALIZATION
  // ----------------------------------------------------------

  Future<void> _initializeTts() async {
    try {
      await _tts.setLanguage('en-US');

      await _tts.setSpeechRate(0.48);

      await _tts.setVolume(1.0);

      await _tts.setPitch(1.0);

      _tts.setStartHandler(() {
        if (!mounted) return;

        setState(() {
          _isSpeaking = true;
        });
      });

      _tts.setCompletionHandler(() {
        if (!mounted) return;

        setState(() {
          _isSpeaking = false;
        });
      });

      _tts.setCancelHandler(() {
        if (!mounted) return;

        setState(() {
          _isSpeaking = false;
        });
      });

      _tts.setErrorHandler((message) {
        if (!mounted) return;

        setState(() {
          _isSpeaking = false;
        });
      });
    } catch (_) {}
  }

  // ----------------------------------------------------------
  // START LISTENING
  // ----------------------------------------------------------

  Future<void> _startListening() async {
    if (!_speechAvailable) {
      _showSnackBar(
        'Speech recognition is not available on this device.',
      );
      return;
    }

    if (_isTyping) {
      return;
    }

    if (_isListening) {
      await _stopListening();
      return;
    }

    try {
      await _speech.listen(
        onResult: (result) {
          if (!mounted) return;

          setState(() {
            _controller.text = result.recognizedWords;

            _controller.selection = TextSelection.fromPosition(
              TextPosition(
                offset: _controller.text.length,
              ),
            );
          });

          if (result.finalResult) {
            _stopListening();

            if (_controller.text.trim().isNotEmpty) {
              _sendMessage();
            }
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
        partialResults: true,
        cancelOnError: true,
        listenMode: stt.ListenMode.confirmation,
      );

      if (!mounted) return;

      setState(() {
        _isListening = true;
      });

      _micAnimationController.repeat(
        reverse: true,
      );
    } catch (e) {
      _showSnackBar(
        'Unable to start microphone.',
      );
    }
  }

  // ----------------------------------------------------------
  // STOP LISTENING
  // ----------------------------------------------------------

  Future<void> _stopListening() async {
    try {
      await _speech.stop();
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      _isListening = false;
    });

    _micAnimationController.stop();
    _micAnimationController.reset();
  }

  // ----------------------------------------------------------
  // SPEAK AI MESSAGE
  // ----------------------------------------------------------

  Future<void> _speak(String text) async {
    try {
      await _tts.stop();

      setState(() {
        _isSpeaking = true;
      });

      await _tts.speak(text);
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isSpeaking = false;
      });
    }
  }

  // ----------------------------------------------------------
  // STOP AI VOICE
  // ----------------------------------------------------------

  Future<void> _stopSpeaking() async {
    try {
      await _tts.stop();
    } catch (_) {}

    if (!mounted) return;

    setState(() {
      _isSpeaking = false;
    });
  }

  // ----------------------------------------------------------
  // SEND MESSAGE
  // ----------------------------------------------------------

  Future<void> _sendMessage() async {
    final question = _controller.text.trim();

    if (question.isEmpty || _isTyping) {
      return;
    }

    if (_isListening) {
      await _stopListening();
    }

    _controller.clear();

    setState(() {
      _messages.add(
        ChatMessage(
          text: question,
          isUser: true,
          time: DateTime.now(),
        ),
      );

      _isTyping = true;
    });

    _scrollToBottom();

    // Simulate AI thinking.
    await Future.delayed(
      const Duration(milliseconds: 900),
    );

    final response = _generateLocalResponse(question);

    if (!mounted) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: response,
          isUser: false,
          time: DateTime.now(),
        ),
      );

      _isTyping = false;
    });

    _scrollToBottom();

    // Automatically speak AI response.
    await Future.delayed(
      const Duration(milliseconds: 200),
    );

    if (mounted) {
      _speak(response);
    }
  }

  // ==========================================================
  // LOCAL AI RESPONSE
  // ==========================================================

  String _generateLocalResponse(String question) {
    final q = question.toLowerCase();

    if (q.contains('hello') ||
        q.contains('hi') ||
        q.contains('hey')) {
      return 'Hello! 👋 How can I help you with your studies today?';
    }

    if (q.contains('photosynthesis')) {
      return '''
Photosynthesis is the process by which green plants make their own food.

Plants use:
• Sunlight
• Carbon dioxide
• Water

to produce glucose and oxygen.

The simplified equation is:

6CO₂ + 6H₂O → C₆H₁₂O₆ + 6O₂

Chlorophyll absorbs the sunlight required for this process.

In simple words, plants use sunlight to convert water and carbon dioxide into food and release oxygen.
''';
    }

    if (q.contains('newton') &&
        (q.contains('first') || q.contains('1st'))) {
      return '''
Newton's First Law of Motion is also called the law of inertia.

It states that an object remains at rest or continues moving with constant velocity unless an external unbalanced force acts on it.

Example:

A book lying on a table remains at rest until someone applies a force to move it.

Another example is a passenger moving forward when a moving bus suddenly stops.

The important idea is that objects resist changes in their state of motion.
''';
    }

    if (q.contains('java')) {
      return '''
Here is a simple Java program:

public class Main {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}

The main() method is the starting point of a Java application.

public means the method can be accessed by the Java runtime.

static means Java can call it without creating an object.

void means the method does not return a value.
''';
    }

    if (q.contains('quantum')) {
      return '''
Quantum physics is the branch of physics that describes matter and energy at very small scales, such as atoms and subatomic particles.

Some important ideas are:

• Quantization
• Wave-particle duality
• Superposition
• Uncertainty principle
• Quantum entanglement

Unlike classical physics, quantum mechanics often describes outcomes using probabilities.
''';
    }

    if (q.contains('flutter')) {
      return '''
Flutter is a UI framework developed by Google for building applications from a single codebase.

Flutter uses Dart.

A Flutter application is generally constructed using widgets.

For example:

MaterialApp
    ↓
Scaffold
    ↓
AppBar
    ↓
Body
    ↓
Widgets

Flutter can be used to build Android, iOS, web and desktop applications.
''';
    }

    if (q.contains('physics')) {
      return '''
Physics is the study of matter, energy, motion, forces and the fundamental laws of nature.

Major areas include:

• Mechanics
• Thermodynamics
• Electromagnetism
• Optics
• Quantum physics
• Relativity
• Nuclear physics
• Particle physics

If you tell me a specific Physics topic, I can explain it step by step.
''';
    }

    if (q.contains('math') ||
        q.contains('mathematics')) {
      return '''
I can help you with Mathematics topics such as:

• Algebra
• Geometry
• Trigonometry
• Calculus
• Probability
• Statistics
• Differential equations

Send me a problem and I can explain the solution step by step.
''';
    }

    if (q.contains('help')) {
      return '''
I can help you study many subjects.

Try asking:

• Explain a Physics concept
• Solve a Mathematics problem
• Write a Java program
• Explain Flutter
• Explain photonics
• Summarize a topic
• Create study questions
''';
    }

    return '''
I understand your question:

"$question"

This mobile demo is currently using a local AI-response engine rather than an online AI model.

You can still test the complete voice-chat experience.

Try questions such as:

• Explain Newton's first law
• What is photosynthesis?
• Give me a Java program
• What is quantum physics?
• Explain Flutter
• Explain Physics
''';
  }

  // ==========================================================
  // SCROLL
  // ==========================================================

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  // ==========================================================
  // NEW CHAT
  // ==========================================================

  Future<void> _newChat() async {
    await _stopSpeaking();

    if (_isListening) {
      await _stopListening();
    }

    setState(() {
      _messages.clear();

      _messages.add(
        ChatMessage(
          text:
          'New conversation started. 👋\n\n'
              'What would you like to learn today?',
          isUser: false,
          time: DateTime.now(),
        ),
      );
    });

    _scrollToBottom();
  }

  // ==========================================================
  // ATTACHMENT SHEET
  // ==========================================================

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Add to chat',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _attachmentItem(
                  Icons.photo_outlined,
                  'Photo',
                  'Choose an image',
                ),
                _attachmentItem(
                  Icons.picture_as_pdf_outlined,
                  'PDF',
                  'Add a PDF document',
                ),
                _attachmentItem(
                  Icons.insert_drive_file_outlined,
                  'File',
                  'Choose a file',
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _attachmentItem(
      IconData icon,
      String title,
      String subtitle,
      ) {
    return ListTile(
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF4FF),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF2563EB),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(subtitle),
      onTap: () {
        Navigator.pop(context);

        _showSnackBar(
          '$title attachment is not connected in this offline demo.',
        );
      },
    );
  }

  // ==========================================================
  // ABOUT
  // ==========================================================

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'AI Study Assistant',
          ),
          content: const Text(
            'Mobile voice-enabled AI study assistant.\n\n'
                'Speech recognition converts your voice to text, '
                'and text-to-speech reads the AI response aloud.\n\n'
                'This version does not require FastAPI.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // SNACKBAR
  // ==========================================================

  void _showSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ==========================================================
  // TIME
  // ==========================================================

  String _formatTime(DateTime time) {
    final hour = time.hour == 0
        ? 12
        : time.hour > 12
        ? time.hour - 12
        : time.hour;

    final minute = time.minute.toString().padLeft(2, '0');

    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _micAnimationController.dispose();

    _speech.stop();
    _tts.stop();

    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: _buildChat(),
            ),

            if (_messages.length <= 2)
              _buildSuggestions(),

            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // APP BAR
  // ==========================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2563EB),
                  Color(0xFF7C3AED),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Study Assistant',
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Voice enabled',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: 'New chat',
          onPressed: _newChat,
          icon: const Icon(
            Icons.add_comment_outlined,
            color: Color(0xFF374151),
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'new') {
              _newChat();
            }

            if (value == 'about') {
              _showAbout();
            }
          },
          itemBuilder: (context) {
            return const [
              PopupMenuItem(
                value: 'new',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(width: 12),
                    Text('New chat'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'about',
                child: Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 12),
                    Text('About'),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  // ==========================================================
  // CHAT
  // ==========================================================

  Widget _buildChat() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(
        16,
        20,
        16,
        20,
      ),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isTyping && index == _messages.length) {
          return const TypingIndicator();
        }

        return _buildMessage(
          _messages[index],
        );
      },
    );
  }

  // ==========================================================
  // MESSAGE
  // ==========================================================

  Widget _buildMessage(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _buildAiAvatar(),
            const SizedBox(width: 9),
          ],

          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 360,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? const Color(0xFF2563EB)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(
                        isUser ? 18 : 4,
                      ),
                      bottomRight: Radius.circular(
                        isUser ? 4 : 18,
                      ),
                    ),
                    border: isUser
                        ? null
                        : Border.all(
                      color: const Color(0xFFE5E7EB),
                    ),
                    boxShadow: isUser
                        ? null
                        : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.035),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : const Color(0xFF1F2937),
                      fontSize: 15.5,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.time),
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 10,
                      ),
                    ),

                    if (!isUser) ...[
                      const SizedBox(width: 6),

                      GestureDetector(
                        onTap: () {
                          if (_isSpeaking) {
                            _stopSpeaking();
                          } else {
                            _speak(message.text);
                          }
                        },
                        child: Icon(
                          _isSpeaking
                              ? Icons.stop_circle_outlined
                              : Icons.volume_up_outlined,
                          size: 17,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          if (isUser) ...[
            const SizedBox(width: 9),
            _buildUserAvatar(),
          ],
        ],
      ),
    );
  }

  // ==========================================================
  // AI AVATAR
  // ==========================================================

  Widget _buildAiAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2563EB),
            Color(0xFF7C3AED),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.auto_awesome,
        color: Colors.white,
        size: 19,
      ),
    );
  }

  // ==========================================================
  // USER AVATAR
  // ==========================================================

  Widget _buildUserAvatar() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.person_outline,
        color: Color(0xFF4B5563),
        size: 20,
      ),
    );
  }

  // ==========================================================
  // SUGGESTIONS
  // ==========================================================

  Widget _buildSuggestions() {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          return ActionChip(
            backgroundColor: Colors.white,
            side: const BorderSide(
              color: Color(0xFFDDE3EE),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            label: Text(
              _suggestions[index],
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF374151),
              ),
            ),
            onPressed: () {
              _controller.text = _suggestions[index];

              _controller.selection =
                  TextSelection.fromPosition(
                    TextPosition(
                      offset: _controller.text.length,
                    ),
                  );

              _sendMessage();
            },
          );
        },
      ),
    );
  }

  // ==========================================================
  // INPUT AREA
  // ==========================================================

  Widget _buildInputArea() {
    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      duration: const Duration(
        milliseconds: 200,
      ),
      padding: EdgeInsets.only(
        bottom: bottomInset,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          12,
          8,
          12,
          10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              tooltip: 'Attachment',
              onPressed: _showAttachmentOptions,
              icon: const Icon(
                Icons.add,
                color: Color(0xFF6B7280),
              ),
            ),

            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 48,
                  maxHeight: 130,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F5F9),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 5,
                  textCapitalization:
                  TextCapitalization.sentences,
                  textInputAction:
                  TextInputAction.newline,
                  decoration: const InputDecoration(
                    hintText: 'Ask anything...',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 13,
                    ),
                  ),
                  onSubmitted: (_) {
                    _sendMessage();
                  },
                ),
              ),
            ),

            const SizedBox(width: 6),

            _buildMicrophoneButton(),

            const SizedBox(width: 4),

            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // MICROPHONE BUTTON
  // ==========================================================

  Widget _buildMicrophoneButton() {
    return GestureDetector(
      onTap: _startListening,
      child: AnimatedBuilder(
        animation: _micAnimationController,
        builder: (context, child) {
          final scale = _isListening
              ? _micAnimationController.value
              : 1.0;

          return Transform.scale(
            scale: scale,
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _isListening
                    ? const Color(0xFFDC2626)
                    : const Color(0xFFEFF4FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isListening
                    ? Icons.stop
                    : Icons.mic_none,
                color: _isListening
                    ? Colors.white
                    : const Color(0xFF2563EB),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==========================================================
  // SEND BUTTON
  // ==========================================================

  Widget _buildSendButton() {
    return GestureDetector(
      onTap: _sendMessage,
      child: Container(
        width: 46,
        height: 46,
        decoration: const BoxDecoration(
          color: Color(0xFF2563EB),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_upward,
          color: Colors.white,
          size: 21,
        ),
      ),
    );
  }
}

// ============================================================
// TYPING INDICATOR
// ============================================================

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() =>
      _TypingIndicatorState();
}

class _TypingIndicatorState
    extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dot(double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value =
        ((_controller.value + delay) % 1.0);

        final opacity =
            0.35 + (value < 0.5 ? value : 1 - value);

        return Opacity(
          opacity: opacity,
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF6B7280),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2563EB),
                  Color(0xFF7C3AED),
                ],
              ),
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 19,
            ),
          ),

          const SizedBox(width: 9),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 17,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(
                color: Color(0xFFE5E7EB),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dot(0.0),
                const SizedBox(width: 5),
                _dot(0.15),
                const SizedBox(width: 5),
                _dot(0.30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}