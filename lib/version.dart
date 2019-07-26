class Version {
  Version(this.major, this.minor, this.build);
  final int major, minor, build;

  String asString() {
    return '$major.$minor.$build';
  }

  @override
  String toString() {
    return asString();
  }
}
