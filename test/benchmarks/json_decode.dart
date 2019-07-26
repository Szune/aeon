import 'dart:convert';

import 'package:benchmark_harness/benchmark_harness.dart';

class JsonDecodeBenchmark extends BenchmarkBase {
  JsonDecodeBenchmark() : super("JsonDecodeBenchmark");
  static void main() {
    JsonDecodeBenchmark().report();
  }

  String _text;

  void run() {
    // do
    jsonDecode(_text);
  }

  String generateStuff() {
    StringBuffer stuff = StringBuffer();
    for (int i = 0; i < 10000; i++) {
      stuff.write(''', {"fname": "fperson",  "lname": "lperson"}''');
    }
    return stuff.toString();
  }

  void setup() {
    // not measured
    _text = '''
    {
    "names": [{"fname": "fperson",  "lname": "lperson"}''' +
        generateStuff() +
        ''']
        }
    ''';
    print(
        'generated ${_text.length} characters, ${utf8.encode(_text).length} bytes');
    print('starting benchmark');
  }

  void teardown() {
    // not measured
  }
}
