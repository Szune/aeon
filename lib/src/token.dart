import 'tokens.dart';

class Token {
  Token(
      {this.type, this.text, this.intNum, this.doubleNum, this.line, this.col});
  final Tokens type;
  final String text;
  final int intNum;
  final double doubleNum;
  final int line;
  final int col;
}
