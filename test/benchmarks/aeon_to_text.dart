import 'package:aeon/aeon.dart';
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
    _aeon = Aeon(variables: {
      'name': 'test',
      'names': generateStuff(),
      'person': {'first': 'person first', 'last': 'person last'},
    }, macros: {
      'name': Macro(name: 'name', args: ['first', 'last'])
    });
    print('starting benchmark');
  }

  void teardown() {
    // not measured
  }
}
