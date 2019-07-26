import 'dart:convert';

import 'package:aeon/src/lexer.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

class LexerExpandedBenchmark extends BenchmarkBase {
  LexerExpandedBenchmark() : super("LexerExpanded");
  static void main() {
    LexerExpandedBenchmark().report();
  }

  String _text;

  void run() {
    // do
    final lexer = Lexer(text: _text);
    if (lexer.isEmpty()) throw Exception('lexer was empty');
    if (lexer.isEOF()) throw Exception('lexer was EOF');
    while (!lexer.isEOF()) {
      lexer.nextToken();
    }
  }

  String generateATonOfStuff() {
    StringBuffer stuff = StringBuffer();
    for (int i = 0; i < 1000000; i++) {
      stuff.write(''', {"fname": "fperson",  "lname": "lperson"}''');
    }
    return stuff.toString();
  }

  String generateStuff() {
    StringBuffer stuff = StringBuffer();
    for (int i = 0; i < 100000; i++) {
      stuff.write(''', {"fname": "fperson",  "lname": "lperson"}''');
    }
    return stuff.toString();
  }

  String generateLessStuff() {
    StringBuffer stuff = StringBuffer();
    for (int i = 0; i < 10000; i++) {
      stuff.write(''', {"fname": "fperson",  "lname": "lperson"}''');
    }
    return stuff.toString();
  }

  void setup() {
    // not measured
    _text = '''name: "test"
    names: [{"fname": "fperson", "lname": "lperson"}''' +
        generateLessStuff() +
        ''']
    person: {"fname": "person first", "lname": "person last"}
    ''';
    print(
        'generated ${_text.length} characters, ${utf8.encode(_text).length} bytes');
    print('starting benchmark');
  }

  void teardown() {
    // not measured
  }
}
