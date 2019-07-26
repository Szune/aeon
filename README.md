# Aeon

Awfully exciting object notation

### Example file
```
@name("first", "last") # macro
people: [name("Erik", "Peopleson"), name("France", "Thecountry")]
```

### Usage
```dart
var aeon = Aeon.fromText(text: text);
var name = aeon['people'][0]['first'] + ' ' + aeon['people'][0]['last'];
print(name);
```

### Comments
Comments start with a '#' symbol.
```
# comments are allowed on their own lines
thing: "text" # and at the end of lines
```

### Supported types
- Lists - ["This", "is", "a list of strings"]
- Maps - {"this": "is", "a": "map of string keys and string values"}
- Integers
- Decimal numbers  - Use a dot '.' as the decimal separator
- Strings - Use double quotes, e.g. "this is a string"

### Macros
Macros are parsed as maps of string keys and object values (Map<String, Object>).

Macros start with an '@' symbol, followed by an identifier and a list of arguments.
E.g. @identifier("argument1", "argument2", "argument3")

Macros need to be defined before they are used, preferably at the start of the file, before any variables.

Macro identifiers can also be used as variable identifiers, as shown in the example:
```
@user("name", "password") # defining the macro
users: [user("test", "test"), user("testUser", "testPassword2")] # using the macro in a list
user: user("username", "password") # using the macro for a scalar variable
# the equivalent of the 'user' variable above, without macros, would be:
user: {"name": "username", "password": "password"}
```

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
