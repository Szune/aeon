import 'package:aeon/src/tokens.dart';
import 'package:aeon/version.dart';

class Token {
  Token(
      {this.type,
      this.text,
      this.intNum,
      this.doubleNum,
      this.version,
      this.line,
      this.col});
  final Tokens type;
  final String text;
  final int intNum;
  final double doubleNum;
  final int line;
  final int col;
  final Version version;
}
