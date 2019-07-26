class KeyValuePair<K, V> {
  /// const constructor
  const KeyValuePair.constant({this.key, this.value});
  KeyValuePair({this.key, this.value});
  final K key;
  final V value;
}
