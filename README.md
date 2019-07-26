# aeon

Awfully exciting object notation

Example file:
```
'0.0.1 people_file (-1)
@name("first", "last") # macro
people: [name("Erik", "Person"), name("Karl", "Patrik")]
# after parsing, the above becomes:
people_expanded: [{"first": "Erik", "last": "Person"}, {"first": "Karl", "last": "Patrik"}]
```

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
