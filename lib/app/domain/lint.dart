import 'dart:convert';

/// Example
/// ```json
/// {
///    "name": "always_specify_types",
///    "description": "Specify type annotations.",
///    "group": "style",
///    "maturity": "stable",
///    "state": "stable",
///    "incompatible": [
///      "avoid_types_on_closure_parameters",
///      "omit_local_variable_types"
///    ],
///    "sets": [],
///    "fixStatus": "hasFix",
///    "details": "From the [style guide for the flutter repo](https://flutter.dev/style-guide/):\n\n**DO** specify type annotations.\n\nAvoid `var` when specifying that a type is unknown and short-hands that elide\ntype annotations.  Use `dynamic` if you are being explicit that the type is\nunknown.  Use `Object` if you are being explicit that you want an object that\nimplements `==` and `hashCode`.\n\n**BAD:**\n```dart\nvar foo = 10;\nfinal bar = Bar();\nconst quux = 20;\n```\n\n**GOOD:**\n```dart\nint foo = 10;\nfinal Bar bar = Bar();\nString baz = 'hello';\nconst int quux = 20;\n```\n\nNOTE: Using the the `@optionalTypeArgs` annotation in the `meta` package, API\nauthors can special-case type variables whose type needs to by dynamic but whose\ndeclaration should be treated as optional.  For example, suppose you have a\n`Key` object whose type parameter you'd like to treat as optional.  Using the\n`@optionalTypeArgs` would look like this:\n\n```dart\nimport 'package:meta/meta.dart';\n\n@optionalTypeArgs\nclass Key<T> {\n ...\n}\n\nmain() {\n  Key s = Key(); // OK!\n}\n```\n\n",
///    "sinceDartSdk": "2.0.0",
///    "sinceLinter": "0.1.4"
///  },
/// ```
class Lint {
  final String name;
  final String description;
  final String group;
  final String maturity;
  final String state;

  /// ```json
  /// "incompatible": [
  ///    "avoid_types_on_closure_parameters",
  ///    "omit_local_variable_types"
  ///  ],
  /// ```
  final List<String> incompatible;

  /// ```json
  /// "sets": [
  ///    "recommended",
  ///    "flutter"
  ///  ],
  /// ```
  final List<String> sets;
  final String fixStatus;
  final String details;
  final String sinceDartSdk;
  final String sinceLinter;

  final bool isSelected;

  Lint({
    required this.name,
    required this.description,
    required this.group,
    required this.maturity,
    required this.state,
    required this.incompatible,
    required this.sets,
    required this.fixStatus,
    required this.details,
    required this.sinceDartSdk,
    required this.sinceLinter,
    this.isSelected = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'group': group,
      'maturity': maturity,
      'state': state,
      'incompatible': incompatible,
      'sets': sets,
      'fixStatus': fixStatus,
      'details': details,
      'sinceDartSdk': sinceDartSdk,
      'sinceLinter': sinceLinter,
    };
  }

  factory Lint.fromMap(Map<String, dynamic> map) {
    return Lint(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      group: map['group'] ?? '',
      maturity: map['maturity'] ?? '',
      state: map['state'] ?? '',
      incompatible: List<String>.from(map['incompatible']),
      sets: List<String>.from(map['sets']),
      fixStatus: map['fixStatus'] ?? '',
      details: map['details'] ?? '',
      sinceDartSdk: map['sinceDartSdk'] ?? '',
      sinceLinter: map['sinceLinter'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Lint.fromJson(String source) => Lint.fromMap(json.decode(source));

  Lint copyWith({
    String? name,
    String? description,
    String? group,
    String? maturity,
    String? state,
    List<String>? incompatible,
    List<String>? sets,
    String? fixStatus,
    String? details,
    String? sinceDartSdk,
    String? sinceLinter,
    bool? isSelected,
  }) {
    return Lint(
      name: name ?? this.name,
      description: description ?? this.description,
      group: group ?? this.group,
      maturity: maturity ?? this.maturity,
      state: state ?? this.state,
      incompatible: incompatible ?? this.incompatible,
      sets: sets ?? this.sets,
      fixStatus: fixStatus ?? this.fixStatus,
      details: details ?? this.details,
      sinceDartSdk: sinceDartSdk ?? this.sinceDartSdk,
      sinceLinter: sinceLinter ?? this.sinceLinter,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
