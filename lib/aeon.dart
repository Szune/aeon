library aeon;

import 'src/aeon_parser.dart';
import 'src/key_value_pair.dart';
import 'src/lexer.dart';

part 'aeon_model.dart';
part 'macro.dart';

/// Awfully exciting object notation
class Aeon {
  const Aeon.constant({this.variables, this.macros});
  Aeon({
    this.variables = const {},
    this.macros = const {},
  }) : assert(variables != null, macros != null);
  final Map<String, dynamic> variables;
  final Map<String, Macro> macros;

  dynamic get(String variable) {
    return variables[variable];
  }

  dynamic operator [](String key) => variables != null ? variables[key] : null;

  static Aeon fromText({String text}) {
    var lexer = Lexer(text: text);
    var parser = AeonParser(lexer: lexer);
    return parser.parse();
  }

  String toText() {
    var buf = StringBuffer();
    for (var macro in macros.entries) {
      writeMacro(buf, macro.key, macro.value);
    }
    for (var kvp in variables.entries) {
      buf.write(kvp.key);
      buf.write(': ');
      _writeLongValue(buf, kvp.value);
      buf.writeln();
    }
    return buf.toString();
  }

  static void writeMacro(StringBuffer buf, String macroName, Macro macro) {
    buf.write('@');
    buf.write(macroName);
    buf.write('(');
    var first = true;
    for (int i = 0; i < macro.length; i++) {
      if (first)
        first = false;
      else
        buf.write(', ');
      _writeValue(buf, macro[i]);
    }
    buf.writeln(')');
  }

  static void _writeValue(StringBuffer buf, Object value) {
    if (value is String) {
      buf.write('"');
      buf.write(_escapeString(value));
      buf.write('"');
    } else {
      buf.write(value);
    }
  }

  Macro getMacroWithKeys(Iterable keys) {
    if (macros == null) return null;
    var sameArguments = 0;
    for (var macro in macros.values) {
      for (int i = 0; i < macro.length; i++) {
        if (keys.contains(macro[i])) sameArguments++;
      }
      if (sameArguments == macro.length) {
        return macro;
      }
      sameArguments = 0;
    }
    return null;
  }

  void _writeLongValue(StringBuffer buf, Object value) {
    if (value is Map) {
      _writeMap(buf, value);
    } else if (value is List) {
      _writeList(buf, value);
    } else if (value is Set) {
      _writeList(buf, value);
    } else {
      _writeValue(buf, value);
    }
  }

  void _writeMap(StringBuffer buf, Map value) {
    bool first = true;
    var macro = getMacroWithKeys(value.keys);
    if (macro == null) {
      // no macro for this set of keys
      buf.write('{');
      for (var kvp in value.entries) {
        if (first)
          first = false;
        else
          buf.write(', ');
        _writeValue(buf, kvp.key);
        buf.write(': ');
        _writeLongValue(buf, kvp.value);
      }
      buf.write('}');
    } else {
      // write out macro instead of keys
      buf.write(macro.name);
      buf.write('(');
      for (int i = 0; i < macro.length; i++) {
        if (first)
          first = false;
        else
          buf.write(', ');
        _writeLongValue(buf, value[macro[i]]);
      }
      buf.write(')');
    }
  }

  void _writeList(StringBuffer buf, Iterable value) {
    buf.write('[');
    bool first = true;
    for (var val in value) {
      if (first)
        first = false;
      else
        buf.write(', ');
      _writeLongValue(buf, val);
    }
    buf.write(']');
  }

  static String _escapeString(String value) {
    return value.replaceAll('"', '\\"');
  }

  static const Aeon empty = Aeon.constant(
    variables: {},
    macros: {},
  );
}
