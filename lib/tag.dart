import 'package:aeon/version.dart';

class Tag {
  Tag({this.version, this.name, this.checksum = -1});
  final Version version;
  final String name;
  final int checksum;
}
