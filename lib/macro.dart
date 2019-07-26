import 'package:aeon/src/key_value_pair.dart';

class Macro {
  Macro({this.name, List<String> args}) {
    _args = args ?? [];
  }
  List<String> _args = [];
  final String name;
  void addArgument(String arg) => _args.add(arg);
  int get length => _args.length;
  String operator [](int index) => _args[index];

  KeyValuePair<String, Object> transform(int index, Object value) {
    return KeyValuePair<String, Object>(key: _args[index], value: value);
  }
}
