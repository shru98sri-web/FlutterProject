import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const RubyCompilerApp());
}

class RubyCompilerApp extends StatelessWidget {
  const RubyCompilerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ruby Online Compiler',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF08111F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const RubyCompilerPage(),
    );
  }
}

class RubyCompilerPage extends StatefulWidget {
  const RubyCompilerPage({super.key});

  @override
  State<RubyCompilerPage> createState() => _RubyCompilerPageState();
}

class _RubyCompilerPageState extends State<RubyCompilerPage> {
  final TextEditingController codeController = TextEditingController(
    text: '''name = "World"

puts "Hello, #{name}!"
''',
  );

  final TextEditingController inputController = TextEditingController();

  String output = '';
  String error = '';
  bool running = false;
  int? executionTime;

  /*
   * Judge0 CE public API.
   *
   * For production, use your own backend/proxy instead of exposing
   * a third-party API directly from the application.
   */
  static const String apiUrl =
      'https://ce.judge0.com/submissions';

  /*
   * Ruby language ID in Judge0 CE.
   *
   * This ID can change between Judge0 deployments.
   * If your Judge0 server uses a different Ruby ID, change this value.
   */
  static const int rubyLanguageId = 72;

  @override
  void dispose() {
    codeController.dispose();
    inputController.dispose();
    super.dispose();
  }

  Future<void> runRuby() async {
    if (codeController.text.trim().isEmpty) {
      setState(() {
        output = '';
        error = 'Please enter Ruby code.';
      });
      return;
    }

    setState(() {
      running = true;
      output = '';
      error = '';
      executionTime = null;
    });

    final stopwatch = Stopwatch()..start();

    try {
      /*
       * STEP 1
       * Submit Ruby code.
       */
      final submitResponse = await http.post(
        Uri.parse('$apiUrl?base64_encoded=false&wait=false'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'language_id': rubyLanguageId,
          'source_code': codeController.text,
          'stdin': inputController.text,
        }),
      ).timeout(const Duration(seconds: 20));

      if (submitResponse.statusCode != 201) {
        throw Exception(
          'Submission failed.\n'
              'HTTP ${submitResponse.statusCode}\n'
              '${submitResponse.body}',
        );
      }

      final submitData = jsonDecode(submitResponse.body);

      final token = submitData['token'];

      if (token == null) {
        throw Exception('No submission token received.');
      }

      /*
       * STEP 2
       * Wait for execution result.
       */
      Map<String, dynamic>? result;

      for (int i = 0; i < 30; i++) {
        await Future.delayed(const Duration(milliseconds: 800));

        final resultResponse = await http.get(
          Uri.parse(
            '$apiUrl/$token?base64_encoded=false',
          ),
        ).timeout(const Duration(seconds: 10));

        if (resultResponse.statusCode != 200) {
          throw Exception(
            'Could not retrieve result.\n'
                'HTTP ${resultResponse.statusCode}',
          );
        }

        final data =
        jsonDecode(resultResponse.body) as Map<String, dynamic>;

        final status = data['status'];

        if (status != null) {
          final statusId = status['id'];

          /*
           * 1 = In Queue
           * 2 = Processing
           * 3+ = Finished
           */
          if (statusId != 1 && statusId != 2) {
            result = data;
            break;
          }
        }
      }

      stopwatch.stop();

      if (result == null) {
        throw Exception('Execution timed out.');
      }

      final stdout = result['stdout'] ?? '';
      final stderr = result['stderr'] ?? '';
      final compileOutput = result['compile_output'] ?? '';
      final message = result['message'] ?? '';

      final status = result['status'];
      final statusDescription =
      status != null ? status['description'] ?? '' : '';

      setState(() {
        executionTime = stopwatch.elapsedMilliseconds;

        output = stdout.toString();

        final errors = <String>[];

        if (compileOutput.toString().isNotEmpty) {
          errors.add(compileOutput.toString());
        }

        if (stderr.toString().isNotEmpty) {
          errors.add(stderr.toString());
        }

        if (message.toString().isNotEmpty) {
          errors.add(message.toString());
        }

        if (errors.isEmpty &&
            statusDescription.toString().isNotEmpty &&
            statusDescription != 'Accepted') {
          errors.add(statusDescription.toString());
        }

        error = errors.join('\n');
      });
    } on TimeoutException {
      setState(() {
        error = 'Request timed out.';
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      stopwatch.stop();

      if (mounted) {
        setState(() {
          running = false;
        });
      }
    }
  }

  void clearAll() {
    setState(() {
      codeController.clear();
      inputController.clear();
      output = '';
      error = '';
      executionTime = null;
    });
  }

  void loadExample(String code) {
    setState(() {
      codeController.text = code;
      output = '';
      error = '';
    });
  }

  Widget buildEditor() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B1626),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.code,
                  color: Color(0xFF7C3AED),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Ruby Code',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Ruby',
                    style: TextStyle(
                      color: Color(0xFFC4B5FD),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: codeController,
              expands: true,
              maxLines: null,
              minLines: null,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                height: 1.5,
              ),
              cursorColor: const Color(0xFFA78BFA),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
                hintText: 'Write Ruby code here...',
                hintStyle: TextStyle(
                  color: Colors.white38,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInput() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF0B1626),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Row(
              children: [
                Icon(
                  Icons.input,
                  size: 19,
                  color: Color(0xFF22D3EE),
                ),
                SizedBox(width: 8),
                Text(
                  'Standard Input',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: inputController,
              maxLines: null,
              expands: true,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                hintText: 'Enter program input...',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOutput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B1626),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  error.isNotEmpty
                      ? Icons.error_outline
                      : Icons.terminal,
                  color: error.isNotEmpty
                      ? Colors.redAccent
                      : const Color(0xFF22D3EE),
                ),
                const SizedBox(width: 10),
                Text(
                  error.isNotEmpty ? 'Error' : 'Output',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                if (executionTime != null)
                  Text(
                    '${executionTime} ms',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                error.isNotEmpty
                    ? error
                    : output.isEmpty
                    ? 'Program output will appear here...'
                    : output,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  height: 1.5,
                  color: error.isNotEmpty
                      ? Colors.redAccent
                      : output.isEmpty
                      ? Colors.white38
                      : Colors.greenAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildExamples() {
    return PopupMenuButton<String>(
      tooltip: 'Examples',
      icon: const Icon(Icons.folder_open),
      onSelected: loadExample,
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: '''puts "Hello World"''',
            child: Text('Hello World'),
          ),
          const PopupMenuItem(
            value: '''a = 10
b = 20

puts a + b''',
            child: Text('Addition'),
          ),
          const PopupMenuItem(
            value: '''number = 10

if number.even?
  puts "Even"
else
  puts "Odd"
end''',
            child: Text('Even / Odd'),
          ),
          const PopupMenuItem(
            value: '''numbers = [1, 2, 3, 4, 5]

numbers.each do |number|
  puts number
end''',
            child: Text('Array Loop'),
          ),
          const PopupMenuItem(
            value: '''def factorial(n)
  if n <= 1
    1
  else
    n * factorial(n - 1)
  end
end

puts factorial(5)''',
            child: Text('Factorial'),
          ),
        ];
      },
    );
  }

  Widget buildTopBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1626),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.terminal,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ruby Compiler',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Online Code Execution',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
          const Spacer(),
          buildExamples(),
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Clear',
            onPressed: clearAll,
            icon: const Icon(Icons.delete_outline),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: running ? null : runRuby,
            icon: running
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Icon(Icons.play_arrow),
            label: Text(
              running ? 'Running...' : 'Run',
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF7C3AED),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            buildTopBar(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 950;

                  if (wide) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: Column(
                              children: [
                                Expanded(
                                  child: buildEditor(),
                                ),
                                const SizedBox(height: 12),
                                buildInput(),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 4,
                            child: buildOutput(),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 500,
                          child: buildEditor(),
                        ),
                        const SizedBox(height: 12),
                        buildInput(),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 350,
                          child: buildOutput(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}