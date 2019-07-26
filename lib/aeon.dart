library aeon;

import 'package:aeon/src/aeon_parser.dart';
import 'package:aeon/src/lexer.dart';
import 'package:aeon/macro.dart';
import 'package:aeon/tag.dart';
import 'package:aeon/version.dart';

/// Awfully exciting object notation
class Aeon {
  Aeon({
    this.tag,
    this.variables,
    this.macros,
  });
  final Tag tag;
  final Map<String, Object> variables;
  final Map<String, Macro> macros;

  Object get(String variable) {
    return variables[variable];
  }

  Object operator [](String key) => variables != null ? variables[key] : null;

  List<T> list<T>(String varName) {
    return List<T>.from(variables[varName] ?? []);
  }

  Set<T> set<T>(String varName) {
    return Set<T>.from(variables[varName] ?? {});
  }

  Map<K, V> map<K, V>(String varName) {
    return Map<K, V>.from(variables[varName] ?? {});
  }

  static Aeon fromText({String text}) {
    var lexer = Lexer(text: text);
    var parser = AeonParser(lexer: lexer);
    // update to check integrity through checksum
    return parser.parse();
  }

  String toText() {
    var buf = StringBuffer();
    if (tag != null) {
      buf.write("'");
      buf.write(tag.version);
      buf.write(' ');
      buf.write(tag.name);
      buf.write(' (');
      buf.write(tag.checksum); // update to calculate checksum
      buf.writeln(')');
    }
    macros?.forEach((macroName, macro) {
      writeMacro(buf, macroName, macro);
    });
    variables?.forEach((key, value) {
      buf.write(key);
      buf.write(': ');
      _writeLongValue(buf, value);
      buf.writeln();
    });
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
      buf.write(_escapeString(value));
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
      value.forEach((k, v) {
        if (first)
          first = false;
        else
          buf.write(', ');
        _writeValue(buf, k);
        buf.write(': ');
        _writeLongValue(buf, v);
      });
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
    value.forEach((e) {
      if (first)
        first = false;
      else
        buf.write(', ');
      _writeLongValue(buf, e);
    });
    buf.write(']');
  }

  static String _escapeString(String value) {
    return '"${value.replaceAll('"', '\\"')}"';
  }

  static final Aeon _empty = Aeon(
    tag: Tag(version: Version(-1, -1, -1), checksum: -1, name: 'empty'),
    variables: {},
  );
  static Aeon get empty => _empty;
}
