import 'package:aeon/aeon.dart';
import 'package:aeon/macro.dart';
import 'package:aeon/tag.dart';
import 'package:aeon/version.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

class AeonToTextBenchmark extends BenchmarkBase {
  AeonToTextBenchmark() : super("AeonToText");
  static void main() {
    AeonToTextBenchmark().report();
  }

  Aeon _aeon;

  void run() {
    // do
    _aeon.toText();
  }

  List<Map<String, Object>> generateStuff() {
    List<Map<String, Object>> stuff = [];
    for (int i = 0; i < 1000000; i++) {
      stuff.add({'first': 'fperson3', 'last': 'lperson3'});
    }
    print(stuff.length);
    return stuff;
  }

  void setup() {
    // not measured
    _aeon = Aeon(
        tag: Tag(name: 'profile', version: Version(0, 0, 1), checksum: -1),
        variables: {
          'name': 'test',
          'names': generateStuff(),
          'person': {'first': 'person first', 'last': 'person last'},
        },
        macros: {
          'name': Macro(name: 'name', args: ['first', 'last'])
        });
  }

  void teardown() {
    // not measured
  }
}
