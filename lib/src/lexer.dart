import 'token.dart';
import 'tokens.dart';

class Lexer {
  Lexer({String text}) : assert(text != null) {
    if (text == null) throw Exception('Lexer input cannot be null.');
    _runes = text.runes.iterator;
    if (!_runes.moveNext())
      _isEmpty = true;
    else
      _isEmpty = false;
  }
  bool _isEmpty;
  RuneIterator _runes;
  int _line = 1;
  int _col = 1;

  static Set<int> identifierCharacters =
      '_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'.runes.toSet();

  static Set<int> extendedIdentifierCharacters =
      '_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
          .runes
          .toSet();

  static const Set<int> whitespaceCharacters = {
    tab, // tab (\t)
    newline, // newline (\n)
    carriageReturn, // carriage-return (\r)
    space, // space ( )
  };

  static const int tab = 9;

  /// \n
  static const int newline = 10;
  static const int carriageReturn = 13;
  static const int space = 32;
  static const int quote = 34;
  //static const int apostrophe = 39;
  static const int backslash = 92;
  static const int colon = 58;
  static const int atSymbol = 64;
  static const int leftBrace = 123;
  static const int rightBrace = 125;
  static const int leftParenthesis = 40;
  static const int rightParenthesis = 41;
  static const int leftBracket = 91;
  static const int rightBracket = 93;
  static const int leftAngleBracket = 60;
  static const int rightAngleBracket = 62;
  static const int comma = 44;
  static const int minus = 45;
  static const int dot = 46;
  static const int square = 35; // #
  static const int exclamation = 33; // !
  static const int n0 = 48; // 0
  static const int n1 = 49; // 1
  static const int n2 = 50; // 2
  static const int n3 = 51; // 3
  static const int n4 = 52; // 4
  static const int n5 = 53; // 5
  static const int n6 = 54; // 6
  static const int n7 = 55; // 7
  static const int n8 = 56; // 8
  static const int n9 = 57; // 9

  int getCurrent() => _runes.current;

  bool isEmpty() => _isEmpty;

  bool moveNext() {
    if (_runes.moveNext()) {
      _col++;
      return true;
    }
    return false;
  }

  bool movePrevious() {
    if (_runes.movePrevious()) {
      _col--;
      return true;
    }
    return false;
  }

  void moveToNextLine() {
    int read;
    do {
      read = getCurrent();
      if (read == newline) {
        _line++;
        _col = 1;
        return;
      }
    } while (moveNext());
  }

  void skipWhitespaceAndComments() {
    do {
      if (isEOF()) return;
      int read = getCurrent();
      if (read == newline) {
        _line++;
        _col = 1;
      } else if (whitespaceCharacters.contains(read)) {
        continue;
      } else if (read == square) {
        moveToNextLine();
      } else {
        return;
      }
    } while (moveNext());
  }

  static bool isNumber(int char) {
    switch (char) {
      case Lexer.n0:
      case Lexer.n1:
      case Lexer.n2:
      case Lexer.n3:
      case Lexer.n4:
      case Lexer.n5:
      case Lexer.n6:
      case Lexer.n7:
      case Lexer.n8:
      case Lexer.n9:
        return true;
      default:
        return false;
    }
  }

  bool isEOF() => _runes.current == null;

  Token nextToken() {
    skipWhitespaceAndComments();
    int read = getCurrent();
    if (read == null) return Token(type: Tokens.EOF, line: _line, col: _col);
    if (read == quote) // string start
      return Token(
          type: Tokens.string, text: getString(), line: _line, col: _col);
    if (isNumberStart(read)) return getNumberToken();
    if (identifierCharacters.contains(read)) return getIdentifier();
    Token token;
    switch (read) {
      case leftBracket:
        token = Token(type: Tokens.leftBracket, line: _line, col: _col);
        break;
      case rightBracket:
        token = Token(type: Tokens.rightBracket, line: _line, col: _col);
        break;
      case leftBrace:
        token = Token(type: Tokens.leftBrace, line: _line, col: _col);
        break;
      case rightBrace:
        token = Token(type: Tokens.rightBrace, line: _line, col: _col);
        break;
      case leftParenthesis:
        token = Token(type: Tokens.leftParenthesis, line: _line, col: _col);
        break;
      case rightParenthesis:
        token = Token(type: Tokens.rightParenthesis, line: _line, col: _col);
        break;
      case colon:
        token = Token(type: Tokens.colon, line: _line, col: _col);
        break;
      case comma:
        token = Token(type: Tokens.comma, line: _line, col: _col);
        break;
      case atSymbol:
        token = Token(type: Tokens.atSymbol, line: _line, col: _col);
        break;
      default:
        throw Exception(
            'Unknown token "${String.fromCharCode(getCurrent() ?? 0)}" (char code: ${getCurrent()})');
    }
    moveNext();
    return token;
  }

  String getString() {
    moveNext(); // skip first quote
    bool previousWasEscape = false;
    int read;
    List<int> string = [];
    bool wasTerminated = false;

    do {
      read = getCurrent();
      if (!previousWasEscape && read == backslash) {
        previousWasEscape = true;
      } else if (previousWasEscape && read == quote) {
        // escaped quote
        string.add(quote);
        previousWasEscape = false;
      } else if (previousWasEscape && read == backslash) {
        // escaped backslash
        string.add(backslash);
        previousWasEscape = false;
      } else if (!previousWasEscape && read == quote) {
        // found end of string
        wasTerminated = true;
        break;
      } else {
        // add to string
        previousWasEscape = false;
        string.add(read);
      }
    } while (moveNext());
    String returnString = String.fromCharCodes(string);
    if (!wasTerminated) throw Exception('String not terminated: $returnString');
    moveNext(); // skip last quote
    return returnString;
  }

  static bool isNumberStart(int char) {
    return isNumber(char) || char == minus;
  }

  Token getNumberToken() {
    int read;
    List<int> string = [];
    bool hasDecimal = false;
    do {
      read = getCurrent();
      if (read == minus) {
        // negative number
        if (string.isEmpty) {
          string.add(read);
        } else {
          throw Exception('Negative number char inside number.');
        }
      } else if (isNumber(read)) {
        string.add(read);
      } else {
        if (read == dot) {
          // decimal separator
          if (string.isEmpty) {
            throw Exception('Decimal separator at the start of number.');
          }
          if (!hasDecimal) {
            hasDecimal = true;
            string.add(dot);
          } else {
            throw Exception('Too many decimal separators.');
          }
        } else {
          break;
        }
      }
    } while (moveNext());
    if (string.length == 1 && string[0] == minus)
      throw Exception('Number starting and ending with negative number char.');
    String returnString = String.fromCharCodes(string);
    if (hasDecimal)
      return Token(
          type: Tokens.doubleNum,
          doubleNum: double.parse(returnString),
          line: _line,
          col: _col);
    else
      return Token(
          type: Tokens.intNum,
          intNum: int.parse(returnString),
          line: _line,
          col: _col);
  }

  Token getIdentifier() {
    List<int> identifier = [];
    // add first char as identifier
    int read = getCurrent();
    identifier.add(read);
    while (moveNext()) {
      read = getCurrent();
      if (extendedIdentifierCharacters.contains(read)) {
        identifier.add(read);
      } else {
        break;
      }
    }
    String identifierString = String.fromCharCodes(identifier);
    return Token(
        type: Tokens.identifier,
        text: identifierString,
        line: _line,
        col: _col);
  }
}
