import 'dart:html' as webFile;

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

import '../domain/lint.dart';
import '../services/linter_service.dart';

class HomeController extends ChangeNotifier {
  HomeController({
    required this.service,
  });

  final LintService service;
  final Map<String, Lint> lints = {};

  void fetchLints() async {
    final lints = await service.fetchLints();
    this.lints.addAll(lints);
    notifyListeners();
  }

  void handleSelection(Lint lint, bool isSelected) {
    lints[lint.name] = lint.copyWith(isSelected: isSelected);
    notifyListeners();
  }

  void handleSelectAll() {
    final bool isAllSelected =
        lints.values.every((element) => element.isSelected == true);

    if (isAllSelected) {
      lints.forEach((key, value) {
        lints[key] = value.copyWith(isSelected: false);
      });
    } else {
      lints.forEach((key, value) {
        lints[key] = value.copyWith(isSelected: true);
      });
    }

    notifyListeners();
  }

  void handleUploadFile() async {
    var picked = await FilePickerWeb.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['yaml'],
      type: FileType.custom,
      withData: true,
    );

    if (picked != null && picked.files.isNotEmpty) {
      final file = picked.files.first;
      final fileString = String.fromCharCodes(file.bytes!);

      final fileYaml = loadYaml(fileString) as Map;

      final lintsFromFile = fileYaml['linter']['rules'];

      if (lintsFromFile is Map) {
        lintsFromFile.forEach((key, value) {
          if (value == true && lints.containsKey(key)) {
            lints[key] = lints[key]!.copyWith(isSelected: true);
          }
        });
      } else if (lintsFromFile is List) {
        for (var lint in lintsFromFile) {
          if (lints.containsKey(lint)) {
            lints[lint] = lints[lint]!.copyWith(isSelected: true);
          }
        }
      }
    }

    notifyListeners();
  }

  void handleSaveFile() async {
    var yamlWriter = YAMLWriter(allowUnquotedStrings: true);
    final List<Lint> styleLint =
        lints.values.where((element) => element.isSelected == true).toList();

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
  }
}
