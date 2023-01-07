import 'package:flutter/material.dart';
import 'package:linter_editor/app/controllers/home_controller.dart';
import 'package:linter_editor/app/services/linter_service.dart';

import '../lint_details_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = HomeController(service: LintService());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.fetchLints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
        title: const Text(
          "Flutter Linter Editor",
        ),
      ),
      body: Scrollbar(
        controller: scrollController,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            constraints: BoxConstraints(maxWidth: 768),
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                if (controller.lints.isNotEmpty) {
                  final lints = controller.lints;

                  return ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      scrollbars: false,
                    ),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: lints.length,
                      itemBuilder: (context, index) {
                        final lint = lints.values.elementAt(index);
                        final List<String> lintsIncompatible = [];

                        for (String incompatible in lint.incompatible) {
                          if (lints[lint.name]?.isSelected ?? false) {
                            lintsIncompatible.add(incompatible);
                          }
                        }

                        final bool showWarning =
                            lintsIncompatible.isNotEmpty && lint.isSelected;

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
                                  if (lint.sets.isEmpty &&
                                      lint.fixStatus != 'hasFix') {
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
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.warning_rounded,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            "Incompatible with: ${lintsIncompatible.join(", ")}",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w300,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          trailing: Checkbox(
                            value: lint.isSelected,
                            onChanged: (value) {
                              controller.handleSelection(
                                  lint, value ?? lint.isSelected);
                            },
                          ),
                          onTap: () => LintDetailsModal.show(context, lint),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.blue.shade900,
            child: const Icon(Icons.done_all_rounded),
            onPressed: controller.handleSelectAll,
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            backgroundColor: Colors.blue.shade900,
            child: const Icon(Icons.upload_rounded),
            onPressed: controller.handleUploadFile,
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            backgroundColor: Colors.green.shade900,
            child: const Icon(Icons.download_rounded),
            onPressed: controller.handleSaveFile,
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
