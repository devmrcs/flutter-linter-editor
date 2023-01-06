import 'dart:html' as webFile;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:linter_editor/app/services/linter_service.dart';
import 'package:yaml_writer/yaml_writer.dart';

import 'domain/lint.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Lint>>? _future;
  final lintsSelected = <String, Lint>{};
  var lints = <Lint>[];

  @override
  void initState() {
    super.initState();

    _future = LintService().getLints();
  }

  void handleTapLint(Lint lint) {
    setState(() {
      if (lintsSelected.containsKey(lint.name)) {
        lintsSelected.remove(lint.name);
      } else {
        lintsSelected[lint.name] = lint;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        title: const Text(
          "Linter Editor",
        ),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final lints = snapshot.data as List<Lint>;
            this.lints = lints;

            return ListView.builder(
              itemCount: lints.length,
              itemBuilder: (context, index) {
                final lint = lints[index];
                final List<String> lintsIncompatible = [];

                for (String incompatible in lint.incompatible) {
                  if (lintsSelected.containsKey(incompatible)) {
                    lintsIncompatible.add(incompatible);
                  }
                }

                final bool showWarning = lintsIncompatible.isNotEmpty &&
                    lintsSelected.containsKey(lint.name);

                return ListTile(
                  title: Text(
                    lint.name,
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Builder(builder: (context) {
                          if (lint.sets.isEmpty && lint.fixStatus != 'hasFix') {
                            return const SizedBox.shrink();
                          }
                          final List<Widget> widgets = [];

                          for (String set in lint.sets)
                            widgets.add(BadgeLint(set: set));

                          if (lint.fixStatus == 'hasFix')
                            widgets.add(const BadgeLint(
                              set: 'has fix',
                            ));

                          return Wrap(
                            spacing: 8,
                            direction: Axis.horizontal,
                            children: widgets,
                          );
                        }),
                        Text(
                          lint.description,
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                        if (showWarning)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_rounded,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Incompatible with: ${lintsIncompatible.join(", ")}",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  trailing: Checkbox(
                    value: lintsSelected.containsKey(lint.name),
                    onChanged: (value) => handleTapLint(lint),
                  ),
                  onTap: () => handleTapLint(lint),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.red.shade800,
            child: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                lintsSelected.clear();
              });
            },
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            backgroundColor: Colors.blue.shade900,
            child: const Icon(Icons.done_all_rounded),
            onPressed: () {
              setState(() {
                lintsSelected.clear();
                for (var lint in lints) {
                  lintsSelected[lint.name] = lint;
                }
              });
            },
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            backgroundColor: Colors.green.shade900,
            child: const Icon(Icons.save),
            onPressed: () {
              var yamlWriter = YAMLWriter(allowUnquotedStrings: true);
              final List<Lint> styleLint = lintsSelected.values.toList();

              final Map<String, String> errorsMap = {
                "missing_required_param": "error",
                "missing_return": "error"
              };

              final Map<String, bool> lintsMap = {};
              for (var element in styleLint) {
                lintsMap[element.name] = true;
              }

              var yamlDoc = yamlWriter.write({
                "analyzer": {
                  "errors": errorsMap,
                },
                "linter": {
                  "rules": lintsMap,
                },
              });

              if (kIsWeb) {
                var blob = webFile.Blob([yamlDoc], 'text/plain', 'native');

                webFile.AnchorElement(
                  href: webFile.Url.createObjectUrlFromBlob(blob).toString(),
                )
                  ..setAttribute("download", "analysis_options.yaml")
                  ..click();
              }
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class BadgeLint extends StatelessWidget {
  const BadgeLint({
    Key? key,
    required this.set,
  }) : super(key: key);

  final String set;

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (set) {
      case "core":
        color = Colors.blue.shade700;
        break;
      case "recommended":
        color = Colors.blue.shade800;
        break;
      case "flutter":
        color = Colors.blue.shade900;
        break;
      case "has fix":
        color = Colors.lightGreen.shade500;
        break;
      default:
        color = Colors.blue;
    }

    return DefaultTextStyle(
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w300,
        fontSize: 11,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: set != 'has fix',
            child: Container(
              color: Colors.grey.shade700,
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 2,
              ),
              child: Text('style'),
            ),
          ),
          Container(
            color: color,
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 2,
            ),
            child: Text(set),
          ),
        ],
      ),
    );
  }
}
