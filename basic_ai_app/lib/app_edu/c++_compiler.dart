import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: CppCompilerPage(),
  ));
}

class CppCompilerPage extends StatefulWidget {
  const CppCompilerPage({super.key});

  @override
  State<CppCompilerPage> createState() => _CppCompilerPageState();
}

class _CppCompilerPageState extends State<CppCompilerPage> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController inputController = TextEditingController();

  String output = '';
  String compileError = '';
  bool isRunning = false;

// ------------------------------------------------------------
// YOUR BACKEND URL
// ------------------------------------------------------------
//
// Example:
// http://10.0.2.2:8000
//
// Android emulator:
// 10.0.2.2
//
// Physical phone:
// use your computer's LAN IP, for example:
// http://192.168.1.10:8000
//
// Production:
// https://your-domain.com
//
  static const String backendUrl = 'http://10.0.2.2:8000';

  @override
  void initState() {
    super.initState();

    codeController.text = '''
#include <iostream>
using namespace std;

int main() {
    int a, b;

    cin >> a >> b;

    int sum = a + b;

    cout << "Sum = " << sum << endl;

    return 0;
}
''';
  }

// ------------------------------------------------------------
// COMPILE AND RUN
// ------------------------------------------------------------

  Future<void> compileAndRun() async {
    FocusScope.of(context).unfocus();

    setState(() {
      isRunning = true;
      output = '';
      compileError = '';
    });

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'code': codeController.text,
          'input': inputController.text,
          'language': 'cpp',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          output = data['output']?.toString() ?? '';
          compileError = data['error']?.toString() ?? '';
        });
      } else {
        setState(() {
          compileError =
              'Server error: ${response.statusCode}\n${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        compileError = 'Could not connect to compiler server.\n\n'
            'Make sure your FastAPI server is running.\n\n'
            'Error:\n$e';
      });
    } finally {
      setState(() {
        isRunning = false;
      });
    }
  }

// ------------------------------------------------------------
// LOAD EXAMPLE
// ------------------------------------------------------------

  void loadExample() {
    setState(() {
      codeController.text = '''
#include <iostream>
using namespace std;

int main() {

    int n;

    cout << "Enter a number: ";
    cin >> n;

    if (n % 2 == 0) {
        cout << n << " is Even" << endl;
    } else {
        cout << n << " is Odd" << endl;
    }

    return 0;
}
''';

      inputController.text = '10';

      output = '';
      compileError = '';
    });
  }

// ------------------------------------------------------------
// CLEAR
// ------------------------------------------------------------

  void clearAll() {
    setState(() {
      codeController.clear();
      inputController.clear();
      output = '';
      compileError = '';
    });
  }

  @override
  void dispose() {
    codeController.dispose();
    inputController.dispose();
    super.dispose();
  }

// ------------------------------------------------------------
// UI
// ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08111F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1626),
        elevation: 0,
        title: const Row(
          children: [
            Icon(
              Icons.code,
              color: Color(0xFF22D3EE),
            ),
            SizedBox(width: 10),
            Text(
              'C++ Online Compiler',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Load Example',
            onPressed: loadExample,
            icon: const Icon(
              Icons.file_open,
              color: Colors.white,
            ),
          ),
          IconButton(
            tooltip: 'Clear',
            onPressed: clearAll,
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
// ------------------------------------------------
// HEADER
// ------------------------------------------------

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1626),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.terminal,
                            color: Color(0xFF22D3EE),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'C++ Compiler',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Write, compile and run C++ programs',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

// ------------------------------------------------
// CODE EDITOR
// ------------------------------------------------

                  const Text(
                    'C++ SOURCE CODE',
                    style: TextStyle(
                      color: Color(0xFF22D3EE),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    height: 420,
                    decoration: BoxDecoration(
                      color: const Color(0xFF050B14),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.10),
                      ),
                    ),
                    child: TextField(
                      controller: codeController,
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                      cursorColor: const Color(0xFF22D3EE),
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                        hintText: '// Write your C++ code here...',
                        hintStyle: TextStyle(
                          color: Colors.white38,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

// ------------------------------------------------
// INPUT
// ------------------------------------------------

                  const Text(
                    'STANDARD INPUT',
                    style: TextStyle(
                      color: Color(0xFF22D3EE),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1626),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TextField(
                      controller: inputController,
                      maxLines: 5,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'monospace',
                      ),
                      decoration: const InputDecoration(
                        hintText:
                            'Enter input for your program...\nExample: 10 20',
                        hintStyle: TextStyle(
                          color: Colors.white38,
                        ),
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

// ------------------------------------------------
// RUN BUTTON
// ------------------------------------------------

                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: isRunning ? null : compileAndRun,
                      icon: isRunning
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.play_arrow,
                              size: 26,
                            ),
                      label: Text(
                        isRunning ? 'COMPILING...' : 'COMPILE & RUN',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            const Color(0xFF2563EB).withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

// ------------------------------------------------
// OUTPUT
// ------------------------------------------------

                  const Text(
                    'OUTPUT',
                    style: TextStyle(
                      color: Color(0xFF22D3EE),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      minHeight: 180,
                    ),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.10),
                      ),
                    ),
                    child: output.isEmpty && compileError.isEmpty
                        ? const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Program output will appear here...',
                              style: TextStyle(
                                color: Colors.white38,
                                fontFamily: 'monospace',
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (output.isNotEmpty)
                                SelectableText(
                                  output,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'monospace',
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              if (compileError.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                SelectableText(
                                  compileError,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: 'monospace',
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ],
                          ),
                  ),

                  const SizedBox(height: 20),

// ------------------------------------------------
// INFO
// ------------------------------------------------

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(
                          0xFF2563EB,
                        ).withOpacity(0.20),
                      ),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Color(0xFF22D3EE),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Your C++ source is sent to the compiler server, compiled with a C++ compiler, executed in a sandbox, and the result is returned here.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
