import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:linter_editor/app/domain/lint.dart';

class LintService {
  final dio = Dio();

  Future<List<Lint>> getLints() async {
    String mock = await rootBundle.loadString('assets/mock_response.json');
    final body = json.decode(mock);
    final lints =
        (body as List<dynamic>).map((map) => Lint.fromMap(map)).toList();

    return lints;

    final response = await dio.get(
      'https://raw.githubusercontent.com/dart-lang/linter/gh-pages/lints/machine/rules.json',
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.data);
      final lints =
          (body as List<dynamic>).map((map) => Lint.fromMap(map)).toList();

      return lints;
    } else {
      throw Exception('Failed to load lints');
    }
  }
}
