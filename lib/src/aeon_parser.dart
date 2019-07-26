import 'package:aeon/aeon.dart';
import 'package:aeon/src/key_value_pair.dart';
import 'package:aeon/src/lexer.dart';
import 'package:aeon/macro.dart';
import 'package:aeon/src/token.dart';
import 'package:aeon/src/tokens.dart';

class AeonParser {
  AeonParser({this.lexer});
  final Lexer lexer;
  Token _currentToken;
  Token _nextToken;
  Map<String, Macro> macros = {};

  void _parseMacroDefinition() {
    consume(); // consume @ symbol
    var identifier = require(Tokens.identifier).text;
    require(Tokens.leftParenthesis);
    macros[identifier] = Macro(name: identifier);
    while (!match(Tokens.rightParenthesis)) {
      var arg = require(Tokens.string).text;
      macros[identifier].addArgument(arg);
      if (match(Tokens.comma)) {
        consume();
      }
    }
    consume(); // consume )
  }

  Object _parseMacro(String identifier) {
    require(Tokens.leftParenthesis);
    if (!macros.containsKey(identifier)) {
      throw Exception(
          'Macro "$identifier" is not defined yet. Make sure the macro definition comes before usage of it.');
    }
    var macro = macros[identifier];
    Map<String, Object> map = {};
    for (int i = 0; i < macro.length; i++) {
      var value = _parseValue();
      var transformed = macro.transform(i, value);
      map[transformed.key] = transformed.value;
      if (match(Tokens.comma)) consume();
    }
    require(Tokens.rightParenthesis);
    return map;
  }

  KeyValuePair<Object, Object> _parseKvp() {
    Object key;
    // key
    if (match(Tokens.string)) {
      key = require(Tokens.string).text;
    } else if (match(Tokens.intNum)) {
      key = require(Tokens.intNum).intNum;
    } else {
      throw Exception('Unexpected key token: ${_currentToken.type}');
    }
    require(Tokens.colon);
    // value
    Object value = _parseValue();
    return KeyValuePair(key: key, value: value);
  }

  Object _parseValue() {
    Object value;
    var next = consume();
    switch (next.type) {
      case Tokens.identifier:
        value = _parseMacro(next.text);
        break;
      case Tokens.leftBracket:
        value = _parseList();
        break;
      case Tokens.leftBrace:
        value = _parseMap();
        break;
      case Tokens.string:
        value = next.text;
        break;
      case Tokens.intNum:
        value = next.intNum;
        break;
      case Tokens.doubleNum:
        value = next.doubleNum;
        break;
      default:
        throw Exception('Unexpected token in assignment: ${next.type}');
    }
    return value;
  }

  Object _parseMap() {
    Map<Object, Object> map = <Object, Object>{};
    while (!match(Tokens.rightBrace)) {
      // kvp
      var kvp = _parseKvp();
      map[kvp.key] = kvp.value;
      if (match(Tokens.comma)) {
        consume();
      }
    }
    consume(); // consume right brace
    return map;
  }

  List<Object> _parseList() {
    List<Object> list = [];
    while (!match(Tokens.rightBracket)) {
      list.add(_parseValue());
      if (match(Tokens.comma)) {
        consume();
      }
    }
    consume(); // consume right bracket
    return list;
  }

  KeyValuePair<String, Object> _parseVariable() {
    var identifier = require(Tokens.identifier).text;
    require(Tokens.colon);
    Object value = _parseValue();
    return KeyValuePair(key: identifier, value: value);
  }

  Aeon parse() {
    if (lexer.isEmpty()) return Aeon.empty;
    consume(); // fill up currentToken and nextToken
    consume();
    Map<String, Object> variables = {};
    do {
      if (match(Tokens.atSymbol)) {
        _parseMacroDefinition();
      } else if (match(Tokens.identifier)) {
        var variable = _parseVariable();
        variables[variable.key] = variable.value;
      } else {
        throw Exception('Unexpected token ${_currentToken.type}');
      }
    } while (_currentToken.type != Tokens.EOF);

    return Aeon(variables: variables, macros: macros);
  }

  Token require(Tokens expected) {
    var consumed = consume();
    if (consumed.type != expected)
      throw Exception('Expected token "$expected", found "${consumed.type}"');
    return consumed;
  }

  Token consume() {
    var consumed = _currentToken;
    _currentToken = _nextToken;
    _nextToken = lexer.nextToken();
    return consumed;
  }

  bool match(Tokens expected) {
    if (_currentToken.type != expected) return false;
    return true;
  }
}
