import 'package:flutter/material.dart';
import 'package:vocab_builder/main.dart';

class VocabularyAIApp extends StatelessWidget {
  const VocabularyAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocabulary AI-ML App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF08111F),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
      ),
      home: const VocabularyHome(),
    );
  }
}

// ============================================================
// VOCABULARY MODEL
// ============================================================

class VocabularyWord {
  final dynamic id;
  final String word;
  final String letter;

  final String difficultCefrStyle;
  final String difficulty;

  final String partsOfSpeech;

  final String definition;
  final String meaning;

  final List<String> synonyms;

  final String example;

  final String gmatRelevance;
  final String ieltsRelevance;

  final String usage;

  final String currentStatus;
  final String yearFocus;

  final List<String> sourceReference;
  final String sourceNote;

  VocabularyWord({
    required this.id,
    required this.word,
    required this.letter,
    required this.difficultCefrStyle,
    required this.difficulty,
    required this.partsOfSpeech,
    required this.definition,
    required this.meaning,
    required this.synonyms,
    required this.example,
    required this.gmatRelevance,
    required this.ieltsRelevance,
    required this.usage,
    required this.currentStatus,
    required this.yearFocus,
    required this.sourceReference,
    required this.sourceNote,
  });

  factory VocabularyWord.fromJson(Map<String, dynamic> json) {
    return VocabularyWord(
      id: json['id'],

      word: '${json['word'] ?? ''}',
      letter: '${json['letter'] ?? ''}',

      // Supports both spellings.
      difficultCefrStyle:
          '${json['difficult_cefr_style'] ?? json['difficulty_cefr_style'] ?? ''}',

      difficulty: '${json['difficulty'] ?? ''}',

      // Supports user's new field and older JSON field.
      partsOfSpeech:
          '${json['parts_of_speech'] ?? json['part_of_speech'] ?? ''}',

      definition: '${json['definition'] ?? ''}',
      meaning: '${json['meaning'] ?? ''}',

      synonyms: _stringList(json['synonyms']),

      example: '${json['example'] ?? ''}',

      // Supports requested spelling + existing file spelling.
      gmatRelevance:
          '${json['gmat_relavance'] ?? json['gmat_relevance'] ?? ''}',

      ieltsRelevance:
          '${json['ielts_relavance'] ?? json['ielts_relevance'] ?? ''}',

      usage: '${json['usage'] ?? ''}',

      currentStatus: '${json['current_status'] ?? ''}',
      yearFocus: '${json['year_focus'] ?? ''}',

      sourceReference: _stringList(json['source_reference']),

      sourceNote: '${json['source_note'] ?? ''}',
    );
  }

  static List<String> _stringList(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      return value.map((e) => '$e').toList();
    }

    if (value is String && value.trim().isNotEmpty) {
      return [value];
    }

    return [];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'letter': letter,
      'difficult_cefr_style': difficultCefrStyle,
      'difficulty': difficulty,
      'parts_of_speech': partsOfSpeech,
      'definition': definition,
      'meaning': meaning,
      'synonyms': synonyms,
      'example': example,
      'gmat_relavance': gmatRelevance,
      'ielts_relavance': ieltsRelevance,
      'usage': usage,
      'current_status': currentStatus,
      'year_focus': yearFocus,
      'source_reference': sourceReference,
      'source_note': sourceNote,
    };
  }
}

// ============================================================
// TEST MODELS
// ============================================================

enum QuestionType { definition, meaning, example, synonym }

class TestQuestion {
  final VocabularyWord word;
  final QuestionType type;
  final List<String> options;
  final String correctAnswer;

  TestQuestion({
    required this.word,
    required this.type,
    required this.options,
    required this.correctAnswer,
  });

  String get questionText {
    switch (type) {
      case QuestionType.definition:
        return 'Which word matches this definition?\n\n${word.definition}';

      case QuestionType.meaning:
        return 'What is the meaning of "${word.word}"?';

      case QuestionType.example:
        return 'Which word best completes this context?\n\n"${word.example}"';

      case QuestionType.synonym:
        return 'Which option is closest in meaning to "${word.word}"?';
    }
  }
}

class TestAnswer {
  final TestQuestion question;
  final String selectedAnswer;
  final bool correct;
  final int seconds;

  TestAnswer({
    required this.question,
    required this.selectedAnswer,
    required this.correct,
    required this.seconds,
  });
}

class AssessmentRecord {
  final DateTime date;
  final int score;
  final int total;
  final double averageTime;
  final int voiceScore;
  final String level;

  AssessmentRecord({
    required this.date,
    required this.score,
    required this.total,
    required this.averageTime,
    required this.voiceScore,
    required this.level,
  });

  double get percentage {
    if (total == 0) return 0;
    return score / total * 100;
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'score': score,
    'total': total,
    'averageTime': averageTime,
    'voiceScore': voiceScore,
    'level': level,
  };

  factory AssessmentRecord.fromJson(Map<String, dynamic> json) {
    double n(dynamic v) => v is num ? v.toDouble() : double.tryParse('$v') ?? 0;
    return AssessmentRecord(
      date: DateTime.tryParse('${json['date']}') ?? DateTime.now(),
      score: json['score'] is num
          ? (json['score'] as num).toInt()
          : int.tryParse('${json['score']}') ?? 0,
      total: json['total'] is num
          ? (json['total'] as num).toInt()
          : int.tryParse('${json['total']}') ?? 0,
      averageTime: n(json['averageTime']),
      voiceScore: json['voiceScore'] is num
          ? (json['voiceScore'] as num).toInt()
          : int.tryParse('${json['voiceScore']}') ?? 0,
      level: '${json['level'] ?? 'Developing'}',
    );
  }
}
