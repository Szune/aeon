import 'dart:convert';

import 'package:aeon/aeon.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

class AeonFromTextExpandedBenchmark extends BenchmarkBase {
  AeonFromTextExpandedBenchmark() : super("AeonFromTextExpanded");
  static void main() {
    AeonFromTextExpandedBenchmark().report();
  }

  String _text;

  void run() {
    // do
    Aeon.fromText(text: _text);
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
    _text = '''\'0.0.1 profile (-1)
    name: "test"
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
