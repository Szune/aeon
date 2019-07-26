import 'package:test/test.dart';
import 'benchmarks/aeon_from_text.dart';
import 'benchmarks/aeon_from_text_expanded.dart';
import 'benchmarks/aeon_to_text.dart';
import 'benchmarks/json_decode.dart';
import 'benchmarks/lexer.dart';
import 'benchmarks/lexer_expanded.dart';
import 'benchmarks/parser.dart';
import 'benchmarks/parser_expanded.dart';

void main() {
  test('benchmark Aeon.toText()', () {
    AeonToTextBenchmark.main();
  });
  test('benchmark Aeon.fromText()', () {
    AeonFromTextBenchmark.main();
  });
  test('benchmark expanded Aeon.fromText()', () {
    AeonFromTextExpandedBenchmark.main();
  });
  test('benchmark jsonDecode()', () {
    JsonDecodeBenchmark.main();
  });
  test('benchmark lexer w/ macro', () {
    LexerBenchmark.main();
  });
  test('benchmark lexer expanded', () {
    LexerExpandedBenchmark.main();
  });
  test('benchmark parser expanded w/ macro', () {
    ParserBenchmark.main();
  });
  test('benchmark parser expanded', () {
    ParserExpandedBenchmark.main();
  });
}
