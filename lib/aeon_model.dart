import 'package:aeon/aeon.dart';

/// Classes including this mixin should provide a named constructor as such: ClassName.fromAeon([Aeon] aeon)
///
/// Said constructor should convert an [Aeon] to the implementing class
mixin AeonModel {
  /// Converts the implementing class to an [Aeon]
  Aeon toAeon();
}
