import 'package:flutter/material.dart';
import 'package:linter_editor/app/controllers/home_controller.dart';
import 'package:linter_editor/app/services/linter_service.dart';

import '../widgets/lint_details_modal.dart';
import '../widgets/lint_list_tile_widget.dart';

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

    controller.addListener(() {
      if (!mounted) return;

      if (controller.uploadMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.uploadMessage),
          ),
        );
        controller.uploadMessage = '';
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
                  padding: EdgeInsets.only(
                    top: 16,
                    bottom:
                        MediaQuery.of(context).size.width <= 850 ? 200 : 16.0,
                  ),
                  physics: BouncingScrollPhysics(),
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

                    return Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 768),
                        child: LintListTile(
                          lint: lint,
                          showWarning: showWarning,
                          lintsIncompatible: lintsIncompatible,
                          onTap: () => LintDetailsModal.show(context, lint),
                          onCheckboxChanged: (value) {
                            controller.handleSelection(
                                lint, value ?? lint.isSelected);
                          },
                        ),
                      ),
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
