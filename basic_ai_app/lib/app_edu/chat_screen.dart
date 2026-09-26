import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? time,
  }) : time = time ?? DateTime.now();
}

class ChatScreen extends StatefulWidget {
  final bool embedded;

  const ChatScreen({
    super.key,
    this.embedded = false,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isTyping = false;

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "Hi Shruthi! 👋\n\nI'm your AI Career Assistant. I can help you with interviews, resumes, coding, career planning and more.\n\nHow can I help you today?",
      isUser: false,
    ),
  ];

  final List<String> _suggestions = [
    "Prepare me for an interview",
    "Improve my resume",
    "Create a career roadmap",
    "Give me coding questions",
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // SEND MESSAGE
  // ----------------------------------------------------------

  void _sendMessage([String? suggestion]) {
    final text = (suggestion ?? _controller.text).trim();

    if (text.isEmpty || _isTyping) return;

    _controller.clear();

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
        ),
      );

      _isTyping = true;
    });

    _scrollToBottom();

    // Local fake AI response
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;

      final response = _generateResponse(text);

      setState(() {
        _messages.add(
          ChatMessage(
            text: response,
            isUser: false,
          ),
        );

        _isTyping = false;
      });

      _scrollToBottom();
    });
  }

  // ----------------------------------------------------------
  // LOCAL AI RESPONSE
  // ----------------------------------------------------------

  String _generateResponse(String message) {
    final text = message.toLowerCase();

    if (text.contains("interview")) {
      return """
Absolutely! I can help you prepare for your interview. 🎯

Let's work through these areas:

1. Tell me about yourself
2. Technical questions
3. Project-based questions
4. HR questions
5. Strengths and weaknesses
6. Salary expectations
7. Questions to ask the interviewer

Example:

"Tell me about yourself."

A good answer should include:
• Your education
• Your technical skills
• Your projects
• Your achievements
• Your career goal

Would you like me to start a mock interview?
""";
    }

    if (text.contains("resume") || text.contains("cv")) {
      return """
I can help you improve your resume. 📄

A strong resume should contain:

• Professional summary
• Education
• Technical skills
• Projects
• Internships
• Work experience
• Certifications
• Achievements

For a fresher, projects are especially important.

You can structure a project like this:

Project Name
→ Technology used
→ Problem solved
→ Your contribution
→ Result

If you paste your resume here, I can help you improve the content section by section.
""";
    }

    if (text.contains("roadmap") || text.contains("career")) {
      return """
Here's a general career-development roadmap 🚀

STEP 1 — Foundation
• Programming fundamentals
• Data structures
• Communication skills

STEP 2 — Technical Skills
• Choose your specialization
• Build practical projects
• Learn industry tools

STEP 3 — Portfolio
• GitHub projects
• Resume
• LinkedIn profile
• Certifications

STEP 4 — Interview Preparation
• Technical interviews
• Coding practice
• HR preparation
• Mock interviews

STEP 5 — Job Search
• Apply to suitable positions
• Network with professionals
• Attend career events

Tell me your field, and I can create a more specific roadmap.
""";
    }

    if (text.contains("coding") ||
        text.contains("programming") ||
        text.contains("java") ||
        text.contains("flutter") ||
        text.contains("dart")) {
      return """
Great! 💻 Let's practice coding.

Here are some beginner questions:

1. What is a variable?
2. What is a class?
3. What is inheritance?
4. What is polymorphism?
5. What is a constructor?
6. What is an interface?
7. What is exception handling?

For a coding interview, you should also practice:

• Arrays
• Strings
• Searching
• Sorting
• Recursion
• Linked lists
• Stacks
• Queues
• Trees
• Hash tables

If you're learning Flutter, we can also practice Dart and Flutter interview questions.
""";
    }

    if (text.contains("hello") || text.contains("hi") || text.contains("hey")) {
      return """
Hello! 👋

Nice to meet you!

I'm your Career Assistant. I can help you with:

🎯 Interview preparation
📄 Resume improvement
💻 Coding practice
🚀 Career roadmaps
📚 Learning plans
🧠 Technical concepts

What would you like to work on?
""";
    }

    if (text.contains("flutter")) {
      return """
Flutter is Google's UI framework for building applications from a single Dart codebase.

Important Flutter topics include:

• Widgets
• StatefulWidget
• StatelessWidget
• State management
• Navigation
• Forms
• REST APIs
• JSON
• Firebase
• Local storage
• Responsive UI

For an interview, you should understand the Flutter widget lifecycle and how StatefulWidget manages state.

Would you like a Flutter interview question?
""";
    }

    if (text.contains("thank")) {
      return """
You're very welcome! 😊

I'm always here to help you with your learning and career preparation.
""";
    }

    // Generic response
    return """
That's an interesting question. 👍

I can help you explore this topic.

You can ask me things such as:

• "Prepare me for an interview"
• "Improve my resume"
• "Create a career roadmap"
• "Give me Java questions"
• "Give me Flutter questions"
• "Explain Dart constructors"

Try one of these and I'll guide you step by step.
""";
  }

  // ----------------------------------------------------------
  // SCROLL
  // ----------------------------------------------------------

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // ----------------------------------------------------------
  // COPY MESSAGE
  // ----------------------------------------------------------

  void _copyMessage(String text) {
    Clipboard.setData(
      ClipboardData(text: text),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Message copied"),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // ----------------------------------------------------------
  // CLEAR CHAT
  // ----------------------------------------------------------

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Clear chat?"),
          content: const Text(
            "All messages in this conversation will be removed.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                setState(() {
                  _messages.clear();

                  _messages.add(
                    ChatMessage(
                      text:
                          "Hi Shruthi! 👋\n\nI'm your AI Career Assistant. How can I help you today?",
                      isUser: false,
                    ),
                  );
                });
              },
              child: const Text("Clear"),
            ),
          ],
        );
      },
    );
  }

  // ----------------------------------------------------------
  // ATTACHMENT BUTTON
  // ----------------------------------------------------------

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add Attachment",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text("Resume"),
                  subtitle: const Text("Upload your resume"),
                  onTap: () {
                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Resume upload will be available soon.",
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: const Text("Image"),
                  subtitle: const Text("Attach an image"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ----------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------

  Widget _buildHeader() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI Assistant",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: Color(0xFF22C55E),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Online",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: "New chat",
            onPressed: _clearChat,
            icon: const Icon(
              Icons.refresh_rounded,
              color: Colors.white70,
            ),
          ),
          if (widget.embedded)
            IconButton(
              tooltip: "Open",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChatScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.open_in_full_rounded,
                color: Colors.white70,
              ),
            ),
          if (widget.embedded)
            IconButton(
              tooltip: "Close",
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white70,
              ),
            ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // MESSAGE BUBBLE
  // ----------------------------------------------------------

  Widget _buildMessage(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 7,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            _avatar(false),
            const SizedBox(width: 9),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(
                    maxWidth: 650,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFF4F46E5) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    boxShadow: [
                      if (!isUser)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : const Color(0xFF1F2937),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(message.time),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 10,
                      ),
                    ),
                    if (!isUser) ...[
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _copyMessage(message.text),
                        child: Icon(
                          Icons.copy_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
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
            _avatar(true),
          ],
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // AVATAR
  // ----------------------------------------------------------

  Widget _avatar(bool user) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: user ? const Color(0xFFE0E7FF) : const Color(0xFFEDE9FE),
        shape: BoxShape.circle,
      ),
      child: Icon(
        user ? Icons.person_outline_rounded : Icons.smart_toy_rounded,
        size: 19,
        color: user ? const Color(0xFF4F46E5) : const Color(0xFF7C3AED),
      ),
    );
  }

  // ----------------------------------------------------------
  // TYPING INDICATOR
  // ----------------------------------------------------------

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          _avatar(false),
          const SizedBox(width: 9),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const _TypingDots(),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // SUGGESTIONS
  // ----------------------------------------------------------

  Widget _buildSuggestions() {
    return SizedBox(
      height: 45,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _suggestions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(
              _suggestions[index],
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF374151),
              ),
            ),
            backgroundColor: Colors.white,
            side: BorderSide(
              color: Colors.grey.shade300,
            ),
            onPressed: () {
              _sendMessage(_suggestions[index]);
            },
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // INPUT
  // ----------------------------------------------------------

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        14,
        10,
        14,
        14,
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
            onPressed: _showAttachmentOptions,
            icon: const Icon(
              Icons.attach_file_rounded,
              color: Color(0xFF6B7280),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: "Ask your AI assistant...",
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _sendMessage(),
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _isTyping ? Colors.grey : const Color(0xFF4F46E5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // TIME
  // ----------------------------------------------------------

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? "PM" : "AM";

    return "$hour:$minute $period";
  }

  // ----------------------------------------------------------
  // BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(
                        top: 12,
                        bottom: 10,
                      ),
                      itemCount: _messages.length + (_isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length) {
                          return _buildTypingIndicator();
                        }

                        return _buildMessage(
                          _messages[index],
                        );
                      },
                    ),
                  ),
                  _buildSuggestions(),
                  _buildInput(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// TYPING DOTS
// ============================================================

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final value = ((_controller.value * 3 - index) % 3) / 3;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Opacity(
                opacity: 0.3 + (value * 0.7),
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6B7280),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
